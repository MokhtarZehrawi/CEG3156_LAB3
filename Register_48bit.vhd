--------------------------------------------------------------------------------
-- Title         : 48-bit Active Low Reset Register
-- Project       : Pipelined Single Cycle MIPS Processor
-------------------------------------------------------------------------------
-- File          : Register_48bit.vhd
-- Author        : Jainil Gandhi  <jgand039@uottawa.ca>
-- Created       : 2021/04/01
-- Last modified : 2021/04/01
-------------------------------------------------------------------------------
-- Description : This register is created to be later used as ID/EX buffer pipe
--		 for the top-level processor_8bit.vhd
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Register_48bit IS
	PORT (
		Input : IN STD_LOGIC_VECTOR (47 downto 0);
		Clk, Rst, En : IN STD_LOGIC;
		Output : OUT STD_LOGIC_VECTOR (47 downto 0)
	);
END;

ARCHITECTURE struct OF Register_48bit IS

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
	FF47: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(47),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(47),
		  o_qBar => OPEN
	);
	
	FF46: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(46),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(46),
		  o_qBar => OPEN
	);
	
	FF45: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(45),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(45),
		  o_qBar => OPEN
	);
	
	FF44: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(44),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(44),
		  o_qBar => OPEN
	);
	
	FF43: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(43),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(43),
		  o_qBar => OPEN
	);
	
	FF42: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(42),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(42),
		  o_qBar => OPEN
	);
	
	FF41: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(41),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(41),
		  o_qBar => OPEN
	);
	
	FF40: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(40),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(40),
		  o_qBar => OPEN
	);
	
	FF39: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(39),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(39),
		  o_qBar => OPEN
	);
	
	FF38: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(38),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(38),
		  o_qBar => OPEN
	);
	
	FF37: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(37),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(37),
		  o_qBar => OPEN
	);

	FF36: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(36),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(36),
		  o_qBar => OPEN
	);

	FF35: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(35),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(35),
		  o_qBar => OPEN
	);

	FF34: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(34),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(34),
		  o_qBar => OPEN
	);

	FF33: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(33),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(33),
		  o_qBar => OPEN
	);

	FF32: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(32),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(32),
		  o_qBar => OPEN
	);

	FF31: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(31),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(31),
		  o_qBar => OPEN
	);

	FF30: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(30),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(30),
		  o_qBar => OPEN
	);

	FF29: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(29),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(29),
		  o_qBar => OPEN
	);

	FF28: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(28),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(28),
		  o_qBar => OPEN
	);

	FF27: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(27),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(27),
		  o_qBar => OPEN
	);

	FF26: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(26),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(26),
		  o_qBar => OPEN
	);

	FF25: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(25),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(25),
		  o_qBar => OPEN
	);

	FF24: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(24),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(24),
		  o_qBar => OPEN
	);
	
	FF23: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(23),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(23),
		  o_qBar => OPEN
	);

	FF22: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(22),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(22),
		  o_qBar => OPEN
	);

	FF21: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(21),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(21),
		  o_qBar => OPEN
	);

	FF20: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(20),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(20),
		  o_qBar => OPEN
	);
	
	FF19: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(19),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(19),
		  o_qBar => OPEN
	);

	FF18: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(18),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(18),
		  o_qBar => OPEN
	);

	FF17: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(17),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(17),
		  o_qBar => OPEN
	);

	FF16: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(16),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(16),
		  o_qBar => OPEN
	);

	FF15: enARdFF_2
	PORT MAP (i_resetBar => Rst,
		  i_d => Input(15),
		  i_enable => En,
		  i_clock => Clk,
		  o_q => Output(15),
		  o_qBar => OPEN
	);

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
		