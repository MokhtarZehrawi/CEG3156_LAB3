LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY MUX_3x1 IS
	PORT (
		input : IN STD_LOGIC_VECTOR (2 downto 0);
		sel : IN STD_LOGIC_VECTOR (1 downto 0);
		output : OUT STD_LOGIC
	);
END;

ARCHITECTURE struct OF MUX_3x1 IS
SIGNAL int_sig : STD_LOGIC;

COMPONENT MUX_2x1 IS
	PORT (
		input : IN STD_LOGIC_VECTOR (1 downto 0);
		sel : IN STD_LOGIC;
		output : OUT STD_LOGIC
	);
END COMPONENT;

BEGIN

	-- Component Intantiation --
	MUX1: MUX_2x1
	PORT MAP (input => input(1 downto 0),
		  sel => sel(0),
		  output => int_sig
	);

	MUX2: MUX_2X1
	PORT MAP (input(0) => int_sig,
		  input(1) => input(2),
		  sel => sel(1),
		  output => output
	);
END struct;
