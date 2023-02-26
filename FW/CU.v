`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:44:26 12/13/2021 
// Design Name: 
// Module Name:    CU 
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
//只依靠op字段判断
`define R_TYPE 6'b000000
`define ADDU  6'b100001
`define SUBU  6'b100011
`define ORI   6'b001101
`define LUI   6'b001111
`define LW    6'b100011
`define SW    6'b101011
`define BEQ   6'b000100
`define JAL   6'b000011
`define JR    6'b001000
`define SB    6'b101000
`define SH    6'b101001
`define LH    6'b100001
`define LB    6'b100000
`define B_HONG 6'b000001
`define J     6'b000010
`define BLTZAL 5'b10000

/*
`define ADDI  6'b001000
`define JALR  6'b001001
*/

// op[31:26] rs [25:21] rt [20:16] rd[15:11] shamt[10:6] func[5:0]


module CU(
		input [31:0] instr,
		
		input check,
		//----------------split the instr
		output [25:0] imm26,
		output [15:0] imm16,
		output [4:0] rd_addr,
		output [4:0] rt_addr,
		output [4:0] rs_addr,
		output [4:0] shamt,
		//----------------different instr type
		output cal_r,
		output cal_i,
		output load,
		output store,
		output branch,
		output j_to_reg,
		output j_to_addr,
		output j_and_link,
		output Lui,
		//----------------control signal
		output ALUSrc_A,			//logical shift:1(GPR[rt])  0:GPR[rs]
		output [2:0] ALUSrc_B,	//logical shift:0(shamt); cal_r:1(GPR[rt]); cal_i/lui/store/load:2(EXT); 否则，3：(GPR[rt])
		output MemWrite,			
		output [3:0] ALUControl,
		output [2:0] MemtoReg,			//写入GRF数据的选择：load:0(DM_OUT)  j-link:1(PC+8)  lui:2(EXT_OUT)  其他（alu运算结果）:3(ALU_res)
		output RegWrite,			//RegDst不为0的时候就为1
		output [4:0] RegDst,		//写入GRF地址来源 cal_r: rd_addr; cal_i/lui/load: rt_addr; j-link:31; 否则为0
		output [2:0] NextPCType,//决定下一个PC值的类型：branch:0 j/j-link:1 jr:2 否则：3
		output [1:0] Ext,
		output [2:0] D_CMPop,	//beq:0 其他：7
		output [1:0] load_sel,
		output [1:0] store_sel
		
    );
wire [5:0] opcode;
wire [5:0] func;
wire addu,subu,ori,lui,sw,lw,beq,jal,jr,sb,sh,lh,lb,j,bltzal;

assign opcode = instr[31:26];
assign func = instr[5:0];
//------------------------------split decode
assign rs_addr = instr[25:21];
assign rt_addr = instr[20:16];
assign rd_addr = instr[15:11];
assign shamt = instr[10:6];
assign imm16 = instr[15:0];
assign imm26 = instr[25:0];
//------------------------------
assign addu = (opcode == `R_TYPE) & (func == `ADDU);
assign subu = (opcode == `R_TYPE) & (func == `SUBU);
assign jr = (opcode == `R_TYPE) & (func == `JR);
assign ori  = (opcode == `ORI);
assign lui  = (opcode == `LUI);
assign sw   = (opcode == `SW);
assign lw   = (opcode == `LW);
assign beq   = (opcode == `BEQ);
assign jal   = (opcode == `JAL);
assign sb	= (opcode == `SB);
assign sh	= (opcode == `SH);
assign lh	= (opcode == `LH);
assign lb	= (opcode == `LB);
assign j    = (opcode == `J);

assign bltzal = (opcode == `B_HONG) & (rt_addr == `BLTZAL);
//------------------------------分类指令
assign store = (sw | sb | sh);
assign load = (lw | lb | lh);
assign branch = (beq | check | bltzal);
assign cal_r = (addu | subu );
assign cal_i = (ori);
assign j_to_reg = jr;
assign j_to_addr = j;
assign j_and_link = jal;
assign Lui = lui; //lui 的运算结果在D级就已经产生，保存至D/E寄存器了，Tnew=0

//------------------------------control signal
assign ALUSrc_A = 1'b0;

assign ALUSrc_B = (cal_r) ? 3'd1 :
						(cal_i | lui | store | load) ? 3'd2 : //choose ext-imm
						3'd3; // choose GPR[rt]


assign RegDst = (cal_r) ? rd_addr :
					 (j_and_link | check) ? 5'd31 :
					 (cal_i | lui | load) ? rt_addr : 5'd0;	//不然就设成0！
					 
assign RegWrite = (RegDst == 5'd0) ? 1'd0 : 1'd1;

assign MemtoReg = (load) ? 3'd0 :		//DM-out
						(j_and_link | check) ? 3'd1 : //PC+8
						(lui) ? 3'd2 : 3'd3;  //EXT   //ALU
						
assign MemWrite = store;

assign ALUControl = (addu | lui | sw | lw) ? 4'd0 :
						  (subu | beq)				 ? 4'd1 :
						  ori							 ? 4'd2 :  4'd0;

assign Ext[0] = sw | lw | beq | sb | sh | lh | lb;
assign Ext[1] = lui;


assign NextPCType = (branch | check) ? 3'd0 :
						  (j | jal) ? 3'd1 :
						  (jr) ? 3'd2 : 3'd3;

assign D_CMPop = (beq) ? 3'd0 :
					  (check) ? 3'd1 : 3'd7;


assign load_sel[0] = lb;
assign load_sel[1] = lh;
assign store_sel[0] = sb;
assign store_sel[1] = sh;


endmodule
