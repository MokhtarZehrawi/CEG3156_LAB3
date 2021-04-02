-------------------------------------------------------------------------------
-- Title         : 15-bit Active Low Reset Register
-- Project       : Pipelined Single Cycle MIPS Processor
-------------------------------------------------------------------------------
-- File          : Register_15bit.vhd
-- Author        : Jainil Gandhi  <jgand039@uottawa.ca>
-- Created       : 2021/04/01
-- Last modified : 2021/04/01
-------------------------------------------------------------------------------
-- Description : This register is created to be later used as EX/MEM buffer pipe
--		 for the top-level processor_8bit.vhd
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Register_15bit IS
	PORT (
		Input : IN STD_LOGIC_VECTOR (14 downto 0);
		Clk, Rst, En : IN STD_LOGIC;
		Output : OUT STD_LOGIC_VECTOR (14 downto 0)
	);
END;

ARCHITECTURE struct OF Register_15bit IS

COMPONENT enARdFF_2 IS
	PORT(
		i_resetBar	: IN	STD_LOGIC;
		i_d		: IN	STD_LOGIC;
		i_enable	: IN	STD_LOGIC;
		i_clock		: IN	STD_LOGIC;
		o_q, o_qBar	: OUT	STD_LOGIC);
END COMPONENT;

BEGIN

	-- Component Instantiation --
	FF14: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(14),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(14),
		  o_qBar => OPEN
	);

	FF13: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(13),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(13),
		  o_qBar => OPEN
	);

	FF12: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(12),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(12),
		  o_qBar => OPEN
	);

	FF11: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(11),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(11),
		  o_qBar => OPEN
	);

	FF10: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(10),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(10),
		  o_qBar => OPEN
	);

	FF9: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(9),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(9),
		  o_qBar => OPEN
	);

	FF8: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(8),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(8),
		  o_qBar => OPEN
	);

	FF7: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(7),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(7),
		  o_qBar => OPEN
	);

	FF6: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(6),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(6),
		  o_qBar => OPEN
	);

	FF5: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(5),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(5),
		  o_qBar => OPEN
	);

	FF4: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(4),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(4),
		  o_qBar => OPEN
	);

	FF3: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(3),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(3),
		  o_qBar => OPEN
	);

	FF2: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(2),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(2),
		  o_qBar => OPEN
	);

	FF1: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(1),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(1),
		  o_qBar => OPEN
	);

	FF0: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(0),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(0),
		  o_qBar => OPEN
	);

END struct;