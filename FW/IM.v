`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:10:07 12/13/2021 
// Design Name: 
// Module Name:    IM 
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
module F_IM(
    input [31:0] F_PC,
    output [31:0] F_IM_instr
    );
	 
	 integer i;
	
	 reg [31:0] instr_memory[4095:0];
	
	 initial begin 
		for (i = 0; i < 4096; i = i + 1)
		begin 	instr_memory[i] = 0; end
		$readmemh("code.txt", instr_memory);
	 end
	
	 assign F_IM_instr = instr_memory[(F_PC[13:2]-12'hc00)];

endmodule