/******************************************************************************
* Copyright (C) 2023 Advanced Micro Devices, Inc. All Rights Reserved.
* SPDX-License-Identifier: MIT
******************************************************************************/

#ifndef __PLATFORM_H_
#define __PLATFORM_H_

#include "xil_io.h"

#ifndef SDT
#include "platform_config.h"
#endif

#define ETH_LINK_DETECT_INTERVAL 20

void init_platform();
void cleanup_platform();
#ifdef SDT
void init_timer();
void TimerCounterHandler(void *CallBackRef, u32 TmrCtrNumber);
#endif

#ifdef __PPC__
void timer_callback();
#endif
void platform_setup_timer();
void platform_enable_interrupts();
#endif

