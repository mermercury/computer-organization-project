`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:03:41 12/13/2021 
// Design Name: 
// Module Name:    PC 
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
module PC(
    input clk,
    input reset,
    input PC_en,
    input [31:0] D_NPC,
    output [31:0] F_PC
    );

	 reg [31:0] PC;
	 assign F_PC = PC;
	 
	 initial begin 
		PC = 32'h0000_3000;
	end
	
	 always @(posedge clk) begin
		if (reset)
			PC <= 32'h0000_3000;
		else if (PC_en) begin
			PC <= D_NPC;
		end
		else PC <= PC;
	end

endmodule
