`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:14:52 12/15/2021 
// Design Name: 
// Module Name:    STOP 
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
module STOP(
    input D_branch,
    input D_cal_r,
	 input D_cal_i,
	 input D_j_to_reg,
	 input D_load,
	 input D_store,
	 input E_cal_r,
	 input E_cal_i,
	 input E_load,
	 input E_j_to_reg,
	 input M_load,
	 input [4:0] D_rs_addr,
	 input [4:0] D_rt_addr,
	 input [4:0] E_RegDst,
	 input [4:0] M_RegDst,
	 output STALL
    );
	 wire [2:0] Tuse_rs;
	 wire [2:0] Tuse_rt;
	 
	 assign  Tuse_rs = (D_branch | D_j_to_reg) ? 3'd0 :
							 (D_cal_r | D_cal_i | D_load | D_store) ? 3'd1 : 3'd6;
	 assign  Tuse_rt = (D_branch) ? 3'd0 :
							 (D_cal_r) ? 3'd1 :
							 (D_store) ? 3'd2 : 3'd6;
	
	 wire [2:0] Tnew_E = (E_load) ? 3'd2 :
								(E_cal_r | E_cal_i) ? 3'd1 : 3'd0;
	 wire [2:0] Tnew_M =	(M_load) ? 3'd1 : 3'd0;
	 
	 wire stall_rs_1 = ((Tuse_rs < Tnew_E) & (D_rs_addr == E_RegDst) & (E_RegDst != 5'd0));
	 wire stall_rs_2 = ((Tuse_rs < Tnew_M) & (D_rs_addr == M_RegDst) & (M_RegDst != 5'd0));
	 wire stall_rt_1 = ((Tuse_rt < Tnew_E) & (D_rt_addr == E_RegDst) & (E_RegDst != 5'd0));
	 wire stall_rt_2 = ((Tuse_rt < Tnew_M) & (D_rt_addr == M_RegDst) & (M_RegDst != 5'd0));
	 assign STALL = (stall_rs_1 | stall_rs_2 | stall_rt_1 | stall_rt_2);
	
								
	 

endmodule

//条件写： 只有到了M级才知道要写还是不写还是写啥
//wire stall_rs_e = (Tuse_rs < Tnew_E) && D_rs_addr && (E_lwso ? D_rs_addr == 5'd31 : D_rs_addr == E_RegDst);


//wire stall_rs_e = (Tuse_rs < Tnew_E) && D_rs_addr && (E_lrm ? D_rs_addr  : D_rs_addr == E_RegDst);
//CU:
//assign RegDst = lwso ? (check === 1'd1 ? 5'd31 : 5'd0) : 5'd0;










