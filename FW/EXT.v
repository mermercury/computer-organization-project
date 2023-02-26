`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:54:36 12/10/2021 
// Design Name: 
// Module Name:    EXT 
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
module D_EXT(
    input [15:0] D_EXT_imm16,
    input [1:0] D_EXTop,
    output [31:0] D_EXT_imm32
    );
	 assign D_EXT_imm32 = (D_EXTop == 2'b00) ? {{16{1'b0}},D_EXT_imm16} :                //ÎÞ·ûºÅÀ©Õ¹
							    (D_EXTop == 2'b01) ? {{16{D_EXT_imm16[15]}},D_EXT_imm16} :				  //·ûºÅÀ©Õ¹
							    (D_EXTop == 2'b10) ? {D_EXT_imm16,{16{1'b0}}} : {{16{1'b0}},D_EXT_imm16}; //lui

endmodule
