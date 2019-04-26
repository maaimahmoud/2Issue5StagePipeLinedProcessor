Library IEEE;
use ieee.std_logic_1164.all;

-- MUX5 Entity



ENTITY Mux5 IS

	Generic(wordSize:integer :=16);
	PORT(
			A, B, C, D, E: in STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
			S: in STD_LOGIC_VECTOR(2 DOWNTO 0);
			Z: out STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0)
		);

END ENTITY Mux5;

----------------------------------------------------------------------
-- MUX5 Architecture

ARCHITECTURE Mux5Arch of Mux5 is

BEGIN

    Z <= A when S = "000"
    else B when S = "001"
    else C when S = "010"
    else D when S = "011";
    else E;

END ARCHITECTURE;