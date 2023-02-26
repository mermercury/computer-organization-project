`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:09:56 12/12/2021 
// Design Name: 
// Module Name:    FD_REG 
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
module FD_REG(
    input clk,
    input reset,
    input [31:0] F_instr,
    input [31:0] F_PC,
	 input EN,
    output [31:0] D_instr,
    output [31:0] D_PC
    );
	 
	 reg [31:0] Instr_D;
	 reg [31:0] PC4_D;
	 assign D_instr = Instr_D;
	 assign D_PC = PC4_D;
	 
	 initial begin
		Instr_D = 0;
		PC4_D = 0;
	end
	
	always @(posedge clk) begin
		if (reset) begin
			Instr_D <= 0;
			PC4_D <= 0;
		end
		else if(EN) begin
			Instr_D <= F_instr;
			PC4_D <= F_PC;
		end
		else begin
			Instr_D <= Instr_D;
			PC4_D <= PC4_D;
		end
	end


endmodule

//不跳转时清空延迟槽
//wire FD_REG_clr = check_D & ~D_CMP_sig & ~stall;