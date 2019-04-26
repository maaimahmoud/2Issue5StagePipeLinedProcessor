Library IEEE;
use ieee.std_logic_1164.all;

-- Mux2 Entity

--if S = 0 then C = A
--if S = 1 then C = B

ENTITY Mux2 IS

	Generic(wordSize:integer :=32);
	PORT(
			A, B: in STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
			S: in STD_LOGIC;
			C: out STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0)
		);

END ENTITY Mux2;

----------------------------------------------------------------------
-- MUX2 Architecture

ARCHITECTURE Mux2Arch of Mux2 is

BEGIN

    C <= A when S = '0'
    else B;

END ARCHITECTURE;