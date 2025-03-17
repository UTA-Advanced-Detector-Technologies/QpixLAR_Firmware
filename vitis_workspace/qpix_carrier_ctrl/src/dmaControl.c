#include "dmaControl.h"
#include "udp_server.h"
#include <sleep.h>
#include <xil_types.h>

volatile u32 Error = 0;
volatile u32 TxDone = 0;
volatile u32 RxDone = 0;

/*
 * DMA Controls
*/
static void RxArmDMA(u32 src_addr, u32 dest_addr)
{
    u32 ctrl = 0x00001001;
    Xil_Out32(src_addr+0x30, ctrl);      // s2mm ctrl
    Xil_Out32(src_addr+0x48, dest_addr); // s2mm dest addr, low
    Xil_Out32(src_addr+0x4c, dest_addr+0x2FFFFFF); // s2mm dest addr, high
    Xil_Out32(src_addr+0x58, 0xFFFFF);   // max num packets s2mm can receive
}

static void TxArmDMA(u32 src_addr, u32 dest_addr)
{
    Xil_Out32(src_addr+0x18, dest_addr); // mm2s source addr, low
}

static int InitDMA(u32 base_addr, XAxiDma* dma, u32* rxBase, u32* txBase, 
                void (*txHandle)(void *), void (*rxHandle)(void *))
{
    int Status;
    XAxiDma_Config *Config;
    Config = XAxiDma_LookupConfig(base_addr);
    if (!Config) {
        xil_printf("No config found for %d\r\n", base_addr);
        return XST_FAILURE;
    }

    /* Initialize DMA engine */
    Status = XAxiDma_CfgInitialize(dma, Config);
    if (Status != XST_SUCCESS) {
        xil_printf("Initialization failed %d\r\n", Status);
        return XST_FAILURE;
    }

    /* Set up Interrupt system  */
    Status = XSetupInterruptSystem(dma, rxHandle,
                       Config->IntrId[0], Config->IntrParent,
                       XINTERRUPT_DEFAULT_PRIORITY);
    if (Status != XST_SUCCESS) {
        xil_printf("ERROR, unable to configure interrupt tx \r\n");
        return XST_FAILURE;
    }
    // disabled mm2s configuration as this DMA only receives streams
    // Status = XSetupInterruptSystem(dma, txHandle,
    //                    Config->IntrId[1], Config->IntrParent,
    //                    XINTERRUPT_DEFAULT_PRIORITY);
    // if (Status != XST_SUCCESS) {
    //     xil_printf("ERROR, unable to configure interrupt tx \r\n");
    //     return XST_FAILURE;
    // }

    /* Disable all interrupts before setup */
    XAxiDma_IntrDisable(dma, XAXIDMA_IRQ_ALL_MASK,
                XAXIDMA_DMA_TO_DEVICE);
    XAxiDma_IntrDisable(dma, XAXIDMA_IRQ_ALL_MASK,
                XAXIDMA_DEVICE_TO_DMA);

    /* Enable all interrupts */
    XAxiDma_IntrEnable(dma, XAXIDMA_IRQ_ALL_MASK,
               XAXIDMA_DMA_TO_DEVICE);
    XAxiDma_IntrEnable(dma, XAXIDMA_IRQ_ALL_MASK,
               XAXIDMA_DEVICE_TO_DMA);

    /* Flush the buffers before the DMA transfer, in case the Data Cache
     * is enabled
     */
    Xil_DCacheFlushRange((UINTPTR)txBase, MAX_PKT_LEN_RX*8);
    Xil_DCacheFlushRange((UINTPTR)rxBase, MAX_PKT_LEN_TX*8);

    /* 
     * Config base and control registers to set pathing
    */
    RxArmDMA(base_addr, (u32)rxBase);
    TxArmDMA(base_addr, (u32)txBase);

    return Status;
}

// Rx nodal interrupt function wrappers
static void RxUDPIntrHandler(void *Callback, u32 base_addr, u32* rx_addr)
{
    static int recv_packets = 0;
    int TimeOut;
    XAxiDma *AxiDmaInst = (XAxiDma *)Callback;

    u32 reg_stat = Xil_In32(base_addr+0x34); // read s2mm status reg

    /* Acknowledge pending interrupts */
    XAxiDma_IntrAckIrq(AxiDmaInst, reg_stat, XAXIDMA_DEVICE_TO_DMA);

    /*
     * If no interrupt is asserted, we do not do anything
     */
    if (!(reg_stat & XAXIDMA_IRQ_ALL_MASK)) {
        xil_printf("Rx interrupt asserted, error \r\n");
        return;
    }

    /*
     * If error interrupt is asserted, raise error flag, reset the
     * hardware to recover from the error, and return with no further
     * processing.
     */
    if ((reg_stat & XAXIDMA_IRQ_ERROR_MASK)) {
        xil_printf("reg stat err at RxIntrHandler: %x \r\n", reg_stat);
        Error = 1;

        /* Reset could fail and hang
         * NEED a way to handle this or do not call it??
         */
        XAxiDma_Reset(AxiDmaInst);
        TimeOut = RESET_TIMEOUT_COUNTER;

        while (TimeOut) {
            if (XAxiDma_ResetIsDone(AxiDmaInst)) {
                xil_printf("Rx timeout error \r\n");
                Xil_Out32(base_addr+0x34, reg_stat);
                Xil_Out32(base_addr+0x58, 0xFFFF);
                break;
            }
            TimeOut -= 1;
        }
        return;
    }

    /*
     * If completion interrupt is asserted, then set RxDone flag
     */
    if ((reg_stat & XAXIDMA_IRQ_IOC_MASK)) {
        recv_packets += 1;
        // read the input packets
        u32 RxDataLen = Xil_In32(base_addr+0x58);
        Xil_DCacheFlushRange((UINTPTR)rx_addr, RxDataLen);

        if(tcp_connection)
        {
            // xil_printf("sending udp packet\r\n");
            udp_packet_send(rx_addr, RxDataLen);
        }

        // re-arm the DMA
        Xil_Out32(base_addr+0x58, 0xFFFFF);  // max num packets s2mm can receive
        RxDone = 1;
        Xil_Out32(TREG_ADDR, recv_packets);
    }else {
        xil_printf("enountered RxIntr Error \r\n");
    }
}

// wrapper to the udp handler function so when DMA flags new RX data it can be 
// sent over UDP
static void RxIntrHandler(void *Callback)
{
    RxUDPIntrHandler(Callback, XPAR_AXI_DMA_0_BASEADDR, RX_ETH_BUFFER_BASE);
}

// Tx functions
static void TxIntrHandler(void* Callback)
{
    u32 IrqStatus;
    int TimeOut;
    XAxiDma *AxiDmaInst = (XAxiDma *)Callback;

    /* Read pending interrupts */
    IrqStatus = XAxiDma_IntrGetIrq(AxiDmaInst, XAXIDMA_DMA_TO_DEVICE);

    /* Acknowledge pending interrupts */
    XAxiDma_IntrAckIrq(AxiDmaInst, IrqStatus, XAXIDMA_DMA_TO_DEVICE);

    /*
     * If no interrupt is asserted, we do not do anything
     */
    if (!(IrqStatus & XAXIDMA_IRQ_ALL_MASK)) {
        xil_printf("No Tx Interrupt Asserted.. \r\n");
        return;
    }

    /*
     * If error interrupt is asserted, raise error flag, reset the
     * hardware to recover from the error, and return with no further
     * processing.
     */
    if ((IrqStatus & XAXIDMA_IRQ_ERROR_MASK)) {
        Error = 1;
        xil_printf("TxData Async error.. \r\n");

        XAxiDma_Reset(AxiDmaInst);

        TimeOut = RESET_TIMEOUT_COUNTER;

        while (TimeOut) {
            if (XAxiDma_ResetIsDone(AxiDmaInst)) {
                break;
            }
            xil_printf("TxData timeout error.. \r\n");
            TimeOut -= 1;
        }

        return;
    }

    if ((IrqStatus & XAXIDMA_IRQ_IOC_MASK)) {
        TxDone = 1;
    }
}

// expose DMA initialization function
int Init_Qpix_DMA(u32 base_addr, XAxiDma* dma, u32* rxBase, u32* txBase)
{
    return InitDMA(base_addr, dma, rxBase, txBase, TxIntrHandler, RxIntrHandler);
}