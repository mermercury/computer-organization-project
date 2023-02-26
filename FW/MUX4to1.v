`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:21:56 12/13/2021 
// Design Name: 
// Module Name:    MUX4to1 
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
module MUX4to1(
    input [31:0] in_0,
    input [31:0] in_1,
	 input [31:0] in_2,
	 input [31:0] in_3,
    input [2:0] sig,
    output [31:0] out
    );
	 assign out = (sig == 3'd0) ? in_0 :
					  (sig == 3'd1) ? in_1 : 
					  (sig == 3'd2) ? in_2 : in_3;

endmodule
