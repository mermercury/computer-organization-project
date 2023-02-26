`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:12:08 12/10/2021 
// Design Name: 
// Module Name:    DM 
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
module M_DM(
	input clk,
	input reset,
	input M_MemWrite,
	input [31:0] M_DM_A,
	input [31:0] M_DM_WD,
	input [31:0] M_PC,
	output [31:0] M_DM_out,
	input [1:0] store_sel,
	input [1:0] load_sel
    );
	 
	reg [31:0] RD;
	reg [31:0] WINTO;
	integer i;	
	reg [31:0] data_memory[4095:0];
	initial begin
		for (i = 0; i < 4096; i = i + 1) begin
			data_memory[i] = 0;
			end
		RD = 32'd0;
		WINTO = 32'd0;
	end
	
	
	//load
	 always @(*) begin
	 
		case(load_sel) 
			2'b00: RD = data_memory[M_DM_A[13:2]];
			2'b01: begin
						case(M_DM_A[1:0])
							2'b00: RD = {{24{data_memory[M_DM_A[13:2]][7]}},data_memory[M_DM_A[13:2]][7:0]};
							2'b01: RD = {{24{data_memory[M_DM_A[13:2]][15]}},data_memory[M_DM_A[13:2]][15:8]};
							2'b10: RD = {{24{data_memory[M_DM_A[13:2]][23]}},data_memory[M_DM_A[13:2]][23:16]};
							default: RD = {{24{data_memory[M_DM_A[13:2]][31]}},data_memory[M_DM_A[13:2]][31:24]};
						endcase
					 end
			2'b10: begin
						RD = (M_DM_A[1] == 1'b0) ? {{16{data_memory[M_DM_A[13:2]][15]}},data_memory[M_DM_A[13:2]][15:0]} : {{16{data_memory[M_DM_A[13:2]][31]}},data_memory[M_DM_A[13:2]][31:16]};
					 end
			default:	RD = 32'd0;
		endcase
		
	 end
	
	assign M_DM_out = RD;
	
	
	
	//store
	always@(*) begin
		case(store_sel)
			2'b00: WINTO = M_DM_WD;
			2'b01: begin
						case(M_DM_A[1:0])
							2'b00: WINTO = {data_memory[M_DM_A[13:2]][31:8],M_DM_WD[7:0]};
							2'b01: WINTO = {data_memory[M_DM_A[13:2]][31:16],M_DM_WD[7:0],data_memory[M_DM_A[13:2]][7:0]};
							2'b10: WINTO = {data_memory[M_DM_A[13:2]][31:24],M_DM_WD[7:0],data_memory[M_DM_A[13:2]][15:0]};
							default: WINTO = {M_DM_WD[7:0],data_memory[M_DM_A[13:2]][23:0]};
						endcase
					 end
			2'b10: begin
						WINTO = (M_DM_A[1] == 1'b0) ? ({data_memory[M_DM_A[13:2]][31:16],M_DM_WD[15:0]}) : ({M_DM_WD[15:0],data_memory[M_DM_A[13:2]][15:0]});
					 end
			default: WINTO = M_DM_WD; //留给新加的指令
		endcase
	end
	
	
	
		
	always @(posedge clk) begin
		if (reset)
			for (i = 0; i < 4096; i = i + 1)
				data_memory[i] <= 32'd0;
		else if (M_MemWrite) begin
			data_memory[M_DM_A[13:2]] <= WINTO;
			$display("%d@%h: *%h <= %h", $time, M_PC, M_DM_A, WINTO);
//			$display("@%h: *%h <= %h", M_PC, M_DM_A, WINTO);
		end
	end
	
endmodule
