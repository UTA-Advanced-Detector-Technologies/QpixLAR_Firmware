#ifndef _ethControl
#define _ethControl

#include "lwip/tcp.h"
#include "xil_cache.h"
#include "xil_io.h"
#include <stdio.h>
#include "xparameters.h"
#include "netif/xadapter.h"

#if LWIP_DHCP==1
#include "lwip/dhcp.h"
#endif

#define TCP_PORT 7

extern volatile int TcpFastTmrFlag;
extern volatile int TcpSlowTmrFlag;
extern struct netif *echo_netif;

extern u32* TxEthBufferPtr;
extern u32* RxEthBufferPtr;
// #define TX_ETH_BUFFER_BASE 0x0F000000

void print_ip(char *msg, ip_addr_t *ip);
void print_ip_settings(ip_addr_t *ip, ip_addr_t *mask, ip_addr_t *gw);
int start_application();
void print_app_header();
void assign_default_ip(ip_addr_t *ip, ip_addr_t *mask, ip_addr_t *gw);

/* defined by each RAW mode application */

int SetupEthernet(unsigned char* a);
int transfer_data();
void tcp_fasttmr(void);
void tcp_slowtmr(void);
#endif