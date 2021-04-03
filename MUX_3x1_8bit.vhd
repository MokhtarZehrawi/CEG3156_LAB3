LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY MUX_3x1_8bit IS
	PORT (
		input0, input1, input2 : IN STD_LOGIC_VECTOR (7 downto 0);
		sel : IN STD_LOGIC_VECTOR (1 downto 0);
		output : OUT STD_LOGIC_VECTOR (7 downto 0)
	);
END;

ARCHITECTURE struct OF MUX_3x1_8bit IS

COMPONENT MUX_3x1 IS
	PORT (
			input : IN STD_LOGIC_VECTOR (2 downto 0);
			sel : IN STD_LOGIC_VECTOR (1 downto 0);
			output : OUT STD_LOGIC
		);
END COMPONENT;

BEGIN

	MUX7: MUX_3x1
	PORT MAP (input(0) => input0(7),
				 input(1) => input1(7),
				 input(2) => input2(7),
				 sel => sel,
				 output => output(7)
	);
	
	MUX6: MUX_3x1
	PORT MAP (input(0) => input0(6),
				 input(1) => input1(6),
				 input(2) => input2(6),
				 sel => sel,
				 output => output(6)
	);
	
	MUX5: MUX_3x1
	PORT MAP (input(0) => input0(5),
				 input(1) => input1(5),
				 input(2) => input2(5),
				 sel => sel,
				 output => output(5)
	);
	
	MUX4: MUX_3x1
	PORT MAP (input(0) => input0(4),
				 input(1) => input1(4),
				 input(2) => input2(4),
				 sel => sel,
				 output => output(4)
	);
	
	MUX3: MUX_3x1
	PORT MAP (input(0) => input0(3),
				 input(1) => input1(3),
				 input(2) => input2(3),
				 sel => sel,
				 output => output(3)
	);
	
	MUX2: MUX_3x1
	PORT MAP (input(0) => input0(2),
				 input(1) => input1(2),
				 input(2) => input2(2),
				 sel => sel,
				 output => output(2)
	);
	
	MUX1: MUX_3x1
	PORT MAP (input(0) => input0(1),
				 input(1) => input1(1),
				 input(2) => input2(1),
				 sel => sel,
				 output => output(1)
	);
	
	MUX0: MUX_3x1
	PORT MAP (input(0) => input0(0),
				 input(1) => input1(0),
				 input(2) => input2(0),
				 sel => sel,
				 output => output(0)
	);
	
END struct;