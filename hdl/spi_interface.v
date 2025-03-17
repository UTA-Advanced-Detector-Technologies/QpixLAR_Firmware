//-----------------------------------------------------------------------------
// Title         : spi_interface
// Project       : qpixlarfirmware
//-----------------------------------------------------------------------------
// File          : spi_interface.v
// Author        : Kevin Keefe  <kevin.keefe2@uta.edu>
// Created       : 05.03.2025
// Last modified : 05.03.2025
//-----------------------------------------------------------------------------
// Description :
// basic example to drag and drop and begin simulating with verilator.
// below is an example SPI module which receives a new register
// transact regi lite and will send the appropriate SPI data.
// the below example is used to program the MCP4911 chip
//-----------------------------------------------------------------------------
// Copyright (c) 2025 by <Kevin Keefe> This model is the confidential and
// proprietary property of <Kevin Keefe> and the possession or use of this
// file requires a written license from <Kevin Keefe>.
//------------------------------------------------------------------------------
// Modification history :
// 05.03.2025 : created
//-----------------------------------------------------------------------------
module spi_interface
(
    input clk,
    input rst,

    // input register
    input                  new_reg,
    input [spi_length-1:0] spi_data,

    // output
    output reg done,

    // SPI Pins
    output reg bLDAC, // load DAC_bar
    output reg bCS,   // CS_bar
    output reg SCK,   // S_clock
    output reg SDI    // Serial data 'in', out from FPGA to the chip
);


// configurable params
parameter spi_length = 16;
parameter clock_div  = 16; // how many relative clock cycles should clk be divided down to acheive sck

// local params
localparam S_IDLE      = 3'b00,
           S_PREP      = 3'b01,
           S_SEND      = 3'b10,
           S_LDAC      = 3'b11,
           S_PREP_LDAC = 3'b101,
           S_DONE      = 3'b100;

// local regs
reg [2:0]  next_state;
reg [2:0]  state;
integer    cur_bit; // current bit in the spi array
integer    cur_cnt; // clock count

// fsm-1
// sequential portion
always @(posedge clk or posedge rst) begin
    if (rst) begin
       state <= S_IDLE;
       cur_cnt <= 0;
       cur_bit <= 0;
    end else begin
        state <= next_state;

        // state counting
        if(state == S_IDLE || state != next_state)
           cur_cnt <= 0;
        else
          cur_cnt <= cur_cnt + 1;

        // sending next bit
        if(next_state == S_PREP && state == S_SEND)
          cur_bit <= cur_bit + 1;
        if(cur_bit >= spi_length)
          cur_bit <= 0;
    end
end

// fsm-2
// Next state logic process
always @(*) begin
   if (rst)
     next_state = S_IDLE;
   else begin
      case (state)

        S_IDLE:
          begin
             if (new_reg)
               next_state = S_PREP;
             else
               next_state = S_IDLE;
          end

        // sck is low, sdi is prepared
        S_PREP:
          begin
             if (cur_bit >= spi_length)
               next_state = S_LDAC;
             else if (cur_cnt >= clock_div-1)
               next_state = S_SEND;
             else
               next_state = S_PREP;
          end

        // sck is high, sdi is sent
        S_SEND:
          begin
             if (cur_cnt >= clock_div-1)
               next_state = S_PREP;
             else
               next_state = S_SEND;
          end

        // ensure setup time for LDAC line
        S_LDAC:
          begin
             if (cur_cnt >= clock_div-1)
               next_state = S_DONE;
             else
               next_state = S_LDAC;
          end

        S_DONE:
          begin
             if (cur_cnt >= clock_div-1)
               next_state = S_IDLE;
             else
               next_state = S_DONE;
          end

        default: next_state = S_IDLE;
      endcase
   end
end

// fsm-3
// State Outputs
always @(*) begin
    case (state)
        S_IDLE:
        begin
          bLDAC = 1'b1;
          bCS   = 1'b1;
          SCK   = 1'b0;
          SDI   = 1'b0;
          done  = 1'b0;
        end

        S_PREP:
        begin
          bLDAC = 1'b1;
          bCS   = 1'b0;
          SCK   = 1'b0;
          SDI   = spi_data[spi_length - cur_bit - 1]; // MSB first
          done  = 1'b0;
        end

        S_SEND:
        begin
          bLDAC = 1'b1;
          bCS   = 1'b0;
          SCK   = 1'b1;
          SDI   = spi_data[spi_length - cur_bit - 1]; // MSB first
          done  = 1'b0;
        end

        S_PREP_LDAC:
        begin
          bLDAC = 1'b1;
          bCS   = 1'b1;
          SCK   = 1'b0;
          SDI   = 1'b0;
          done  = 1'b0;
        end

        S_LDAC:
        begin
          bLDAC = 1'b0;
          bCS   = 1'b1;
          SCK   = 1'b0;
          SDI   = 1'b0;
          done  = 1'b0;
        end

        S_DONE:
        begin
          bLDAC = 1'b1;
          bCS   = 1'b1;
          SCK   = 1'b0;
          SDI   = 1'b0;
          done  = 1'b1;
        end

        // S_IDLE equivalent
        default:
        begin
          bLDAC = 1'b0;
          bCS   = 1'b1;
          SCK   = 1'b0;
          SDI   = 1'b0;
          done  = 1'b0;
        end
    endcase
end

endmodule // spi_interface
