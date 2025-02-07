#ifndef _HELPER
#define _HELPER

#include "platform.h"
#include "xil_io.h"

// local includes
#include "iic_ctrl.h"
#include "ethControl.h"

// ASCII 0C2I with endian-ness
#define I2C_PACKET 0x00433249

u32 HandleCmdRequest(u32* RxBuf, u32** TxLoc, u32 TransferSize);


#endif
