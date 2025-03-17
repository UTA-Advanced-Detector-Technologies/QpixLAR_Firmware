#include "helper.h"

u32 HandleCmdRequest(u32* RxBuf, u32** TxLoc, u32 TransferSize)
{
    u32* TxBuf = *TxLoc;
    u32 RxCmd = RxBuf[0];

    // handle incoming CMD Requests
    switch (RxCmd)
    {
        /*
         * MISC Cases for control
        */
        case QPIX_PACKET:{          
            // send in qpix commands
            xil_printf("recv qpix packet\r\n");
            TxBuf[0] = QPIX_PACKET;
            TxBuf[1] = 0xc0decafe;
            TransferSize = 8;
            break;
        }case SPI_PACKET:{          
            // update local SPI registers
            xil_printf("recv spi packet\r\n");
            TxBuf[0] = SPI_PACKET;
            TxBuf[1] = 0xc0decafe;
            TransferSize = 8;
            break;
        }case I2C_PACKET:{          
            // test send
            // u8 SendBuffer[] = {cmd, 0x1};
            // IicSend(SendBuffer, sizeof(SendBuffer), IIC_SLAVE_ADDR);
            xil_printf("recv i2c packet\r\n");
            TxBuf[0] = I2C_PACKET;
            TxBuf[1] = 0xc0decafe;
            TransferSize = 8;

            // recv INA260, addrs 0x40 (3.3V) and 0x45 (1V)
            // u8 RecvBuffer[] = {0,0};
            // u8 cmdBuf[] = {0x01}; // address pointer set
            // IicRecv(RecvBuffer, sizeof(RecvBuffer), 0x40,
            //         cmdBuf, sizeof(cmdBuf));
            // int i=0;
            // for(; i<(int)sizeof(RecvBuffer); ++i)
            // {
            //     TxBuf[i] = (u32)RecvBuffer[i];
            // }
            // TransferSize = i*4;

            // recv DS28CM00
            // u8 RecvBuffer[] = {0,0,0,0,0,0,0,0,0};
            // u8 cmdBuf[] = {0}; // set addr cmd to zero
            // IicRecv(RecvBuffer, sizeof(RecvBuffer), IIC_SLAVE_ADDR,
            //         cmdBuf, sizeof(cmdBuf));
            // int i=0;
            // for(; i<(int)sizeof(RecvBuffer); ++i)
            // {
            //     TxBuf[i] = (u32)RecvBuffer[i];
            // }
            // TransferSize = i*4;
            break;
        }default:{
            // echo, move data from Rx to Tx, then send
            for (u32 Index = 0; Index < TransferSize/4; Index ++) {
                TxBuf[Index] = RxBuf[Index];
            }
            TransferSize = TransferSize; // simple echo
            break;
        }
    }
    return TransferSize;
}