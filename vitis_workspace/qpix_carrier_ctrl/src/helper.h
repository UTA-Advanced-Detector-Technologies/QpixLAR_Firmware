#ifndef _HELPER
#define _HELPER

#include "platform.h"
#include "xil_io.h"
#include "xaxidma.h"
#include <xaxidma_hw.h>
// #include "xbram.h"
#include "xinterrupt_wrap.h"

// local includes
#include "iic_ctrl.h"
#include "ethControl.h"

// ASCII 0C2I with endian-ness
#define I2C_PACKET 0x00433249
// ASCII 0IPS with endian-ness
#define SPI_PACKET 0x00495053
// ASCII XIPQ with endian-ness
#define QPIX_PACKET 0x58495051
// ASCII LRTC with endian-ness
#define CTRL_PACKET 0x4C525443

#define MAX_PKT_LEN_TX 1000
#define MAX_PKT_LEN_RX 1000

#define RX_DMA_BUFFER_BASE 0x0C000000
#define TX_DMA_BUFFER_BASE 0x0D000000

#define TREG_ADDR XPAR_AXILITESLAVESIMPLE_0_BASEADDR
#define RESET_TIMEOUT_COUNTER   10000

u32 HandleCmdRequest(u32* RxBuf, u32** TxLoc, u32 TransferSize);

/*
Misc helpers
*/
#define BYTE_TO_BINARY_PATTERN "%c%c%c%c%c%c%c%c"
#define BYTE_TO_BINARY(byte)  \
  ((byte) & 0x80 ? '1' : '0'), \
  ((byte) & 0x40 ? '1' : '0'), \
  ((byte) & 0x20 ? '1' : '0'), \
  ((byte) & 0x10 ? '1' : '0'), \
  ((byte) & 0x08 ? '1' : '0'), \
  ((byte) & 0x04 ? '1' : '0'), \
  ((byte) & 0x02 ? '1' : '0'), \
  ((byte) & 0x01 ? '1' : '0') 
// printf("Leading text "BYTE_TO_BINARY_PATTERN, BYTE_TO_BINARY(byte));
// printf("m: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
//   BYTE_TO_BINARY(m>>8), BYTE_TO_BINARY(m));

#endif
