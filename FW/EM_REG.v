`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:44:29 12/12/2021 
// Design Name: 
// Module Name:    EM_REG 
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
module EM_REG(
    input clk,
    input reset,
    input [31:0] E_instr,
    input [31:0] E_PC,
    input [31:0] E_GRF_RD2,	//rt
    input [31:0] E_ALU_res,
	 input [31:0] E_EXT_imm32,
	 input E_check,
	 
    output [31:0] M_instr,
    output [31:0] M_PC,
    output [31:0] M_GRF_RD2,
    output [31:0] M_ALU_res,
	 output M_check,
	 output [31:0] M_EXT_imm32
    );

	 reg [31:0] nM_instr;
    reg [31:0] nM_PC;
    reg [31:0] nM_GRF_RD2;
    reg [31:0] nM_ALU_res;
	 reg [31:0] nM_EXT_imm32;
	 
	 reg tmp;

	initial begin
		nM_instr = 32'd0;
      nM_PC = 32'd0;
      nM_GRF_RD2 = 32'd0;
      nM_ALU_res = 32'd0;
		nM_EXT_imm32 = 32'd0;
		tmp = 0;
	end
	
	 always@(posedge clk) begin
		if(reset) begin
			nM_instr <= 32'd0;
			nM_PC <= 32'd0;
			nM_GRF_RD2 <= 32'd0;
			nM_ALU_res <= 32'd0;
			nM_EXT_imm32 <= 32'd0;
			tmp <= 0;
		end
		else begin
			nM_instr <= E_instr;
			nM_PC <= E_PC;
			nM_GRF_RD2 <= E_GRF_RD2;
			nM_ALU_res <= E_ALU_res;
			nM_EXT_imm32 <= E_EXT_imm32;
			tmp <= E_check;
		end
	 end
	
	 assign M_instr = nM_instr;
	 assign M_PC = nM_PC;
    assign M_GRF_RD2 = nM_GRF_RD2;
    assign M_ALU_res = nM_ALU_res;
    assign M_EXT_imm32 = nM_EXT_imm32;
	 assign M_check = tmp;

endmodule
