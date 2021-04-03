--------------------------------------------------------------------------------
-- Title         : 8-bit Check if Equal
-- Project       : Pipelined Single Cycle MIPS Processor
-------------------------------------------------------------------------------
-- File          : isEqual_8bit.vhd
-- Author        : Jainil Gandhi  <jgand039@uottawa.ca>
-- Created       : 2021/04/02
-- Last modified : 2021/04/02
-------------------------------------------------------------------------------
-- Description : This component outputs 1 if A and B are equal and 0 otherwise.
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY isEqual_8bit IS
	PORT (
			A, B : IN STD_LOGIC_VECTOR (7 downto 0);
			Equal : OUT STD_LOGIC
	);
END;

ARCHITECTURE struct OF isEqual_8bit IS

SIGNAL int_notEq : STD_LOGIC;

BEGIN
	
	int_notEq <= (A(7) XOR B(7)) AND (A(6) XOR B(6)) AND (A(5) XOR B(5)) AND (A(4) XOR B(4)) AND (A(3) XOR B(3)) AND (A(2) XOR B(2)) AND (A(1) XOR B(1)) AND (A(0) XOR B(0));
	Equal <= NOT int_notEq;
	
END struct;