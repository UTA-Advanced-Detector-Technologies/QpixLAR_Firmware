#include "iic_ctrl.h"
#include "xinterrupt_wrap.h"
#include <xstatus.h>

XIicPs Iic;
// XScuGic InterruptController;	/* Instance of the Interrupt Controller */

/*
 * The following counters are used to determine when the entire buffer has
 * been sent and received.
 */
volatile u32 SendComplete;
volatile u32 RecvComplete;
volatile u32 TotalErrorCount;

int XIicPsSmbusMasterInit(UINTPTR BaseAddress)
{
	int Status;
	XIicPs_Config *Config;

	/*
	 * Initialize the IIC driver so that it's ready to use
	 * Look up the configuration in the config table, then initialize it.
	 */
	Config = XIicPs_LookupConfig(BaseAddress);

	if (NULL == Config) {
		return XST_FAILURE;
	}

	Status = XIicPs_CfgInitialize(&Iic, Config, Config->BaseAddress);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Perform a self-test to ensure that the hardware was built correctly.
	 */
	Status = XIicPs_SelfTest(&Iic);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Connect the IIC to the interrupt subsystem such that interrupts can
	 * occur. This function is application specific.
	 */
	Status = XSetupInterruptSystem(&Iic, XIicPs_MasterInterruptHandler,
				       Config->IntrId,
				       Config->IntrParent,
				       XINTERRUPT_DEFAULT_PRIORITY);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Setup the handlers for the IIC that will be called from the
	 * interrupt context when data has been sent and received, specify a
	 * pointer to the IIC driver instance as the callback reference so
	 * the handlers are able to access the instance data.
	 */
	XIicPs_SetStatusHandler(&Iic, (void *) &Iic, Handler);

	/*
	 * Set the IIC serial clock rate.
	 */
	XIicPs_SetSClk(&Iic, IIC_SCLK_RATE);


	return XST_SUCCESS;
}


void Handler(void *CallBackRef, u32 Event)
{
	/*
	 * All of the data transfer has been finished.
	 */
	if (0 != (Event & XIICPS_EVENT_COMPLETE_RECV)) {
		RecvComplete = TRUE;
	} else if (0 != (Event & XIICPS_EVENT_COMPLETE_SEND)) {
		SendComplete = TRUE;
	} else if (0 == (Event & XIICPS_EVENT_SLAVE_RDY)) {
		/*
		 * If it is other interrupt but not slave ready interrupt, it is
		 * an error.
		 * Data was received with an error.
		 */
		TotalErrorCount++;
	}
}

//
// custom wrappers for ez life
//
int SetupIIC()
{
    /*
	* init the iic master
	*/
	if (XIicPsSmbusMasterInit(XIICPS_BASEADDRESS) != XST_SUCCESS) {
		xil_printf("SMBus Master Interrupt Example Test Failed\r\n");
		return XST_FAILURE;
	}
    return XST_SUCCESS;
}

// master send
int IicSend(u8* msg, s32 byteCnt, u16 i2c_addr)
{
	TotalErrorCount = 0;
	SendComplete = FALSE;
	XIicPs_MasterSend(&Iic, msg, byteCnt, i2c_addr);
	while (!SendComplete) {
		if (0 != TotalErrorCount) {
            break;
		}
	}
	xil_printf("SMBus Master Send: error count = 0x%x \r\n", TotalErrorCount);
    if(TotalErrorCount > 0)
        return XST_FAILURE;
    else
        return XST_SUCCESS;
}

// master recv
int IicRecv(u8* msg, s32 byteCnt, u16 i2c_addr, u8* cmd, s32 cmdCnt)
{
    // if we need to send a command / pointer byte first to prep the receive:
    if(cmdCnt > 0)
    {
        XIicPs_SetOptions(&Iic, XIICPS_REP_START_OPTION);
	    TotalErrorCount = 0;
	    SendComplete = FALSE;

        /*
        * Send the buffer, errors are reported by TotalErrorCount.
        */
        XIicPs_MasterSend(&Iic, cmd, cmdCnt, i2c_addr);
        while (!SendComplete) {
            if (0 != TotalErrorCount) {
                return XST_FAILURE;
            }
	    }

        XIicPs_ClearOptions(&Iic, XIICPS_REP_START_OPTION);
        XIicPs_DisableAllInterrupts(Iic.Config.BaseAddress);
        (void)XIicPs_ReadReg(Iic.Config.BaseAddress, (u32)XIICPS_ISR_OFFSET);
    }

    // receive
	TotalErrorCount = 0;
	RecvComplete = FALSE;
	XIicPs_MasterRecv(&Iic, msg, byteCnt,
			  i2c_addr);

	while (!RecvComplete) {
		if (0 != TotalErrorCount) {
			return XST_FAILURE;
		}
	}
    // xil_printf("SMBus Master Recv: error count = 0x%x \r\n", TotalErrorCount);
    if(TotalErrorCount > 0)
        return XST_FAILURE;
    else
        return XST_SUCCESS;
}