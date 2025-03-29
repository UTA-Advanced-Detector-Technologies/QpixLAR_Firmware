#include "helper.h"

u32 HandleCmdRequest(u32* RxBuf, u32** TxLoc, u32 TransferSize)
{
    u32* TxBuf = *TxLoc;
    u32 RxCmd = RxBuf[0];

    // handle incoming CMD Requests
    switch (RxCmd)
    {
        case QPIX_PACKET:{          
            // send in qpix commands
            xil_printf("recv qpix packet\r\n");
            TxBuf[0] = QPIX_PACKET;
            TxBuf[1] = GOOD_PACKET;

            // select the qpix reg we want to query to
            u32 qpix_reg = RxBuf[1];

            // make sure we received 3 quadlets, writing to valid qpix reg
            if(TransferSize != 4*3 || qpix_reg > QPIX_NUM_REGS)
                TxBuf[1] = BAD_PACKET;
            else{
                Xil_Out32(TREG_QPIX_ADDR+0x04*qpix_reg, RxBuf[2]);
            }

            TransferSize = 8;
            break;
        }case SPI_PACKET:{ // two SPI modules exist on each carrier
                                         
            TxBuf[0] = SPI_PACKET;
            TxBuf[1] = GOOD_PACKET;

            // bit handling 
            u8 is_vcomp1 = (RxBuf[1] & (1<<31)) > 0;
            u16 dac_val = RxBuf[1] & 0xffff;

            // update appropriate TREG
            if(is_vcomp1)
                Xil_Out32(VCOMP1_ADDR, dac_val);
            else // update vcomp2
                Xil_Out32(VCOMP2_ADDR, dac_val);

            TransferSize = 8;
            break;
        }case I2C_PACKET:{          

            TxBuf[0] = I2C_PACKET;
            TxBuf[1] = GOOD_PACKET;

            // bit handling
            u8 addr       = (RxBuf[1] & 0xff00000) >> 20;
            u8 pointer    = (RxBuf[1] & 0x30000)   >> 16; // DACB | DACA
            u8 ctrl       = (RxBuf[1] & 0xf000)    >> 12; //  PD1 | PD0 | bCLR | bLDAC
            u16 dac_value = RxBuf[1] & 0x0fff;

            // build 3 bytes to send over i2c
            u8 dac1 = (ctrl << 4) | ((dac_value & 0x0f00) >> 8);
            u8 dac2 = dac_value & 0xff;
            u8 SendBuffer1[] = {pointer, dac1, dac2};

            // LVDS_CM
            if(TransferSize == 4*2 && addr == IIC_SLAVE_ADDR_1)
            {
                IicSend(SendBuffer1, sizeof(SendBuffer1), IIC_SLAVE_ADDR_1);
            }
            // VCM1/2
            else if(TransferSize == 4*2 && addr == IIC_SLAVE_ADDR_2)
            {
                IicSend(SendBuffer1, sizeof(SendBuffer1), IIC_SLAVE_ADDR_2);
            }else{
                TxBuf[1] = BAD_PACKET;
            }

            TransferSize = 8;
            break;
        /*
         * MISC Cases for control
        */
        }case CTRL_PACKET:{          

            // update local control, packet mask, etc
            TxBuf[0] = CTRL_PACKET;
            TxBuf[1] = GOOD_PACKET;

            u32 ctrl_cmd = RxBuf[1];

            // make sure we received 3 quadlets
            if(TransferSize != 4*3)
                TxBuf[1] = BAD_PACKET;
            else{
                // addrs defined in transactregimap.vhd
                if(ctrl_cmd == CTRL_SHDN) // SHDN
                    Xil_Out32(TREG_CTRL_ADDR+0x00, RxBuf[2]);
                else if(ctrl_cmd == CTRL_MASK) // Mask
                    Xil_Out32(TREG_CTRL_ADDR+0x04, RxBuf[2]);
                else if(ctrl_cmd == CTRL_PLEN) // PktLength
                    Xil_Out32(TREG_CTRL_ADDR+0x08, RxBuf[2]);
                else // error
                    TxBuf[1] = BAD_PACKET;
            }
            
            TransferSize = 8;
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