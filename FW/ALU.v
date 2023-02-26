`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:51:10 12/13/2021 
// Design Name: 
// Module Name:    ALU 
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
`define ADD 4'd0
`define SUB 4'd1
`define OR  4'd2
`define AND 4'b0011
`define SLL 4'b0100
`define SRL 4'b0101
`define GTU 4'b0110
`define LTU 4'b0111
`define LTZ 4'b1000  //小于0 

module E_ALU(
    input [31:0] a,
    input [31:0] b,
    input [3:0] alu_opcode,
    output [31:0] result
    );

    reg [31:0] res;

    assign result = res;
    
    always@(*)begin
	 
        case(alu_opcode)
		  `ADD:	res = a + b;
		  `SUB:	res = a - b;
		  `OR :	res = a | b;
		  `AND:	res = a & b;
		  `SLL:	res = a << (b[4:0]);
		  `SRL:	res = a >> (b[4:0]);
		  `GTU:	res = (a > b) ? 32'd1 : 32'd0;
		  `LTU:	res = (a < b) ? 32'd1 : 32'd0;
		  `LTZ: res = (a[31] == 1'b1) ? 32'd0 : 32'd1;
		  default: res = 32'd0;
        endcase
		  
    end


endmodule

//以循环左移为例
//if(B[4:0] == 5'd0) out = A;
//else out = A << B[4:0] | A >> (5'd31 - B[4:0] + 5'd1);