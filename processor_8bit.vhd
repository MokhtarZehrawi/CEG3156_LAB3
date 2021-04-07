--------------------------------------------------------------------------------
-- Title         : 8-bit Single Cycle Processor
-- Project       : Pipeline Single Cycle MIPS Processor
-------------------------------------------------------------------------------
-- File          : processor_8bit.vhd
-- Author        : Jainil Gandhi  <jgand039@uottawa.ca>
-- Created       : 2021/03/14
-- Last modified : 2021/03/14
-------------------------------------------------------------------------------
-- Description : This file is top level file which processes one instruction
--		 from the .mif file every clock cycle.
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY processor_8bit IS
	PORT (
		nextCycle, GClk, GRst : IN STD_LOGIC;
		Instruct1, Instruct2, Instruct3, Instruct4, Instruct5 : OUT STD_LOGIC_VECTOR (31 downto 0);
		PC, aluResult, Data1, Data2, WriteData : OUT STD_LOGIC_VECTOR (7 downto 0);
		ALUOp : OUT STD_LOGIC_VECTOR (1 downto 0);
		Branch, Zero, MemWrite, RegWrite, Jump, RegDst, MemtoReg, ALUSrc : OUT STD_LOGIC
	);
END;

ARCHITECTURE struct OF processor_8bit IS

SIGNAL int_instruct, instruct1_IN, instruct1_OUT, instruct2_IN, int_Instruct2, int_Instruct3, int_Instruct4, int_Instruct5 : STD_LOGIC_VECTOR (31 downto 0);
SIGNAL incrAddr_IN, incrAddr_OUT, int_targetAddr, Data1_IN, Data2_IN, controlSig_IN,
		 Data1_OUT, Data2_OUT, int_Func, Result_IN, Result_OUT, regData, dataRAM_IN, dataRAM_OUT,
		 writeRAM_IN, writeRAM_OUT, int_aluResult, int_dataRAM : STD_LOGIC_VECTOR (7 downto 0);
SIGNAL ALU_Ex : STD_LOGIC_VECTOR (3 downto 0);
SIGNAL writeAddr_OUT, Rs_Ex, highRt_Ex, lowRt_Ex, Rd_Ex, Rd_Mem, Rd_WB : STD_LOGIC_VECTOR (2 downto 0);
SIGNAL WB_Ex, WB_Mem, WB_WB, Mem_Ex, Mem_Mem, int_forwardA, int_forwardB : STD_LOGIC_VECTOR (1 downto 0);
SIGNAL int_pcSrc, int_pcEn, int_ctrlMUX, writeReg_OUT, int_ifFlush, int_Equal, int_ifEn, int_forwardC, int_MemtoReg,
		 int_Branch, int_Jump : STD_LOGIC;

COMPONENT instrFetch IS
	PORT (
		targetAddr : IN STD_LOGIC_VECTOR (7 downto 0);
		Rst, pcClk, instrClk, pcEn, pcSrc : IN STD_LOGIC;
		Addr , incrAddr : OUT STD_LOGIC_VECTOR (7 downto 0);
		instruct : OUT STD_LOGIC_VECTOR (31 downto 0)
	);
END COMPONENT;

COMPONENT Register_40bit IS
	PORT (
		Input : IN STD_LOGIC_VECTOR (39 downto 0);
		Clk, Rst, En : IN STD_LOGIC;
		Output : OUT STD_LOGIC_VECTOR (39 downto 0)
	);
END COMPONENT;

COMPONENT instrID IS
	PORT (
			instruct : IN STD_LOGIC_VECTOR (31 downto 0);
			incrAddr, writeData : IN STD_LOGIC_VECTOR (7 downto 0);
			writeAddr : IN STD_LOGIC_VECTOR (2 downto 0);
			writeReg, ctrlMUX, Clk, Rst : IN STD_LOGIC;
			Data1, Data2, targetAddr, controlSig : OUT STD_LOGIC_VECTOR (7 downto 0);
			instructOut : OUT STD_LOGIC_VECTOR (31 downto 0);
			pcSrc, ifFlush, Equal, Branch, Jump : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT hazard_detection_unit IS
	PORT (
		in_ID_EX_MemRead	  : IN STD_LOGIC;
		in_MEM_WB_RegWrite	  : IN STD_LOGIC;

                in_ID_EX_rt		  		 : IN STD_LOGIC_VECTOR (2 downto 0);
		in_IF_ID_rs, in_IF_ID_rt    : IN STD_LOGIC_VECTOR (2 downto 0);
		in_MEM_WB_WriteRegister		 	 : IN STD_LOGIC_VECTOR (2 downto 0);


		in_IF_ID_op		  : IN STD_LOGIC_VECTOR (5 downto 0);
		in_Data1_eq_Data2	  : IN STD_LOGIC;
		
		o_controlMux, o_IF_ID_write, o_PC_write    : OUT STD_LOGIC );
END COMPONENT;

COMPONENT Register_48bit IS
	PORT (
		Input : IN STD_LOGIC_VECTOR (47 downto 0);
		Clk, Rst, En : IN STD_LOGIC;
		Output : OUT STD_LOGIC_VECTOR (47 downto 0)
	);
END COMPONENT;

COMPONENT instrALU IS
	PORT (
		Data1, Data2, prevResult, loadData, Addr : IN STD_LOGIC_VECTOR (7 downto 0);
		Func : IN STD_LOGIC_VECTOR (5 downto 0);
		Rt, Rd : IN STD_LOGIC_VECTOR (2 downto 0);
		ALUOp, forwardA, forwardB : IN STD_LOGIC_VECTOR (1 downto 0);
		RegDst, ALUSrc, forwardC : IN STD_LOGIC;
		Result, dataRAM : OUT STD_LOGIC_VECTOR (7 downto 0);
		RegAddr : OUT STD_LOGIC_VECTOR (2 downto 0);
		Zero, Ovr : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT forward_unit IS
	PORT (
		in_EX_MEM_rd		  : IN STD_LOGIC_VECTOR (2 downto 0);
                in_ID_EX_rs, in_ID_EX_rt  : IN STD_LOGIC_VECTOR (2 downto 0);
		in_MEM_WB_rd              : IN STD_LOGIC_VECTOR (2 downto 0);
		
		in_EX_MEM_RegWrite        : IN STD_LOGIC;
		in_MEM_WB_RegWrite        : IN STD_LOGIC;

		in_ID_EX_MemWrite         : IN STD_LOGIC;

		o_forwardA, o_forwardB    : OUT STD_LOGIC_VECTOR (1 downto 0);
		o_forwardC		  : OUT STD_LOGIC );
END COMPONENT;

COMPONENT Register_23bit IS
	PORT (
		Input : IN STD_LOGIC_VECTOR (22 downto 0);
		Clk, Rst, En : IN STD_LOGIC;
		Output : OUT STD_LOGIC_VECTOR (22 downto 0)
	);
END COMPONENT;

COMPONENT instrRAM IS
	PORT (
		aluResult, dataIN : IN STD_LOGIC_VECTOR (7 downto 0);
		Clk, Rst, MemWrite : IN STD_LOGIC;
		dataOUT : OUT STD_LOGIC_VECTOR (7 downto 0)
	);
END COMPONENT;

COMPONENT Register_21bit IS
	PORT (
		Input : IN STD_LOGIC_VECTOR (20 downto 0);
		Clk, Rst, En : IN STD_LOGIC;
		Output : OUT STD_LOGIC_VECTOR (20 downto 0)
	);
END COMPONENT;

COMPONENT MUX_2x1_8bit IS
	PORT (
		input0, input1  : IN STD_LOGIC_VECTOR (7 downto 0);
		SEL 		: IN STD_LOGIC;
		output 		: OUT STD_LOGIC_VECTOR (7 downto 0)
	);
END COMPONENT;

COMPONENT Register_32bit IS
	PORT (
		in_Input			 : IN STD_LOGIC_VECTOR (31 downto 0);
		in_clk, in_en, in_resetbar	 : IN STD_LOGIC; 
		o_Output			 : OUT STD_LOGIC_VECTOR (31 downto 0) );
END COMPONENT;

BEGIN

	FTCH: instrFetch
	PORT MAP (targetAddr => int_targetAddr,
				 Rst => GRst,
				 pcClk => nextCycle,
				 instrClk => GClk,
				 pcEn => int_pcEn,
				 pcSrc => int_pcSrc,
				 Addr => PC,
				 incrAddr => incrAddr_IN,
				 instruct => int_instruct
	);
	
	IF_ID: Register_40bit
	PORT MAP (Input(39 downto 32) => incrAddr_IN,
				 Input(31 downto 0) => instruct1_IN,
				 Clk => nextCycle,
				 Rst => GRst,
				 En => '1',
				 Output(39 downto 32) => incrAddr_OUT,
				 Output(31 downto 0) => instruct1_OUT
	);
	
	DECODE: instrID
	PORT MAP (instruct => instruct1_OUT,
				 incrAddr => incrAddr_OUT,
				 writeData => regData,
				 writeAddr => writeAddr_OUT,
				 writeReg => WB_WB(1),
				 ctrlMUX => int_ctrlMUX,
				 Clk => GClk,
				 Rst => GRst,
				 Data1 => Data1_IN,
				 Data2 => Data2_IN,
				 targetAddr => int_targetAddr,
				 controlSig => controlSig_IN,
				 instructOUT => instruct2_IN,
				 pcSrc => int_pcSrc,
				 ifFlush => int_ifFlush,
				 Equal => int_Equal,
				 Branch => int_Branch,
				 Jump => int_Jump
	);
	
	HAZARD: hazard_detection_unit
	PORT MAP (in_ID_EX_MemRead => Mem_Ex(1),
				 in_MEM_WB_RegWrite => WB_WB(1),
				 in_ID_EX_rt => lowRt_Ex,
				 in_IF_ID_rs => instruct1_OUT(23 downto 21),
				 in_IF_ID_rt => instruct1_OUT(18 downto 16),
				 in_MEM_WB_WriteRegister => writeAddr_OUT,
				 in_IF_ID_op => instruct1_OUT(31 downto 26),
				 in_data1_eq_Data2 => int_Equal,
				 o_controlMux => int_ctrlMUX,
				 o_IF_ID_write => int_ifEn,
				 o_PC_write => int_pcEn
	);
	
	ID_EX: Register_48bit
	PORT MAP (Input(47 downto 40) => controlSig_IN,
				 Input(39 downto 32) => Data1_IN,
				 Input(31 downto 24) => Data2_IN,
				 Input(23 downto 0) => instruct2_IN(23 downto 0),
				 Clk => nextCycle,
				 Rst => GRst,
				 En => '1',
				 Output(47 downto 46) => WB_EX,
				 Output(45 downto 44) => Mem_EX,
				 Output(43 downto 40) => ALU_EX,
				 Output(39 downto 32) => Data1_OUT,
				 Output(31 downto 24) => Data2_OUT,
				 Output(23 downto 21) => Rs_Ex,
				 Output(20 downto 19) => OPEN,
				 Output(18 downto 16) => highRt_Ex,
				 Output(15 downto 14) => OPEN,
				 Output(13 downto 11) => lowRt_Ex,
				 Output(10 downto 8) => OPEN,
				 Output(7 downto 0) => int_Func
		);
		
	ALU: instrALU
	PORT MAP (Data1 => Data1_OUT,
				 Data2 => Data2_OUT,
				 prevResult => Result_OUT,
				 loadData => regData,
				 Addr => int_Func,
				 Func => int_Func(5 downto 0),
				 Rt => highRt_Ex,
				 Rd => lowRt_Ex,
				 ALUOp => ALU_Ex(2 downto 1),
				 forwardA => int_forwardA,
				 forwardB => int_forwardB,
				 RegDst => ALU_Ex(0),
				 ALUSrc => ALU_Ex(3),
				 forwardC => int_forwardC,
				 Result => Result_IN,
				 dataRAM => writeRAM_IN,
				 RegAddr => Rd_Ex,
				 Zero => Zero,
				 Ovr => OPEN
	);
	
	FORWARD: forward_unit
	PORT MAP (in_EX_MEM_rd => Rd_Mem,
				 in_ID_EX_rs => Rs_Ex,
				 in_ID_EX_rt => highRt_Ex,
				 in_MEM_WB_rd => Rd_WB,
				 in_EX_MEM_RegWrite => WB_Mem(1),
				 in_MEM_WB_RegWrite => WB_WB(1),
				 in_ID_EX_MemWrite => Mem_Ex(0),
				 o_forwardA => int_forwardA,
				 o_forwardB => int_forwardB,
				 o_forwardC => int_forwardC
	);
	
	EX_MEM: Register_23bit
	PORT MAP (Input(22 downto 21) => WB_Ex,
				 Input(20 downto 19) => Mem_Ex,
				 Input(18 downto 11) => Result_IN,
				 Input(10 downto 3) => writeRAM_IN,
				 Input(2 downto 0) => Rd_Ex,
				 Clk => nextCycle,
				 Rst => GRst,
				 En => '1',
				 Output(22 downto 21) => WB_Mem,
				 Output(20 downto 19) => Mem_Mem,
				 Output(18 downto 11) => Result_OUT,
				 Output(10 downto 3) => writeRAM_OUT,
				 Output(2 downto 0) => Rd_Mem
	);
	
	RAM: instrRAM
	PORT MAP (aluResult => Result_OUT,
				 dataIN => writeRAM_OUT,
				 Clk => GClk,
				 Rst => GRst,
				 MemWrite => Mem_Mem(0),
				 dataOut => dataRAM_IN
	);
	
	Mem_WB: Register_21bit
	PORT MAP (Input(20 downto 19) => WB_Mem,
				 Input(18 downto 11) => Result_OUT,
				 Input(10 downto 3) => writeRAM_OUT,
				 Input(2 downto 0) => Rd_Mem,
				 Clk => nextCycle,
				 Rst => GRst,
				 En => '1',
				 Output(20) => WB_WB(1),
				 Output(19) => int_MemtoReg,
				 Output(18 downto 11) => int_aluResult,
				 Output(10 downto 3) => int_dataRAM,
				 Output(2 downto 0) => writeAddr_OUT
	);
	
	Mem_Reg: MUX_2x1_8bit
	PORT MAP (input0 => int_aluResult,
				 input1 => int_dataRAM,
				 SEL => int_MemtoReg,
				 Output => regData
	);
	
	INST1: Register_32bit
	PORT MAP (in_Input => instruct1_IN,
				 in_clk => nextCycle,
				 in_en => '1',
				 in_resetbar => GRst,
				 o_Output => int_Instruct2
	);
	
	INST2: Register_32bit
	PORT MAP (in_Input => int_Instruct2,
				 in_clk => nextCycle,
				 in_en => '1',
				 in_resetbar => GRst,
				 o_Output => int_Instruct3
	);
	
	INST3: Register_32bit
	PORT MAP (in_Input => int_Instruct3,
				 in_clk => nextCycle,
				 in_en => '1',
				 in_resetbar => GRst,
				 o_Output => int_Instruct4
	);
	
	INST4: Register_32bit
	PORT MAP (in_Input => int_Instruct4,
				 in_clk => nextCycle,
				 in_en => '1',
				 in_resetbar => GRst,
				 o_Output => int_Instruct5
	);
	
	-- Intermediate Equations --
	instruct1_IN(31) <= int_ifEn AND (NOT int_ifFlush) AND int_instruct(31);
	instruct1_IN(30) <= int_ifEn AND (NOT int_ifFlush) AND int_instruct(30);
	instruct1_IN(29) <= int_ifEn AND (NOT int_ifFlush) AND int_instruct(29);
	instruct1_IN(28) <= int_ifEn AND (NOT int_ifFlush) AND int_instruct(28);
	instruct1_IN(27) <= int_ifEn AND (NOT int_ifFlush) AND int_instruct(27);
	instruct1_IN(26) <= int_ifEn AND (NOT int_ifFlush) AND int_instruct(26);
	instruct1_IN(25) <= int_ifEn AND (NOT int_ifFlush) AND int_instruct(25);
	instruct1_IN(24) <= int_ifEn AND (NOT int_ifFlush) AND int_instruct(24);
	instruct1_IN(23) <= int_ifEn AND (NOT int_ifFlush) AND int_instruct(23);
	instruct1_IN(22) <= int_ifEn AND (NOT int_ifFlush) AND int_instruct(22);
	instruct1_IN(21) <= int_ifEn AND (NOT int_ifFlush) AND int_instruct(21);
	instruct1_IN(20) <= int_ifEn AND (NOT int_ifFlush) AND int_instruct(20);
	instruct1_IN(19) <= int_ifEn AND (NOT int_ifFlush) AND int_instruct(19);
	instruct1_IN(18) <= int_ifEn AND (NOT int_ifFlush) AND int_instruct(18);
	instruct1_IN(17) <= int_ifEn AND (NOT int_ifFlush) AND int_instruct(17);
	instruct1_IN(16) <= int_ifEn AND (NOT int_ifFlush) AND int_instruct(16);
	instruct1_IN(15) <= int_ifEn AND (NOT int_ifFlush) AND int_instruct(15);
	instruct1_IN(14) <= int_ifEn AND (NOT int_ifFlush) AND int_instruct(14);
	instruct1_IN(13) <= int_ifEn AND (NOT int_ifFlush) AND int_instruct(13);
	instruct1_IN(12) <= int_ifEn AND (NOT int_ifFlush) AND int_instruct(12);
	instruct1_IN(11) <= int_ifEn AND (NOT int_ifFlush) AND int_instruct(11);
	instruct1_IN(10) <= int_ifEn AND (NOT int_ifFlush) AND int_instruct(10);
	instruct1_IN(9) <= int_ifEn AND (NOT int_ifFlush) AND int_instruct(9);
	instruct1_IN(8) <= int_ifEn AND (NOT int_ifFlush) AND int_instruct(8);
	instruct1_IN(7) <= int_ifEn AND (NOT int_ifFlush) AND int_instruct(7);
	instruct1_IN(6) <= int_ifEn AND (NOT int_ifFlush) AND int_instruct(6);
	instruct1_IN(5) <= int_ifEn AND (NOT int_ifFlush) AND int_instruct(5);
	instruct1_IN(4) <= int_ifEn AND (NOT int_ifFlush) AND int_instruct(4);
	instruct1_IN(3) <= int_ifEn AND (NOT int_ifFlush) AND int_instruct(3);
	instruct1_IN(2) <= int_ifEn AND (NOT int_ifFlush) AND int_instruct(2);
	instruct1_IN(1) <= int_ifEn AND (NOT int_ifFlush) AND int_instruct(1);
	instruct1_IN(0) <= int_ifEn AND (NOT int_ifFlush) AND int_instruct(0);
	
	-- Output Equations --
	Instruct1 <= instruct1_IN;
	Instruct2 <= int_Instruct2;
	Instruct3 <= int_Instruct3;
	Instruct4 <= int_Instruct4;
	Instruct5 <= int_Instruct5;
	aluResult <= Result_IN;
	Data1 <= Data1_IN;
	Data2 <= Data2_IN;
	WriteData <= regData;
	ALUOp <= ALU_Ex(2 downto 1);
	MemWrite <= Mem_Mem(0);
	RegWrite <= WB_WB(1);
	RegDst <= ALU_Ex(0);
	ALUSrc <= ALU_Ex(3);
	MemtoReg <= WB_WB(0);
	Branch <= int_Branch;
	Jump <= int_Jump;
	
	
	
END struct;	   

