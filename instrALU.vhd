--------------------------------------------------------------------------------
-- Title         : Instruction ALU Compute
-- Project       : Pipelined Single Cycle MIPS Processor
-------------------------------------------------------------------------------
-- File          : instrALU.vhd
-- Author        : Jainil Gandhi  <jgand039@uottawa.ca>
-- Created       : 2021/04/02
-- Last modified : 2021/04/02
-------------------------------------------------------------------------------
-- Description : This file takes in two 8-bit values from the processor register
--		 and computes them in the unitALU_8bit.vhd according to the 
--		 command given by the controlALU.vhd. The ALU control unit  
-- 		 decodes the commands using instructions and ALUOp values
--		 given by the processor control unit.
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY instrALU IS
	PORT (
		Data1, Data2, prevResult, loadData : IN STD_LOGIC_VECTOR (7 downto 0);
		Func : IN STD_LOGIC_VECTOR (5 downto 0);
		Rt, Rd : IN STD_LOGIC_VECTOR (2 downto 0);
		ALUOp, forwardA, forwardB : IN STD_LOGIC_VECTOR (1 downto 0);
		RegDst : IN STD_LOGIC;
		Result : OUT STD_LOGIC_VECTOR (7 downto 0);
		RegAddr : OUT STD_LOGIC_VECTOR (2 downto 0);
		Zero, Ovr : OUT STD_LOGIC
	);
END;

ARCHITECTURE struct OF instrALU IS

SIGNAL int_A, int_B, int_RegAddr : STD_LOGIC_VECTOR (7 downto 0);
SIGNAL int_Op : STD_LOGIC_VECTOR (2 downto 0);

COMPONENT unitALU_8bit IS
	PORT (
		A, B : IN STD_LOGIC_VECTOR (7 downto 0);
		Op : IN STD_LOGIC_VECTOR (2 downto 0);
		Output : OUT STD_LOGIC_VECTOR (7 downto 0);
		Zero, Ovr : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT controlALU IS
	PORT (
		Func : IN STD_LOGIC_VECTOR (5 downto 0);
		ALUOp : IN STD_LOGIC_VECTOR (1 downto 0);
		Op : OUT STD_LOGIC_VECTOR (2 downto 0)
	);
END COMPONENT;

COMPONENT MUX_2x1_8bit IS
	PORT (
		input0, input1  : IN STD_LOGIC_VECTOR (7 downto 0);
		SEL 		: IN STD_LOGIC;
		output 		: OUT STD_LOGIC_VECTOR (7 downto 0)
	);
END COMPONENT;

COMPONENT MUX_3x1_8bit IS
	PORT (
		input0, input1, input2 : IN STD_LOGIC_VECTOR (7 downto 0);
		sel : IN STD_LOGIC_VECTOR (1 downto 0);
		output : OUT STD_LOGIC_VECTOR (7 downto 0)
	);
END COMPONENT;

BEGIN

	-- Component Instantiation --
	MUX_RegAddr: MUX_2x1_8bit
	PORT MAP (input0(7 downto 3) => "00000",
				 input0(2 downto 0) => Rt,
				 input1(7 downto 3) => "00000",
				 input1(2 downto 0) => Rd,
				 SEL => RegDst,
				 output => int_RegAddr
	);
	
	MUX_A: MUX_3x1_8bit
	PORT MAP (input0 => Data1,
				 input1 => loadData,
				 input2 => prevResult,
				 sel => forwardA,
				 output => int_A
	);
	
	MUX_B: MUX_3x1_8bit
	PORT MAP (input0 => Data2,
				 input1 => loadData,
				 input2 => prevResult,
				 sel => forwardB,
				 output => int_B
	);

	ALU: unitALU_8bit
	PORT MAP (A => int_A,
		  B => int_B,
		  Op => int_Op,
		  Output => Result,
		  Zero => Zero,
		  Ovr => OPEN
	);

	CTRL: controlALU
	PORT MAP (Func => Func,
		  ALUOp => ALUOp,
		  Op => int_Op
	);
	
	RegAddr <= int_RegAddr(2 downto 0);

END struct;
		