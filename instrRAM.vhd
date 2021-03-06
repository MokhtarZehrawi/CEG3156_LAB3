--------------------------------------------------------------------------------
-- Title         : Load/Store RAM Data
-- Project       : Single Cycle MIPS Processor
-------------------------------------------------------------------------------
-- File          : instrRAM.vhd
-- Author        : Jainil Gandhi  <jgand039@uottawa.ca>
-- Created       : 2021/03/13
-- Last modified : 2021/03/13
-------------------------------------------------------------------------------
-- Description : This file loads/stores 8-bit data to "dataMem.vhd".
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY instrRAM IS
	PORT (
		aluResult, dataIN : IN STD_LOGIC_VECTOR (7 downto 0);
		Clk, Rst, MemWrite : IN STD_LOGIC;
		dataOUT : OUT STD_LOGIC_VECTOR (7 downto 0)
	);
END;

ARCHITECTURE struct OF instrRAM IS

SIGNAL int_regIn : STD_LOGIC_VECTOR (7 downto 0);

COMPONENT dataMem IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT Register_8bit IS
	PORT (
		in_Input			 : IN STD_LOGIC_VECTOR (7 downto 0);
		in_clk, in_en, in_resetbar	 : IN STD_LOGIC; 
		o_Output			 : OUT STD_LOGIC_VECTOR (7 downto 0) );
END COMPONENT;

BEGIN 	

	RAM: dataMem
	PORT MAP (address => aluResult,
			  clock => Clk,
			  data => dataIN,
			  wren => MemWrite,
			  q => int_regIn
	);
	
	STBLE: Register_8bit
	PORT MAP (in_Input => int_regIn,
		  in_clk => Clk,
		  in_en => '1',
		  in_resetbar => Rst,
		  o_Output => dataOut
	);

END struct;
