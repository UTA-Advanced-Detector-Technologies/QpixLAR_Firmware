#include "xiicps.h"
#include "xscugic.h"
#include "xparameters.h"

#define XIICPS_BASEADDRESS	XPAR_XIICPS_1_BASEADDR
#define IIC_DEVICE_ID		XPAR_XIICPS_1_DEVICE_ID
#define INTC_DEVICE_ID		XPAR_SCUGIC_SINGLE_DEVICE_ID
#define IIC_INT_VEC_ID		XPAR_XIICPS_1_INTR

/*
 * The slave address to send to and receive from.
 */
#define IIC_SLAVE_ADDR_1	0x0C // LVDS_CM, port 0 only
#define IIC_SLAVE_ADDR_2	0x0D // VCM1 & VCM2, uses both ports

#define IIC_SCLK_RATE		100000

/*
 * The following constant controls the length of the buffers to be sent
 * and received with the IIC.
 */
#define TEST_BUFFER_SIZE   	1

/*
 * The following counters are used to determine when the entire buffer has
 * been sent and received.
 */
extern volatile u32 SendComplete;
extern volatile u32 RecvComplete;
extern volatile u32 TotalErrorCount;

extern XIicPs Iic;

/*****************************************************************************/
/**
*
* modified from SMBus intr master example to initialize the smbus controller
* @param	DeviceId is the Device ID of the IicPs Device and is the
*		XPAR_<IICPS_instance>_DEVICE_ID value from xparameters.h
*
* @return	XST_SUCCESS if successful, otherwise XST_FAILURE.
*
* @note
*******************************************************************************/
int XIicPsSmbusMasterInit(UINTPTR BaseAddress);


/*****************************************************************************/
/**
*
* This function is the handler which performs processing to handle data events
* from the IIC.  It is called from an interrupt context such that the amount
* of processing performed should be minimized.
*
* This handler provides an example of how to handle data for the IIC and
* is application specific.
*
* @param	CallBackRef contains a callback reference from the driver, in
*		this case it is the instance pointer for the IIC driver.
* @param	Event contains the specific kind of event that has occurred.
*
* @return	None.
*
* @note		None.
*
*******************************************************************************/
void Handler(void *CallBackRef, u32 Event);

//
// custom wrappers for ez life
int SetupIIC();
int IicSend(u8* msg, s32 byteCnt, u16 i2c_addr);
int IicRecv(u8* msg, s32 byteCnt, u16 i2c_addr, u8* cmd, s32 cmdCnt);