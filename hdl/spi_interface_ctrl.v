//-----------------------------------------------------------------------------
// Title         : spi_interface_ctrl
// Project       : examples
//-----------------------------------------------------------------------------
// File          : spi_interface_ctrl.v
// Author        : Kevin Keefe  <keefe@Forerunner>
// Created       : 16.03.2025
// Last modified : 16.03.2025
//-----------------------------------------------------------------------------
// Description :
// example spi controller
//-----------------------------------------------------------------------------
// Copyright (c) 2025 by Kevin Keefe This model is the confidential and
// proprietary property of Kevin Keefe and the possession or use of this
// file requires a written license from Kevin Keefe.
//------------------------------------------------------------------------------
// Modification history :
// 16.03.2025 : created
//-----------------------------------------------------------------------------


module spi_interface_ctrl
#(
// configurable params
parameter spi_slaves = 2,
parameter spi_length = 16,
parameter clock_div  = 16 // how many relative clock cycles should clk be divided down to acheive sck
)
(
    input clk,
    input rst,

    // input register
    input [spi_slaves-1:0]                 new_reg,
    input [spi_slaves-1:0][spi_length-1:0] spi_data,

    // SPI Pins
    output                      bLDAC, // load DAC_bar
    output     [spi_slaves-1:0] bCS,   // CS_bar
    output                      SCK,   // S_clock
    output                      SDI    // Serial data 'in', out from FPGA to the chip
) ;

reg  [spi_slaves-1:0] buf_reg;
wire [spi_slaves-1:0] r_bLDAC,
                      r_SCK,
                      r_SDI,
                      r_done;

reg [spi_slaves-1:0] dac_stat; // register value to hold new_reg requests and LDACs

// dac updater
integer k;
always @(posedge clk or posedge rst) begin
    if (rst)
       buf_reg <= 0;
    else begin
       dac_stat <= 0;
       for (k = 0; k < spi_slaves; k = k + 1) begin
          // hold the update until the spi instance loads the DAC
          if (new_reg[k] != 0)
            buf_reg[k] <= 1;
          // we're sending this value now
          if(k == index && found_nonzero)
            dac_stat[k] <= 1;
          // we've finished sending this node
          if(r_done[k] == 1)
            buf_reg[k] <= 0;
       end
    end
end


// indexer
integer j;
reg found_nonzero;  // Flag to track if the first non-zero element is found
reg [$clog2(spi_slaves)-1:0] index;
always @(*) begin
    // Initialize output array to all zeros
    found_nonzero = 0;
    index = 0;
    // Loop through the input array
    for (j = 0; j < spi_slaves; j = j + 1) begin
        if (!found_nonzero && buf_reg[j] != 0) begin
            found_nonzero = 1;        // Set the flag to prevent further updates
            index = j;
        end
    end
end

assign SCK = r_SCK[index];
assign SDI = r_SDI[index];
assign bLDAC = r_bLDAC[index];

genvar i;
generate
    for (i = 0; i < spi_slaves; i = i + 1) begin : SPI_INST
        example #(.clock_div(clock_div)) spi_instance (
            .clk(clk),
            .rst(rst),
            // inputs
            .new_reg(dac_stat[i]),
            .spi_data(spi_data[i]),
            // reg spi outputs
            .bLDAC(r_bLDAC[i]),
            .bCS(bCS[i]),
            .SCK(r_SCK[i]),
            .SDI(r_SDI[i]),
            .done(r_done[i]));
    end
endgenerate


endmodule // example_ctrl
