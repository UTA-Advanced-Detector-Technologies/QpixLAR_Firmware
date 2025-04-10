/*
 * Copyright (C) 2017 - 2019 Xilinx, Inc.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
 * SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
 * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
 * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
 * OF SUCH DAMAGE.
 *
 */

#ifndef __UDP_SERVER
#define __UDP_SERVER

#include "lwipopts.h"
#include "xlwipconfig.h"
#include "lwip/ip_addr.h"
#include "lwip/err.h"
#include "lwip/udp.h"
#include "lwip/inet.h"
#include "xil_printf.h"
#include "platform.h"
#include <sleep.h>

extern struct udp_pcb *pcb;
extern u8 send_udp;

extern int tcp_connection;

/* seconds between periodic bandwidth reports */
#define INTERIM_REPORT_INTERVAL 5

/* Client port to connect */
#define UDP_CONN_PORT 8

/* time in seconds to transmit packets */
#define UDP_TIME_INTERVAL 30

/* Server to connect with */
#define UDP_SERVER_IP_ADDRESS "192.169.1.17"

/* UDP buffer length in bytes */
#define UDP_SEND_BUFSIZE 1024

/* MAX UDP send retries */
#define MAX_SEND_RETRY 10

/* Number of parallel UDP clients */
#define NUM_OF_PARALLEL_CLIENTS 1

/* external udp functions */
void udp_packet_send(u32* txData, u16 size_t);
void udp_transfer_data(void);
void udp_start_application();

#endif /* __UDP_PERF_CLIENT_H_ */
