module diagnostic (
	input wire				CLK_P0,
	input wire				CLK_N0,
	input wire				CLK_P1,
	input wire				CLK_N1,
	
	input wire				SPI_SCK,
	input wire				SPI_SS,
	input wire				SPI_MOSI,
	output wire				SPI_MISO,

	input wire				USB_PIPE_PCLK,
	input wire	[15:0]	USB_PIPE_RX_DATA,
	input wire	[1:0]		USB_PIPE_RX_DATAK,
	input wire				USB_PIPE_RX_VALID,
	
	output wire				USB_PIPE_TX_CLK,
	output wire	[15:0]	USB_PIPE_TX_DATA,
	output wire	[1:0]		USB_PIPE_TX_DATAK,
	
	input	wire				USB_ULPI_CLK,
	input wire				USB_ULPI_DIR,
	output wire				USB_ULPI_STP,
	input wire				USB_ULPI_NXT,
	inout wire	[7:0]		USB_ULPI_DATA,
	
	output wire				USB_RESET_N,
	output wire				USB_OUT_ENABLE,
	output wire				USB_PHY_RESET_N,
	output wire				USB_TX_DETRX_LPBK,
	output wire				USB_TX_ELECIDLE,
	inout wire				USB_RX_ELECIDLE,
	input wire	[2:0]		USB_RX_STATUS,
	output wire	[1:0]		USB_POWER_DOWN,
	inout wire				USB_PHY_STATUS,
	input wire				USB_PWRPRESENT,
	input wire				USB_ID,
	
	output wire				USB_TX_ONESZEROS,
	output wire	[1:0]		USB_TX_DEEMPH,
	output wire	[2:0]		USB_TX_MARGIN,
	output wire				USB_TX_SWING,
	output wire				USB_RX_POLARITY,
	output wire				USB_RX_TERMINATION,
	output wire				USB_RATE,
	output wire				USB_ELAS_BUF_MODE,
	
	output wire	[1:0]		DDR2_CK_P,
	output wire	[1:0]		DDR2_CK_N,
	output wire	[1:0]		DDR2_CKE,
	output wire	[1:0]		DDR2_S_N,
	output wire				DDR2_RAS_N,
	output wire				DDR2_CAS_N,
	output wire				DDR2_WE_N,
	output wire	[2:0]		DDR2_BA,
	output wire	[1:0]		DDR2_ODT,
	output wire	[15:0]	DDR2_A,
	inout wire	[63:0]	DDR2_DQ,
	output wire	[7:0]		DDR2_DM,
	inout wire	[7:0]		DDR2_DQS,
	
	output wire				I2C_SCL,
	inout wire				I2C_SDA,
	
	inout wire	[41:0]	FE_A,
	input wire				FE_A_CLK_P,
	input wire				FE_A_CLK_N,
	
	inout wire	[51:0]	FE_B,
	input wire				FE_B_CLK_P,
	input wire				FE_B_CLK_N,
	
	inout wire	[51:0]	FE_C,
	input wire				FE_C_CLK_P,
	input wire				FE_C_CLK_N
);

reg reset = 1;

wire usb_reset_n;

wire usb_strapping;
assign usb_strapping = reset;

wire usb_xtal_dis = 0;
wire usb_ssc_dis = 1;
wire usb_pipe_16bit = 0;
wire usb_iso_start = 0;
wire usb_ulpi_8bit = 0;
wire [1:0] usb_refclksel = 2'b11;

assign SPI_MISO = 1'b1;

assign USB_PIPE_TX_CLK = 1'b0;
assign USB_PIPE_TX_DATA = 16'h0000;
assign USB_PIPE_TX_DATAK = 2'b00;

wire usb_ulpi_clk;
wire [7:0] usb_ulpi_d_in;
wire [7:0] usb_ulpi_d_out;
wire usb_ulpi_d_oe;
wire usb_ulpi_dir;
wire usb_ulpi_stp;
wire usb_ulpi_nxt;

assign usb_ulpi_clk = USB_ULPI_CLK;
assign usb_ulpi_d_in = USB_ULPI_DATA;
assign usb_ulpi_dir = USB_ULPI_DIR;
assign usb_ulpi_nxt = USB_ULPI_NXT;

assign USB_ULPI_STP = usb_ulpi_stp;
assign USB_ULPI_DATA = (usb_strapping ? { usb_iso_start, usb_ulpi_8bit, usb_refclksel, 4'bZZZZ } :
	(usb_ulpi_d_oe ? usb_ulpi_d_out : 8'bZZZZZZZZ));

assign USB_RESET_N = !reset;		// Hold device in reset.
assign USB_OUT_ENABLE = !reset;	// Outputs disabled.
assign USB_PHY_RESET_N = !reset;	// Hold PHY in reset.

assign USB_TX_DETRX_LPBK = 1'b0;	// No loopback.
assign USB_TX_ELECIDLE = 1'b0;	// Normal operation.
assign USB_RX_ELECIDLE = (usb_strapping ? usb_xtal_dis : 1'bZ);
assign USB_POWER_DOWN = 2'b00;	// Normal operation.
assign USB_PHY_STATUS = (usb_strapping ? usb_pipe_16bit : 1'bZ);

assign USB_TX_ONESZEROS = 1'bZ;	// Normal operation.
assign USB_TX_DEEMPH = 2'b10;		// No de-emphasis.
assign USB_TX_MARGIN[2] = 1'b0;
assign USB_TX_MARGIN[1] = 1'b0;
assign USB_TX_MARGIN[0] = (usb_strapping ? usb_ssc_dis : 1'b0);
assign USB_TX_SWING = 1'b0;		// Full swing.
assign USB_RX_POLARITY = 1'b0;	// No inversion.
assign USB_RX_TERMINATION = 1'b0;	// Terminations removed.
assign USB_RATE = 1'b1;				// Normal operation.
assign USB_ELAS_BUF_MODE = 1'b0;	// Nominal half-full buffer mode.

assign DDR2_CK_P = 2'b00;
assign DDR2_CK_N = 2'b11;
assign DDR2_CKE = 2'b00;
assign DDR2_S_N = 2'b11;
assign DDR2_RAS_N = 1'b1;
assign DDR2_CAS_N = 1'b1;
assign DDR2_WE_N = 1'b1;
assign DDR2_BA = 3'b000;
assign DDR2_ODT = 2'b11;
//assign DDR2_A = 16'h0000;
//assign DDR2_DQ = 64'hZZZZZZZZZZZZZZZZ;
//assign DDR2_DM = 8'b00000000;
//assign DDR2_DQS = 8'bZZZZZZZZ;

assign I2C_SCL = 1'bZ;
assign I2C_SDA = 1'bZ;

reg [31:0] pipe_tick = 0;
reg [31:0] ulpi_tick = 0;

always @(posedge USB_PIPE_PCLK) begin
	pipe_tick <= pipe_tick + 1'b1;
end

always @(posedge USB_ULPI_CLK) begin
	ulpi_tick <= ulpi_tick + 1'b1;
end

assign DDR2_DQ = { pipe_tick, pipe_tick };
assign DDR2_A = pipe_tick[15:0];
assign DDR2_DM = pipe_tick[7:0];
assign DDR2_DQS = pipe_tick[7:0];

parameter [3:0]	USB_ST_RST_0 = 0,
						USB_ST_RST_1 = 1,
						USB_ST_IDLE = 2;

reg [3:0] usb_state = USB_ST_RST_0;

wire clk_50;
assign clk_50 = CLK_P1;

always @(posedge clk_50) begin
	reset <= 0;
	usb_state <= usb_state;
	
	case(usb_state)
		USB_ST_RST_0: begin
			reset <= 1;
			usb_state <= USB_ST_RST_1;
		end
	
		USB_ST_RST_1: begin
			reset <= 1;
			usb_state <= USB_ST_IDLE;
		end
	
		USB_ST_IDLE: begin
			usb_state <= USB_ST_IDLE;
		end
	endcase
	
end

////////////////////////////////////////////////////////////
//
// USB 2.0 controller
//
////////////////////////////////////////////////////////////

	wire			usb_connected;
	wire			usb_configured;
	wire	[1:0]	dbg_linestate;
	wire	[10:0]	dbg_frame_num;
	
usb2_top	iu2 (
	.ext_clk					( clk_50 ),
	.reset_n					( ~reset ),
	.reset_n_out			( usb_reset_n ),
	
	.opt_enable_hs			( 1'b1 ),
	.stat_connected		( usb_connected ),
	.stat_configured		( usb_configured ),
	
	.phy_ulpi_clk			( usb_ulpi_clk ),
	.phy_ulpi_d_in			( usb_ulpi_d_in ),
	.phy_ulpi_d_out		( usb_ulpi_d_out ),
	.phy_ulpi_d_oe			( usb_ulpi_d_oe ),
	.phy_ulpi_dir			( usb_ulpi_dir ),
	.phy_ulpi_stp			( usb_ulpi_stp ),
	.phy_ulpi_nxt			( usb_ulpi_nxt ),
	/*
	.buf_in_addr			( buf_in_addr ),
	.buf_in_data			( buf_in_data ),
	.buf_in_wren			( buf_in_wren ),
	.buf_in_ready			( buf_in_ready ),
	.buf_in_commit			( buf_in_commit ),
	.buf_in_commit_len	( buf_in_commit_len ),
	.buf_in_commit_ack	( buf_in_commit_ack ),
	
	.buf_out_addr			( buf_out_addr ),
	.buf_out_q				( buf_out_q ),
	.buf_out_len			( buf_out_len ),
	.buf_out_hasdata		( buf_out_hasdata ),
	.buf_out_arm			( buf_out_arm ),
	.buf_out_arm_ack		( buf_out_arm_ack ),
	
	.vend_req_act			( vend_req_act ),
	.vend_req_request		( vend_req_request ),
	.vend_req_val			( vend_req_val ),
	*/
	.dbg_linestate			( dbg_linestate ),
	.dbg_frame_num			( dbg_frame_num )
);

endmodule
