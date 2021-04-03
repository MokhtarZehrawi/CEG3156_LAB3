--------------------------------------------------------------------------------
-- Title         : Instruction Decoding and Branching
-- Project       : Pipelined Single Cycle MIPS Processor
-------------------------------------------------------------------------------
-- File          : instrID.vhd
-- Author        : Jainil Gandhi  <jgand039@uottawa.ca>
-- Created       : 2021/04/02
-- Last modified : 2021/04/02
-------------------------------------------------------------------------------
-- Description : This file is a grouping of the Control Unit, Register File,
--					  and Branching Adder. Components between IF/ID and ID/EX pipe.
--					  In this section we decode instruction and decide whether to 
--					  branch/jump in the next cycle or not.
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY instrID IS
	PORT (
			instruct : IN STD_LOGIC_VECTOR (31 downto 0);
			incrAddr, writeData : IN STD_LOGIC_VECTOR (7 downto 0);
			writeAddr : IN STD_LOGIC_VECTOR (2 downto 0);
			writeReg, ctrlMUX, Clk, Rst : IN STD_LOGIC;
			Data1, Data2, targetAddr, controlSig : OUT STD_LOGIC_VECTOR (7 downto 0);
			Rd : OUT STD_LOGIC_VECTOR (5 downto 0);
			Rs, highRt, lowRt: OUT STD_LOGIC_VECTOR (2 downto 0);
			pcSrc : OUT STD_LOGIC
	);
END;

ARCHITECTURE struct OF instrID IS

SIGNAL int_Data1, int_Data2 : STD_LOGIC_VECTOR (7 downto 0);
SIGNAL int_aluOP : STD_LOGIC_VECTOR (1 downto 0);
SIGNAL int_Equal, int_RegDst, int_Jump, int_Branch, int_MemRead, int_MemtoReg, int_MemWrite, int_ALUsrc, int_RegWrite : STD_LOGIC;

COMPONENT RegisterFile_8x8 IS
	PORT (
		in_Read1			 : IN STD_LOGIC_VECTOR (2 downto 0);
		in_Read2			 : IN STD_LOGIC_VECTOR (2 downto 0);
		in_Write_sel			 : IN STD_LOGIC_VECTOR (2 downto 0);
		in_Write_Data			 : IN STD_LOGIC_VECTOR (7 downto 0);
		in_Write_en			 : IN STD_LOGIC;
		in_clk, in_resetbar		 : IN STD_LOGIC; 
		o_Data1				 : OUT STD_LOGIC_VECTOR (7 downto 0);
		o_Data2 			 : OUT STD_LOGIC_VECTOR (7 downto 0) );
END COMPONENT;

COMPONENT Control_Logic_RISC IS
	PORT (
		i_OP					     : IN STD_LOGIC_VECTOR (5 downto 0);
		o_RegDst, o_Jump, O_Branch, o_MemRead 	     : OUT STD_LOGIC;
		o_MemtoReg, o_MemWrite, o_ALUsrc, o_RegWrite : OUT STD_LOGIC;
		o_aluOP 				     : OUT STD_LOGIC_VECTOR (1 downto 0) );
END COMPONENT;

COMPONENT aluCLA_8bit IS
	PORT (
		A, B : IN STD_LOGIC_VECTOR (7 downto 0);
		Cin : IN STD_LOGIC;
		Sum : OUT STD_LOGIC_VECTOR (7 downto 0);
		Cout, Ovr : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT isEqual_8bit IS
	PORT (
			A, B : IN STD_LOGIC_VECTOR (7 downto 0);
			Equal : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT MUX_2x1_8bit IS
	PORT (
		input0, input1  : IN STD_LOGIC_VECTOR (7 downto 0);
		SEL 		: IN STD_LOGIC;
		output 		: OUT STD_LOGIC_VECTOR (7 downto 0)
	);
END COMPONENT;

BEGIN

	RegFile: RegisterFile_8x8
	PORT MAP (in_Read1 => instruct(23 downto 21),
				 in_Read2 => instruct(18 downto 16),
				 in_Write_sel => writeAddr,
				 in_Write_Data => writeData,
				 in_Write_en => writeReg,
				 in_clk => Clk,
				 in_resetbar => Rst,
				 o_Data1 => int_Data1,
				 o_Data2 => int_Data2
	);
	
	EQ: isEqual_8bit
	PORT MAP (A => int_Data1,
				 B => int_Data2,
				 Equal => int_Equal
	);
	
	brnAdder: aluCLA_8bit
	PORT MAP (A => incrAddr,
				 B(7) => instruct(15),
				 B(6 downto 0) => instruct(6 downto 0),
				 Cin => '0',
				 Sum => targetAddr,
				 Cout => OPEN,
				 Ovr => OPEN
	);
	
	CTRL: Control_Logic_RISC
	PORT MAP (i_OP => instruct(31 downto 26),
				 o_RegDst => int_RegDst,
				 o_Jump => int_Jump,
				 o_Branch => int_Branch,
				 o_MemRead => int_MemRead,
				 o_MemtoReg => int_MemtoReg,
				 o_MemWrite => int_MemWrite,
				 o_ALUsrc => int_ALUsrc,
				 o_RegWrite => int_RegWrite,
				 o_aluOP => int_aluOP
	);
	
	MUX: MUX_2x1_8bit
	PORT MAP (input0(7) => int_RegWrite,
				 input0(6) => int_MemtoReg,
				 input0(5) => int_MemRead, 
				 input0(4) => int_MemWrite,
				 input0(3) => int_ALUsrc,
				 input0(2 downto 1) => int_aluOP,
				 input0(0) => int_RegDst,
				 input1 => "00000000",
				 SEL => ctrlMUX,
				 output => controlSig
	);
	
	-- Output Equations --
	Rs <= instruct(23 downto 21);
	highRt <= instruct(18 downto 16);
	lowRt <= instruct(13 downto 11);
	Rd <= instruct(5 downto 0);
	pcSrc <= int_Jump OR (int_Branch AND int_Equal);
	
END struct;