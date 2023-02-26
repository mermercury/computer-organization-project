`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:38:34 12/12/2021 
// Design Name: 
// Module Name:    CMP 
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
`define b_beq 3'd0
`define b_bltzal 3'd1
//`define no_branch 3'd7



module D_CMP(
    input [31:0] D_CMP_A,		//rs
    input [31:0] D_CMP_B,		//rt
    input [2:0] D_CMPop,		//branch type
    output D_cmp_sig				//branch or not
    );	
	 
	 wire equal = (D_CMP_A == D_CMP_B);
	 wire less_0 = (D_CMP_A[31] == 1'b1);
	 
	 assign D_cmp_sig = (equal && (D_CMPop == `b_beq)) || (less_0 && (D_CMPop == `b_bltzal));


endmodule
