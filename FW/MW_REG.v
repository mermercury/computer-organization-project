`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:01:49 12/12/2021 
// Design Name: 
// Module Name:    MW_REG 
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
module MW_REG(
    input clk,
    input reset,
    input [31:0] M_instr,
    input [31:0] M_PC,
    input [31:0] M_ALU_res,
    input [31:0] M_DM_out,
	 input [31:0] M_EXT_imm32,
	 input M_check,
	 
    output [31:0] W_instr,
    output [31:0] W_PC,
    output [31:0] W_ALU_res,
    output [31:0] W_DM_out,
	 output W_check,
	 output [31:0] W_EXT_imm32
    );

	 reg [31:0] nW_instr;
    reg [31:0] nW_PC;
    reg [31:0] nW_ALU_res;
	 reg [31:0] nW_DM_out;
	 reg [31:0] nW_EXT_imm32;
	 reg tmp;

	initial begin
		nW_instr = 32'd0;
      nW_PC = 32'd0;
      nW_ALU_res = 32'd0;
		nW_DM_out = 32'd0;
		nW_EXT_imm32 = 32'd0;
		tmp = 0;
	end

	always@(posedge clk) begin
		if(reset) begin
			nW_instr <= 32'd0;
			nW_PC <= 32'd0;
			nW_ALU_res <= 32'd0;
			nW_DM_out <= 32'd0;
			nW_EXT_imm32 <= 32'd0;
			tmp <= 0;
		end
		else begin
			nW_instr <= M_instr;
			nW_PC <= M_PC;
			nW_ALU_res <= M_ALU_res;
			nW_DM_out <= M_DM_out;
			nW_EXT_imm32 <= M_EXT_imm32;
			tmp <= M_check;
		end
	end
	
	assign W_instr = nW_instr;
   assign W_PC = nW_PC;
   assign W_ALU_res = nW_ALU_res;
   assign W_DM_out = nW_DM_out;
	assign W_EXT_imm32 = nW_EXT_imm32;
	assign W_check = tmp;
	
	
	
	
	
endmodule
