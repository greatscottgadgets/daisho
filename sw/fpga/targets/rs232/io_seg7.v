
//
// seven segment decoder
// 
// 2010 marshallh
//

module io_seg7(
	disp_in, 
	disp_out
);

input 		[3:0] 	disp_in;
output 	reg	[6:0] 	disp_out;

always  @(disp_in) begin
	case (disp_in)
       0:	disp_out <= ~7'b0111111;
       1:	disp_out <= ~7'b0000110;
       2:	disp_out <= ~7'b1011011;
       3:	disp_out <= ~7'b1001111;
       4:	disp_out <= ~7'b1100110;
       5:	disp_out <= ~7'b1101101;
       6:	disp_out <= ~7'b1111101;
       7:	disp_out <= ~7'b0000111;
       8:	disp_out <= ~7'b1111111;
       9:	disp_out <= ~7'b1101111;
      10:	disp_out <= ~7'b1110111;
      11:	disp_out <= ~7'b1111100;
      12:	disp_out <= ~7'b0111001;
      13:	disp_out <= ~7'b1011110;
      14:	disp_out <= ~7'b1111001;
      15:	disp_out <= ~7'b1110001;
	endcase
end
endmodule
