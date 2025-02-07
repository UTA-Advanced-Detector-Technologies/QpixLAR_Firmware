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
        case I2C_PACKET:{          
            // test send
            // u8 SendBuffer[] = {cmd, 0x1};
            // IicSend(SendBuffer, sizeof(SendBuffer), IIC_SLAVE_ADDR);
            
            // recv INA260, addrs 0x40 (3.3V) and 0x45 (1V)
            u8 RecvBuffer[] = {0,0};
            u8 cmdBuf[] = {0x01}; // address pointer set
            IicRecv(RecvBuffer, sizeof(RecvBuffer), 0x40,
                    cmdBuf, sizeof(cmdBuf));
            int i=0;
            for(; i<(int)sizeof(RecvBuffer); ++i)
            {
                TxBuf[i] = (u32)RecvBuffer[i];
            }
            TransferSize = i*4;

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
            // for the first two quadlets, riffa_chnl_output.v expects the header word
            TxBuf[0] = TransferSize/4;
            TxBuf[1] = 0;
            for (u32 Index = 0; Index < TransferSize/4; Index ++) {
                TxBuf[Index+2] = RxBuf[Index];
            }
            /* handle input for commands */
            TransferSize = TransferSize + 8; // include header packet
            break;
        }
    }
    return TransferSize;
}