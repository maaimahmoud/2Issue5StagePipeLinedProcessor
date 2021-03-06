Library IEEE;
use ieee.std_logic_1164.all;
USE work.Constants.all;

-- ALU Entity


ENTITY ALU IS

	Generic(
            wordSize: integer := 16
        );
	PORT(
			src, dst: in STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
            operation: in STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0);
            flagIn: in std_logic_vector(flagSize-1 downto 0);
            changeFlag: in std_logic;
            clk, reset: in std_logic;
            result: out STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
            flagOut: out std_logic_vector(flagSize-1 downto 0)
		);

END ENTITY ALU;

----------------------------------------------------------------------
-- ALU Architecture

ARCHITECTURE ALUArch of ALU is

    SIGNAL one, twosInput, twosOutput, adderInput, adderOutput, outShifterRight, outShifterLeft, adderInput1, resultTemp: STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
    SIGNAL carryOutShifterRight, carryOutShifterLeft, carryOutAdder, flagAdder: STD_LOGIC;

    BEGIN

        one <= (0 => '1', others => '0');

        -----------------------------------------------------------------------------

        -- twosCompMap: ENTITY work.TwosComplement GENERIC MAP(wordSize) PORT MAP (twosInput, twosOutput);
        -- adderMap: ENTITY work.NBitAdder GENERIC MAP(wordSize) PORT MAP(dst, adderInput, '0', adderOutput, carryOutAdder);

        -- twosInput <= one when operation = opDEC
        -- else src;

        -- adderInput <= one when operation = opINC
        -- else src when operation = opADD
        -- else twosOutput;

        twosCompMap: ENTITY work.TwosComplement GENERIC MAP(wordSize) PORT MAP (twosInput, twosOutput);
        adderMap: ENTITY work.NBitAdder GENERIC MAP(wordSize) PORT MAP(adderInput1, adderInput, flagAdder, adderOutput, carryOutAdder);

        adderInput1 <= src when operation = opSUB
        else dst;

        twosInput <= one when operation = opDEC
        else dst;

        adderInput <= one when operation = opINC
        else src when operation = opADD
        else twosOutput;

        -- flagAdder <= flagIn(CFlag) when operation = opADD or operation = opSUB
        -- else '0';
        flagAdder <= '0';

        -----------------------------------------------------------------------------

        shifterRightMap: ENTITY work.RightShifter GENERIC MAP(wordSize) PORT MAP(
            src, dst(4 DOWNTO 0),
            flagIn(CFLAG),
            outShifterRight,
            carryOutShifterRight
        );

        shifterLeftMap: ENTITY work.LeftShifter GENERIC MAP(wordSize) PORT MAP(
            src, dst(4 DOWNTO 0),
            flagIn(CFLAG),
            outShifterLeft,
            carryOutShifterLeft
        );

        -----------------------------------------------------------------------------

        resultTemp <=   NOT dst                 when operation = opNOT
        else        adderOutput             when operation = opINC
        else        adderOutput             when operation = opDEC
        else        src                     when operation = opMOV
        else        adderOutput             when operation = opADD
        else        adderOutput             when operation = opSUB
        else        src AND dst             when operation = opAND
        else        src OR dst              when operation = opOR
        else        outShifterLeft          when operation = opSHL
        else        outShifterRight         when operation = opSHR
        else        (others => '0');

        resultRegMap: ENTITY work.Reg GENERIC MAP(wordSize) PORT MAP
        (
            resultTemp, '1', clk, reset, result
        );

        -----------------------------------------------------------------------------

        flagOut(ZFlag) <= '1' when changeFlag = '1' and resultTemp = "0000000000000000" and not (operation = opSETC or operation = opCLRC or operation = opJZ or operation = opJN or operation = opJC or operation = opMOV or operation = opCALL or operation = opRET or operation = opRTI)
        else '0' when changeFlag = '1' and operation = opJZ
        else '0' when changeFlag = '1' and operation /= opJC and operation /= opJN
        else flagIn(ZFlag);

        flagOut(CFlag) <= carryOutShifterRight when changeFlag = '1' and operation = opSHR
        else carryOutShifterLeft when changeFlag = '1' and operation = opSHL
        else '1' when changeFlag = '1' and operation = opSETC
        else '0' when changeFlag = '1' and operation = opCLRC
        else carryOutAdder when changeFlag = '1' and (operation = opINC or operation = opDEC or operation = opADD or operation = opSUB) 
        else '0' when changeFlag = '1' and operation = opJC
        else flagIn(CFlag);

        flagOut(NFlag) <= '1' when changeFlag = '1' and  resultTemp(wordSize-1) = '1' and not (operation = opSETC or operation = opCLRC or operation = opJZ or operation = opJN or operation = opJC or operation = opMOV or operation = opCALL or operation = opRET or operation = opRTI)
        else '0' when changeFlag = '1' and operation = opJN
        else '0' when changeFlag = '1' and operation /= opJC and operation /= opJZ
        else flagIn(NFlag);

        -----------------------------------------------------------------------------

END ARCHITECTURE;