Library IEEE;
use ieee.std_logic_1164.all;
use work.Constants.all;

-- WB Stage Entity


ENTITY WBStage IS

	Generic(wordSize:integer :=16);
	PORT(
            ALU1, ALU2, Mem, inPort1, inPort2: in std_logic_vector(wordSize-1 downto 0);
            mux1Selector, mux2Selector: in std_logic_vector(1 downto 0);

            mux1Out, mux2Out: out std_logic_vector(wordSize-1 downto 0)
		);

END ENTITY WBStage;

----------------------------------------------------------------------
-- WB Stage Architecture

ARCHITECTURE WBStageArch of WBStage is

    

    BEGIN

        mux1Map: ENTITY work.Mux4 GENERIC MAP(wordSize) PORT MAP (
            ALU1, Mem, inPort1, ALU1, mux1Selector, mux1Out
        );

        mux2Map: ENTITY work.Mux4 GENERIC MAP(wordSize) PORT MAP (
            ALU2, Mem, inPort2, ALU2, mux2Selector, mux2Out
        );

        

END ARCHITECTURE;