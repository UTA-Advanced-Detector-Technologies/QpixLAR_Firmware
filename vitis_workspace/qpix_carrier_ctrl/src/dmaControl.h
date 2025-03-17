#include "helper.h"

#ifndef _DMA_CTRL
#define _DMA_CTRL

int Init_Qpix_DMA(u32 base_addr, XAxiDma* dma, u32* rxBase, u32* txBase);

// extern u32* Tx_0_BufferPtr;
// extern u32* Rx_0_BufferPtr;
extern volatile u32 TxDone;
extern volatile u32 Error;
extern volatile u32 RxDone;

#endif