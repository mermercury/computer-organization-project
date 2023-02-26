`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:45:33 12/10/2021 
// Design Name: 
// Module Name:    GRF 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module D_GRF(
	input clk,
	input reset,
	input W_RegWrite,
	input [4:0] D_GRF_A1,
	input [4:0] D_GRF_A2,
	input [4:0] W_GRF_A3,
	input [31:0] W_GRF_WD,
	input [31:0] W_PC,
	output [31:0] D_GRF_RD1,
	output [31:0] D_GRF_RD2
    );
	reg [31:0] REG[31:0];
	
	integer i;	
	initial begin
		for (i = 0; i < 32; i = i + 1)
			REG[i] = 32'd0;
	end
	
	
	//read
	assign D_GRF_RD1 = (D_GRF_A1 == 5'd0) ? 32'd0 :
							 (D_GRF_A1 == W_GRF_A3) ? W_GRF_WD : REG[D_GRF_A1];
		
	assign D_GRF_RD2 = (D_GRF_A2 == 5'd0) ? 32'd0 :
							 (D_GRF_A2 == W_GRF_A3) ? W_GRF_WD : REG[D_GRF_A2];
	
	//write
	always @(posedge clk) begin
		if (reset)
			for (i = 0; i < 32; i = i + 1)
				REG[i] <= 32'd0;
		else if (W_RegWrite && (W_GRF_A3 != 0)) begin
			REG[W_GRF_A3] <= W_GRF_WD;
			$display("%d@%h: $%d <= %h", $time, W_PC, W_GRF_A3, W_GRF_WD);
//		$display("@%h: $%d <= %h",  W_PC, W_GRF_A3, W_GRF_WD);
		end
	end
	
endmodule

