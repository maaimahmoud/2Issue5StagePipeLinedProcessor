Library IEEE;
use ieee.std_logic_1164.all;
use work.Constants.all;

-- Execute Stage Entity



ENTITY ExecuteStage IS

	Generic(wordSize:integer :=16);
	PORT(
            RSrcV1, RDstV1,
            RSrcV2, RDstV2,

            MEM1In, MEM2In,
            WB1In, WB2In: in std_logic_vector(wordSize-1 downto 0);

            mux1Selector, mux2Selector,
            mux3Selector, mux4Selector: in std_logic_vector(2 downto 0);

            alu1Operation, alu2Operation: in std_logic_vector(operationSize-1 downto 0);

            flagIn: in std_logic_vector(flagSize-1 downto 0);

            EX1, EX2: in std_logic;

            ALU1Out, ALU2Out: out std_logic_vector(wordSize-1 downto 0);

            flagOut: out std_logic_vector(flagSize-1 downto 0)
		);

END ENTITY ExecuteStage;

----------------------------------------------------------------------
-- ExecuteStage Architecture

ARCHITECTURE ExecuteStageArch of ExecuteStage is

    SIGNAL alu1Op1, alu1Op2, alu2Op1, alu2Op2: std_logic_vector(wordSize-1 downto 0);
    SIGNAL flag1Out, flag2Out: std_logic_vector(flagSize-1 downto 0);

    BEGIN

        mux1Map: ENTITY work.Mux5 GENERIC MAP(wordSize) PORT MAP (
            RSrcV1, MEM1In, MEM2In, WB1In, WB2In, mux1Selector, alu1Op1
        );

        mux2Map: ENTITY work.Mux5 GENERIC MAP(wordSize) PORT MAP (
            RDstV1, MEM1In, MEM2In, WB1In, WB2In, mux1Selector, alu1Op2
        );

        mux3Map: ENTITY work.Mux5 GENERIC MAP(wordSize) PORT MAP (
            RSrcV2, MEM1In, MEM2In, WB1In, WB2In, mux1Selector, alu2Op1
        );

        mux4Map: ENTITY work.Mux5 GENERIC MAP(wordSize) PORT MAP (
            RDstV2, MEM1In, MEM2In, WB1In, WB2In, mux1Selector, alu2Op2
        );

        -----------------------------------------------------------------------------

        alu1Map: ENTITY work.ALU GENERIC MAP(wordSize) PORT MAP(
            alu1Op1, alu1Op2, 
            alu1Operation, flagIn,
            EX1, 
            ALU1Out,
            flag1Out
        );

        alu2Map: ENTITY work.ALU GENERIC MAP(wordSize) PORT MAP(
            alu2Op1, alu2Op2, 
            alu2Operation, flagIn,
            EX2, 
            ALU2Out,
            flag2Out
        );

        -----------------------------------------------------------------------------

        flagOut <= flag2Out when EX1 = '1' and EX2 = '1'
        else flag2Out when EX1 = '0' and EX2 = '1'
        else flag1Out when EX1 = '1' and EX2 = '0'
        else flagIn;

END ARCHITECTURE;