LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

--1. If (EX/MEM.RegWrite & (EX/MEM.RegisterRd ? 0) & (EX/MEM.RegisterRd=ID/EX.RegisterRs)) ForwardA= 10
--2. If (EX/MEM.RegWrite & (EX/MEM.RegisterRd ? 0) & (EX/MEM.RegisterRd=ID/EX.RegisterRt)) ForwardB= 10
--3. If (MEM/WB.RegWrite & (MEM/WB.RegisterRd ? 0) & (MEM/WB.RegisterRd=ID/EX.RegisterRs)) ForwardA= 01
--4. If (MEM/WB.RegWrite & (MEM/WB.RegisterRd ? 0) & (MEM/WB.RegisterRd=ID/EX.RegisterRt)) ForwardB= 01

ENTITY forward_unit IS
	PORT (
		in_EX_MEM_rd		  : IN STD_LOGIC_VECTOR (2 downto 0);
                in_ID_EX_rs, in_ID_EX_rt  : IN STD_LOGIC_VECTOR (2 downto 0);
		in_MEM_WB_rd              : IN STD_LOGIC_VECTOR (2 downto 0);
		
		in_EX_MEM_RegWrite        : IN STD_LOGIC;
		in_MEM_WB_RegWrite        : IN STD_LOGIC;

		o_forwardA, o_forwardB    : OUT STD_LOGIC_VECTOR (1 downto 0) );
END;

ARCHITECTURE struct OF forward_unit IS

	SIGNAL int_EX_MEM_rd_notZero, int_MEM_WB_rd_notZero   		  : STD_LOGIC;
	SIGNAL int_EX_MEM_rd_eq_ID_EX_rs, int_EX_MEM_rd_eq_ID_EX_rt    	  : STD_LOGIC;
	SIGNAL int_MEM_WB_rd_eq_ID_EX_rs, int_MEM_WB_rd_eq_ID_EX_rt    	  : STD_LOGIC;
	
BEGIN
	--Signal Assignment
	int_EX_MEM_rd_notZero <= in_EX_MEM_rd(0) OR in_EX_MEM_rd(1) OR in_EX_MEM_rd(2);
	int_MEM_WB_rd_notZero <= in_MEM_WB_rd(0) OR in_MEM_WB_rd(1) OR in_MEM_WB_rd(2);

	int_EX_MEM_rd_eq_ID_EX_rs <= (in_EX_MEM_rd(0) XNOR in_ID_EX_rs(0)) AND (in_EX_MEM_rd(1) XNOR in_ID_EX_rs(1)) AND (in_EX_MEM_rd(2) XNOR in_ID_EX_rs(2));
	int_EX_MEM_rd_eq_ID_EX_rt <= (in_EX_MEM_rd(0) XNOR in_ID_EX_rt(0)) AND (in_EX_MEM_rd(1) XNOR in_ID_EX_rt(1)) AND (in_EX_MEM_rd(2) XNOR in_ID_EX_rt(2));
	int_MEM_WB_rd_eq_ID_EX_rs <= (in_MEM_WB_rd(0) XNOR in_ID_EX_rs(0)) AND (in_MEM_WB_rd(1) XNOR in_ID_EX_rs(1)) AND (in_MEM_WB_rd(2) XNOR in_ID_EX_rs(2));
	int_MEM_WB_rd_eq_ID_EX_rt <= (in_MEM_WB_rd(0) XNOR in_ID_EX_rt(0)) AND (in_MEM_WB_rd(1) XNOR in_ID_EX_rt(1)) AND (in_MEM_WB_rd(2) XNOR in_ID_EX_rt(2));

	--Output Assignment
	o_forwardA(0) <= in_MEM_WB_RegWrite AND int_MEM_WB_rd_notZero AND int_MEM_WB_rd_eq_ID_EX_rs;
	o_forwardA(1) <= in_EX_MEM_RegWrite AND int_EX_MEM_rd_notZero AND int_EX_MEM_rd_eq_ID_EX_rs;
	o_forwardB(0) <= in_MEM_WB_RegWrite AND int_MEM_WB_rd_notZero AND int_MEM_WB_rd_eq_ID_EX_rt;
	o_forwardB(1) <= in_EX_MEM_RegWrite AND int_EX_MEM_rd_notZero AND int_EX_MEM_rd_eq_ID_EX_rt;
END struct;