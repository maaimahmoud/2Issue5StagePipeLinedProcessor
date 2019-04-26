Library IEEE;
use ieee.std_logic_1164.all;

-- DFlipFlop Entity

ENTITY DFlipFlop IS
	PORT(
			D: in STD_LOGIC;
			en, clk, rst: in STD_LOGIC;
			Q: out STD_LOGIC
		);

END ENTITY DFlipFlop;

----------------------------------------------------------------------
-- DFlipFlop Architecture

ARCHITECTURE DFlipFlopArch of DFlipFlop is

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