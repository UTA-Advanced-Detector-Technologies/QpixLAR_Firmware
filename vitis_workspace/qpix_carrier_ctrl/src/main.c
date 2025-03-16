#include <stdio.h>
#include <xstatus.h>
#include "platform.h"
#include "xil_printf.h"

#include "helper.h"

static int test_iic();

u32* TxEthBufferPtr;

int main()
{
    TxEthBufferPtr = (u32 *)TX_ETH_BUFFER_BASE;

    init_platform();
	xil_printf("QPIX-LAR Init\r\n");

    // configure I2C master
    // int ret = test_iic();

    // opens the TCP socket and begins DHCP, if BSP is configured to do so
    SetupEthernet();

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