LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

--1. If (ID/EX.MemRead & ((ID/EX.RegisterRt = IF/ID.RegisterRs) or (ID/EX.RegisterRt = IF/ID.RegisterRt))) <-- lw stall (hazard detected)
--2  If (IF/ID.op = 000100 AND data1 == data2) <--branch stall

ENTITY hazard_detection_unit IS
	PORT (
		in_ID_EX_MemRead	  : IN STD_LOGIC;
                in_ID_EX_rt		  : IN STD_LOGIC_VECTOR (2 downto 0);
		in_IF_ID_rs, in_IF_ID_rt  : IN STD_LOGIC_VECTOR (2 downto 0);

		in_IF_ID_op		  : IN STD_LOGIC_VECTOR (5 downto 0);
		in_Data1_eq_Data2	  : IN STD_LOGIC;
		

		o_controlMux, o_IF_ID_write, o_PC_write    : OUT STD_LOGIC );
END;

ARCHITECTURE struct OF hazard_detection_unit IS

	SIGNAL int_ID_EX_rt_eq_IF_ID_rs, int_ID_EX_rt_eq_IF_ID_rt    : STD_LOGIC;
	SIGNAL int_hazard, int_branch_stall, int_branch_if_eq	     : STD_LOGIC;

BEGIN
	--Signal Assignment
	

	int_ID_EX_rt_eq_IF_ID_rs <= (in_ID_EX_rt(0) XNOR in_IF_ID_rs(0)) AND (in_ID_EX_rt(1) XNOR in_IF_ID_rs(1)) AND (in_ID_EX_rt(2) XNOR in_IF_ID_rs(2));
	int_ID_EX_rt_eq_IF_ID_rt <= (in_ID_EX_rt(0) XNOR in_IF_ID_rt(0)) AND (in_ID_EX_rt(1) XNOR in_IF_ID_rt(1)) AND (in_ID_EX_rt(2) XNOR in_IF_ID_rt(2));
	
	int_hazard <= in_ID_EX_MemRead AND (int_ID_EX_rt_eq_IF_ID_rs OR int_ID_EX_rt_eq_IF_ID_rt);

	int_branch_if_eq <= (not(in_IF_ID_op(5)) AND not(in_IF_ID_op(4)) AND not(in_IF_ID_op(3)) AND in_IF_ID_op(2) AND not(in_IF_ID_op(1)) AND not(in_IF_ID_op(0)) );
	int_branch_stall <= int_branch_if_eq AND in_Data1_eq_Data2;

	--Output Assignment
	o_controlMux 	<= int_hazard;
	o_PC_write	<= not(int_hazard);
	o_IF_ID_write	<= not(int_hazard or int_branch_stall);
	

END struct;