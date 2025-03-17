#include <stdio.h>
#include <xaxidma.h>
#include <xstatus.h>
#include "platform.h"
#include "xparameters.h"
#include "xil_printf.h"

#include "dmaControl.h"
#include "helper.h"

static int test_iic();

u32* TxEthBufferPtr;
u32* RxEthBufferPtr;

u32* TxDMABufferPtr;
u32* RxDMABufferPtr;

XAxiDma dma;

int main()
{
    TxEthBufferPtr = (u32 *)TX_ETH_BUFFER_BASE;
    RxEthBufferPtr = (u32 *)RX_ETH_BUFFER_BASE;

    TxDMABufferPtr = (u32 *)TX_DMA_BUFFER_BASE;
    RxDMABufferPtr = (u32 *)RX_DMA_BUFFER_BASE;

    init_platform();
	xil_printf("QPIX-LAR Init\r\n");

    Init_Qpix_DMA(XPAR_AXI_DMA_0_BASEADDR, &dma, RxDMABufferPtr, TxDMABufferPtr);
    
    // configure I2C master
    // int ret = test_iic();

    // opens the TCP socket and begins DHCP, if BSP is configured to do so
    unsigned char mac_addr[6] = {0x00, 0x12, 0x34, 0x33, 0x1, 0x2};
    SetupEthernet(mac_addr);

    while(1)
    {        
        // ethernet handler intro
		if (TcpFastTmrFlag) {
			tcp_fasttmr();
			TcpFastTmrFlag = 0;
		}
		if (TcpSlowTmrFlag) {
			tcp_slowtmr();
			TcpSlowTmrFlag = 0;
		}
		xemacif_input(echo_netif);
		transfer_data();
    } // main loop

    cleanup_platform();
    return 0;
}

static int test_iic()
{
    SetupIIC();

    char cmd = 0x08;

    // test send
    u8 SendBuffer[] = {cmd, 0x1};
    IicSend(SendBuffer, sizeof(SendBuffer), IIC_SLAVE_ADDR);

    // test recv
    u8 RecvBuffer[] = {0,0,0,0,0,0,0,0,0};
    u8 cmdBuf[] = {0}; // set addr cmd to zero
    IicRecv(RecvBuffer, sizeof(RecvBuffer), IIC_SLAVE_ADDR,
                      cmdBuf, sizeof(cmdBuf));

    // test send
    u8 SendBuffer1[] = {0x03, 0x2f, 0x55};
    IicSend(SendBuffer1, sizeof(SendBuffer1), 0x0c);

    // test send
    u8 SendBuffer2[] = {0x03, 0x2f, 0x55};
    IicSend(SendBuffer2, sizeof(SendBuffer2), 0x0d);


	xil_printf("Successfully ran SMBus Master Interrupt Example Test\r\n");    
    return XST_SUCCESS;
}