`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:03:49 12/10/2021 
// Design Name: 
// Module Name:    NPC 
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
//`define BEQ   6'b000100
//`define JAL   6'b000011
//`define J     6'b000010
/*
module D_NPC(
	input [31:0] D_PC,
//	input [31:0] F_PC,
	input [31:0] D_instr,
//	input [15:0] D_imm16,
//	input [25:0] D_imm26,
//	input [31:0] D_reg_data,
//	input [4:0] D_NPCop,
	output D_NPC
    );
wire beq,j,jal;
wire [5:0] opcode;


assign opcode = D_instr[31:26];
assign beq   = (opcode == `BEQ);	 
assign jal   = (opcode == `JAL);
assign j     = (opcode == `J);

	
assign D_NPC = (beq) ? ({{14{D_instr[15]}},D_instr[15:0],{2{1'b0}}} + D_PC + 32'd4) :
					(jal | j) ? {D_PC[31:28],D_instr[15:0],{2{1'b0}}} : (D_PC + 32'd4);
					 
endmodule
*/

`define branch 3'd0
`define j		3'd1
`define jr		3'd2
`define no_branch 3'd3

module D_NPC(
	input [31:0] D_PC,
	input [31:0] F_PC,
	input [25:0] D_imm26,
	input [31:0] reg_rs,
	input [2:0] NextPCType,
	input D_cmp_sig,
	output [31:0] D_NPC
    );

assign D_NPC = (NextPCType == `no_branch) ? (F_PC + 32'd4) :
					(NextPCType == `jr) ? reg_rs :
					(NextPCType == `j) ? ({D_PC[31:28], D_imm26, 2'b00}) :					
					((NextPCType == `branch) && (D_cmp_sig == 1'b1)) ? ({{14{D_imm26[15]}},D_imm26[15:0],{2{1'b0}}} + D_PC + 32'd4) : (F_PC + 32'd4);
					 
endmodule



















