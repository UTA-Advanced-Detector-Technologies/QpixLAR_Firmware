module axis_fifo_simple
#(
  DEPTH = 2,
  DATA_WIDTH = 32,
  KEEP_ENABLE = 0
)
(
    input clk,
    input rst,

    input  wire [31:0] s_axis_tdata,
    input  wire        s_axis_tlast,
    input  wire        s_axis_tvalid,
    output wire        s_axis_tready,

    output wire [31:0] m_axis_tdata,
    output wire        m_axis_tlast,
    output wire        m_axis_tvalid,
    input  wire        m_axis_tready
);

// ensure that we buffer the input from the zynq in case we're sending an info packet
axis_fifo #(
  .DEPTH(DEPTH),
  .DATA_WIDTH(DATA_WIDTH),
  .KEEP_ENABLE(KEEP_ENABLE)
)U_TxFIFO
(
.clk(clk),
.rst(rst),

.s_axis_tdata  (s_axis_tdata), // inbound data from zynq
.s_axis_tlast  (s_axis_tlast),
.s_axis_tvalid (s_axis_tvalid),
.s_axis_tready (s_axis_tready),
.s_axis_tkeep  (0),
.s_axis_tid    (0),
.s_axis_tdest  (0),
.s_axis_tuser  (0),

.m_axis_tdata  (m_axis_tdata), // read by local fsm
.m_axis_tlast  (m_axis_tlast),
.m_axis_tvalid (m_axis_tvalid),
.m_axis_tready (m_axis_tready),
.m_axis_tkeep  (),
.m_axis_tid    (),
.m_axis_tdest  (),
.m_axis_tuser  (),

.pause_req(0),
.pause_ack(),
.status_depth(),
.status_depth_commit(),
.status_overflow(),
.status_bad_frame(),
.status_good_frame()
);

 endmodule
