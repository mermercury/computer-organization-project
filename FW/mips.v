`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:08:59 12/13/2021 
// Design Name: 
// Module Name:    mips 
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
module mips(
    input clk,
    input reset
    );
//----------------Declarations--------------------//	 
//wire check = ([InsName, created by CU] & D_cmp_sig) check 为1代表为新条件跳转指令且满足条件要Jump-link

//F:
wire [31:0] F_PC,F_instr;
wire PC_en;
wire STALL;
assign PC_en = (~STALL); 
//D:
wire D_cmp_sig;
wire [1:0] D_EXTop;
wire [2:0] NextPCType;
wire [2:0] D_CMPop;			
wire [4:0] D_rs_addr,D_rt_addr,D_shamt;
wire [15:0] D_imm16;
wire [25:0] D_imm26;
wire [31:0] D_instr,D_PC,D_rs,D_rt,D_EXT_imm32,D_NPC;
wire [31:0] D_FW_rs,D_FW_rt;
//E:
wire [2:0] ALUSrc_B,E_MemtoReg;
wire [3:0] ALUControl;
wire [4:0] E_shamt,E_rt_addr,E_rs_addr,E_RegDst;
wire [31:0] E_RegWD;
wire [31:0] E_rs,E_rt,E_FW_rs,E_FW_rt;
wire [31:0] E_instr,E_PC,E_EXT_imm32,E_ALU_B,E_ALU_res;
//M:
wire M_MemWrite;
wire [2:0] M_MemtoReg;
wire [4:0] M_rt_addr,M_RegDst,M_shamt;
wire [31:0] M_instr,M_PC,M_rt,M_ALU_res,M_DM_out;
wire [31:0] M_RegWD;
wire [31:0] M_FW_rt,M_EXT_imm32;
//W:
wire [2:0] W_MemtoReg;
wire [4:0] W_RegDst; 
wire [31:0] W_RegWD,W_PC,W_instr,W_ALU_res,W_DM_out,W_EXT_imm32;	
wire W_RegWrite;
wire D_branch,D_cal_r,D_cal_i,D_j_to_reg,D_load,D_store,E_cal_r,E_cal_i,E_load,E_j_to_reg,M_load;


wire D_check = ((D_instr[31:26] == 6'b000001) & (D_instr[20:16] == 5'b10000) & (D_FW_rs[31] == 1'b1));

wire E_check,M_check,W_check;
//------------------stage_F-----------------------//	
PC PC (
    .clk(clk), 
    .reset(reset), 
    .PC_en(PC_en), 
    .D_NPC(D_NPC), 
    .F_PC(F_PC)
    );

F_IM im (
    .F_PC(F_PC), 
    .F_IM_instr(F_instr)
    );
wire EN = (~STALL);	 
FD_REG FD_REG (
    .clk(clk), 
    .reset(reset), 
    .F_instr(F_instr), 
    .F_PC(F_PC), 
    .D_instr(D_instr), 
    .D_PC(D_PC),
	 .EN(EN)
    );
	 
//------------------stage_D-----------------------//
CU D_CU (
    .instr(D_instr), 
	 .check(D_check),
    .imm26(D_imm26), 
    .imm16(D_imm16), 
    .rt_addr(D_rt_addr), 
    .rs_addr(D_rs_addr), 
    .shamt(D_shamt), 
    .cal_r(D_cal_r), 
    .cal_i(D_cal_i), 
    .load(D_load), 
    .store(D_store), 
    .branch(D_branch), 
    .j_to_reg(D_j_to_reg),  
    .NextPCType(NextPCType), 
    .Ext(D_EXTop), 
    .D_CMPop(D_CMPop)
    );
	 
D_GRF grf (
    .clk(clk), 
    .reset(reset), 
    .W_RegWrite(W_RegWrite), 
    .D_GRF_A1(D_rs_addr), 
    .D_GRF_A2(D_rt_addr), 
    .W_GRF_A3(W_RegDst), 
    .W_GRF_WD(W_RegWD), 
    .W_PC(W_PC), 
    .D_GRF_RD1(D_rs), 
    .D_GRF_RD2(D_rt)
    );
	 
assign D_FW_rs = (D_rs_addr == 5'd0) ? 32'd0 :
					  ((D_rs_addr != 5'd0) && (D_rs_addr == E_RegDst)) ? E_RegWD :
					  ((D_rs_addr != 5'd0) && (D_rs_addr == M_RegDst)) ? M_RegWD :
					  (D_rs_addr  != 5'd0) ? D_rs : 32'd0;
					  
assign D_FW_rt = (D_rt_addr == 5'd0) ? 32'd0 :
					  ((D_rt_addr != 5'd0) && (D_rt_addr == E_RegDst)) ? E_RegWD :
					  ((D_rt_addr != 5'd0) && (D_rt_addr == M_RegDst)) ? M_RegWD :
					  (D_rt_addr  != 5'd0) ? D_rt : 32'd0;

DE_REG DE_REG (
    .clk(clk), 
    .reset(reset | STALL), 
    .D_instr(D_instr), 
    .D_PC(D_PC), 
    .D_GRF_RD1(D_FW_rs), 
    .D_GRF_RD2(D_FW_rt), 
    .D_EXT_imm32(D_EXT_imm32), 
	 .D_check(D_check),
    .E_instr(E_instr), 
    .E_PC(E_PC), 
    .E_GRF_RD1(E_rs), 
    .E_GRF_RD2(E_rt), 
	 .E_check(E_check),
    .E_EXT_imm32(E_EXT_imm32)
    );

	 
	D_EXT ext (
    .D_EXT_imm16(D_imm16), 
    .D_EXTop(D_EXTop), 
    .D_EXT_imm32(D_EXT_imm32)
    );
	 
	 D_CMP D_CMP (
    .D_CMP_A(D_FW_rs), 
    .D_CMP_B(D_FW_rt), 
    .D_CMPop(D_CMPop), 
    .D_cmp_sig(D_cmp_sig)
    );
	 
	 D_NPC npc (
    .D_PC(D_PC), 
    .F_PC(F_PC), 
    .D_imm26(D_imm26), 
    .reg_rs(D_FW_rs), 
    .NextPCType(NextPCType), 
    .D_NPC(D_NPC),
	 .D_cmp_sig(D_cmp_sig)
    );

	 
	  STOP STOP (
    .D_branch(D_branch), 
    .D_cal_r(D_cal_r), 
    .D_cal_i(D_cal_i), 
    .D_j_to_reg(D_j_to_reg), 
    .D_load(D_load), 
    .D_store(D_store), 
    .E_cal_r(E_cal_r), 
    .E_cal_i(E_cal_i), 
    .E_load(E_load), 
    .E_j_to_reg(E_j_to_reg), 
    .M_load(M_load), 
    .D_rs_addr(D_rs_addr), 
    .D_rt_addr(D_rt_addr), 
    .E_RegDst(E_RegDst), 
    .M_RegDst(M_RegDst), 
    .STALL(STALL)
    );
	 

//------------------stage_E-----------------------//


assign E_FW_rs = (E_rs_addr == 5'd0) ? 32'd0 :
					  (E_rs_addr == M_RegDst) ? M_RegWD :
					  (E_rs_addr == W_RegDst) ? W_RegWD : E_rs;
					
assign E_FW_rt = (E_rt_addr == 5'd0) ? 32'd0 :
					  (E_rt_addr == M_RegDst) ? M_RegWD :
					  (E_rt_addr == W_RegDst) ? W_RegWD : E_rt;
					                                                                                                                                 
wire [31:0] E_PC8 = E_PC + 32'd8; //相当于从E级开始就将jump-and-link指令写入的PC+8流水了！需要的时候转发
wire [31:0] nothing = 32'd0;
MUX4to1 MUX_E_RegWD (
	 .in_0(nothing),
    .in_1(E_PC8), 
    .in_2(E_EXT_imm32), 
    .in_3(nothing), 
    .sig(E_MemtoReg), 
    .out(E_RegWD)
    );

CU E_CU (
    .instr(E_instr),  
	 .check(E_check),
    .rt_addr(E_rt_addr), 
    .rs_addr(E_rs_addr),
	 .shamt(E_shamt), 
    .cal_r(E_cal_r), 
    .cal_i(E_cal_i), 
    .load(E_load),  
    .j_to_reg(E_j_to_reg),  
    .ALUSrc_B(ALUSrc_B),  
    .ALUControl(ALUControl),  
    .RegDst(E_RegDst),
	 .MemtoReg(E_MemtoReg)
    );


	 E_ALU alu (
    .a(E_FW_rs), 
    .b(E_ALU_B), 
    .alu_opcode(ALUControl), 
    .result(E_ALU_res)
    );

wire [31:0] E_shamt_ext = {27'd0,E_shamt};

	 MUX4to1 alusrc_b (
    .in_0(E_shamt_ext), 
    .in_1(E_FW_rt), 
    .in_2(E_EXT_imm32), 
    .in_3(E_FW_rt), 
    .sig(ALUSrc_B), 
    .out(E_ALU_B)
    );
	 
	 EM_REG EM_REG (
    .clk(clk), 
    .reset(reset), 
    .E_instr(E_instr), 
    .E_PC(E_PC), 
    .E_GRF_RD2(E_FW_rt), 
    .E_ALU_res(E_ALU_res), 
    .E_EXT_imm32(E_EXT_imm32), 
	 .E_check(E_check),
    .M_instr(M_instr), 
    .M_PC(M_PC), 
    .M_GRF_RD2(M_rt), 
    .M_ALU_res(M_ALU_res), 
	 .M_check(M_check),
    .M_EXT_imm32(M_EXT_imm32)
    );


//------------------stage_M-----------------------//
	 
assign M_FW_rt = (M_rt_addr == 5'd0) ? 32'd0 :
					  (M_rt_addr == W_RegDst) ? W_RegWD : M_rt;
					  
wire [1:0] store_sel,load_sel;
CU M_CU (
    .instr(M_instr),  
	 .check(M_check),	 
    .rt_addr(M_rt_addr), 
    .shamt(M_shamt),  
    .MemWrite(M_MemWrite),  
    .MemtoReg(M_MemtoReg),  
    .RegDst(M_RegDst),
	 .load(M_load),
	 .load_sel(load_sel),
	 .store_sel(store_sel)
    );
	 
	 wire [31:0] M_PC8 = M_PC + 32'd8;
	 MUX4to1 MUX_M_RegWD (
	 .in_0(nothing), 		//lw
    .in_1(M_PC8), 
    .in_2(M_EXT_imm32), 
    .in_3(M_ALU_res), 
    .sig(M_MemtoReg), 
    .out(M_RegWD)
    );
	 
	 M_DM dm (
    .clk(clk), 
    .reset(reset), 
    .M_MemWrite(M_MemWrite), 
    .M_DM_A(M_ALU_res), 
    .M_DM_WD(M_FW_rt), 
    .M_PC(M_PC), 
    .M_DM_out(M_DM_out),
	 .load_sel(load_sel),
	 .store_sel(store_sel)
    );
	 
	 MW_REG MW_REG (
    .clk(clk), 
    .reset(reset), 
    .M_instr(M_instr), 
    .M_PC(M_PC), 
    .M_ALU_res(M_ALU_res), //之所以要流水是因为E级得到的结果不一定需要在E级转发，可能在M级或W级需要转发！
    .M_DM_out(M_DM_out), 
    .M_EXT_imm32(M_EXT_imm32),
	 .M_check(M_check),
    .W_instr(W_instr), 
    .W_PC(W_PC), 
    .W_ALU_res(W_ALU_res), 
    .W_DM_out(W_DM_out), 
	 .W_check(W_check),
    .W_EXT_imm32(W_EXT_imm32)
    );
	 
//------------------stage_W-----------------------//

	 CU W_CU (
    .instr(W_instr), 
	 .check(W_check),
    .MemtoReg(W_MemtoReg), 
    .RegWrite(W_RegWrite), 
    .RegDst(W_RegDst)
    );
	 
	 wire [31:0] W_PC8 = W_PC + 32'd8;
	 
	 MUX4to1 MUXW_RegWD (
	 .in_0(W_DM_out), 
    .in_1(W_PC8), 
    .in_2(W_EXT_imm32), 
    .in_3(W_ALU_res), 
    .sig(W_MemtoReg), 
    .out(W_RegWD)
    );
	 



endmodule
