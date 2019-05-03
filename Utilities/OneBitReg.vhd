Library IEEE;
use ieee.std_logic_1164.all;

-- Register Entity

ENTITY OneBitReg IS

	PORT(
			D: in std_logic;
			en, clk, rst: in STD_LOGIC;
			Q: out STD_LOGIC
		);

END ENTITY OneBitReg;

----------------------------------------------------------------------
-- Register Architecture

ARCHITECTURE OneBitRegArch of OneBitReg is

BEGIN

	PROCESS(D,clk, en, rst)
		BEGIN
			IF rst ='1' THEN
				Q <= '0';
            ELSIF clk'EVENT AND clk='1' THEN
                IF en='1' THEN
                    Q <= D;
                END IF;
			END IF;

		END PROCESS;

END ARCHITECTURE;