#include "udp_server.h"
#include <lwip/pbuf.h>

struct udp_pcb *pcb;
u8 send_udp = 0;

void udp_packet_send(u32* txData, u16 size_t)
{
	u8_t retries = MAX_SEND_RETRY;
	struct pbuf *packet;
	err_t err;

	packet = pbuf_alloc(PBUF_TRANSPORT, size_t, PBUF_RAM);

	if (!packet) {
		xil_printf("error allocating pbuf to send\r\n");
		return;
	} else {
		memcpy(packet->payload, txData, size_t);
	}

	while (retries) {
		err = udp_send(pcb, packet);
		if (err != ERR_OK) {
			xil_printf("Error on udp_send: %d\r\n", err);
			retries--;
			usleep(100);
		} else {
			break;
		}
	}
	pbuf_free(packet);
	// packet_id++;
}

// udp receive function.. called when data appears on UDP socket, default behavior is echo back
void udp_echo_recv(void *arg, struct udp_pcb *pcb, struct pbuf *p, const ip_addr_t *addr, u16_t port)
{
    // xil_printf("udp receved some things \r\n");
    if (p != NULL) {
        /* send received packet back to sender */
        udp_sendto(pcb, p, addr, port);

        // configure responses to this location
        pcb->remote_ip = *addr;
        pcb->remote_port = port;

        /* free the pbuf */
        pbuf_free(p);
    }
}

// called from normal start_application, create a PCB to use to manage UDP transfers
void udp_start_application()
{
	err_t err;
	unsigned port = UDP_CONN_PORT;

    /* Create UDP PCB */
    pcb = udp_new();
    if (!pcb) {
        xil_printf("Error in PCB creation. out of memory\r\n");
        return;
    }

    err = udp_bind(pcb, IP_ADDR_ANY, port);
    if (err != ERR_OK) {
        xil_printf("udp_client: Error on udp_bind: %d\r\n", err);
        udp_remove(pcb);
        return;
    }
    /* Receive data */
    udp_recv(pcb, udp_echo_recv, NULL);

	xil_printf("UDP echo server started @ port %d\n\r", port);
}
