`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:27:00 12/12/2021 
// Design Name: 
// Module Name:    DE_REG 
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
module DE_REG(
    input clk,
    input reset,
    input [31:0] D_instr,
    input [31:0] D_PC,
    input [31:0] D_GRF_RD1,		//rs
    input [31:0] D_GRF_RD2,		//rt
    input [31:0] D_EXT_imm32,
	 input D_check,///////////////////////////////////
    output [31:0] E_instr,
    output [31:0] E_PC,
    output [31:0] E_GRF_RD1,
    output [31:0] E_GRF_RD2,
	 output E_check,///////////////////////////////////
    output [31:0] E_EXT_imm32
    );

	 reg [31:0] nE_instr;
    reg [31:0] nE_PC;
    reg [31:0] nE_GRF_RD1;
    reg [31:0] nE_GRF_RD2;
    reg [31:0] nE_EXT_imm32;
	 reg tmp;

	initial begin
		nE_instr = 32'd0;
      nE_PC = 32'd0;
      nE_GRF_RD1 = 32'd0;
      nE_GRF_RD2 = 32'd0;
      nE_EXT_imm32 = 32'd0;
		tmp = 0;
	end
	
	 always@(posedge clk) begin
		if(reset) begin
			nE_instr <= 32'd0;
			nE_PC <= 32'd0;
			nE_GRF_RD1 <= 32'd0;
			nE_GRF_RD2 <= 32'd0;
			nE_EXT_imm32 <= 32'd0;
			tmp <= 0;
		end
		else begin
			nE_instr <= D_instr;
			nE_PC <= D_PC;
			nE_GRF_RD1 <= D_GRF_RD1;
			nE_GRF_RD2 <= D_GRF_RD2;
			nE_EXT_imm32 <= D_EXT_imm32;
			tmp <= D_check;
		end
	 end
	 
	 assign E_instr = nE_instr;
	 assign E_PC = nE_PC;
    assign E_GRF_RD1 = nE_GRF_RD1;
    assign E_GRF_RD2 = nE_GRF_RD2;
    assign E_EXT_imm32 = nE_EXT_imm32;
	 assign E_check = tmp;
	 
endmodule
