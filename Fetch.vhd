LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
use IEEE.math_real.all;
USE work.Types.ARRAYOFREGS;

ENTITY Fetch IS

	Generic(addressBits: integer:=20 ; wordSize: integer :=16; pcInputsNum: integer := 6);

	PORT(
            clk, reset: IN STD_LOGIC;
            pcEn: IN STD_LOGIC;
            pcSrcSelector: IN STD_LOGIC_VECTOR( integer(ceil(log2(real(pcInputsNum))))-1 DOWNTO 0);

            stackOutput, branchAddress:IN STD_LOGIC_VECTOR((2*wordSize)-1 DOWNTO 0);
            -- M0, M1: IN STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);

            dataOut1, dataOut2: OUT STD_LOGIC_VECTOR (wordSize-1 DOWNTO 0);
            pc: OUT STD_LOGIC_VECTOR((2*wordSize)-1 DOWNTO 0)

		);

END ENTITY Fetch;

------------------------------------------------------------

ARCHITECTURE FetchArch OF Fetch IS


    SIGNAL muxInputs : ARRAYOFREGS(0 TO pcInputsNum-1)((2*wordSize)-1 DOWNTO 0);

    SIGNAL plusOneAdderIn, plusTwoAdderIn, muxOutput : STD_LOGIC_VECTOR((2*wordSize)-1 DOWNTO 0);

    SIGNAL pcPlusOne,pcPlusTwo : STD_LOGIC_VECTOR((2*wordSize)-1 DOWNTO 0);

    SIGNAL pcPlusOneCarry, pcPlusTwoCarry : STD_LOGIC;

	SIGNAL M0, M1: STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);

	BEGIN

    plusOneAdderIn <= (OTHERS=>'0') WHEN reset = '1'
    ELSE ( 0=>'1', OTHERS=>'0');

    adderOneMap: ENTITY work.NBitAdder GENERIC MAP( (2*wordSize) ) PORT MAP (
        a => pc,
        b => plusOneAdderIn,
        carryIn=> '0',
        sum => pcPlusOne,
        carryOut =>pcPlusOneCarry
    );

    plusTwoAdderIn <= (OTHERS=>'0') WHEN reset = '1'
    ELSE ( 1=>'1', OTHERS=>'0');

    adderTwoMap: ENTITY work.NBitAdder GENERIC MAP( (2*wordSize) ) PORT MAP (
        a => pc,
        b => plusTwoAdderIn,
        carryIn=> '0',
        sum => pcPlusTwo,
        carryOut =>pcPlusTwoCarry
    );

    muxInputs(0) <= pcPlusOne;
    muxInputs(1) <= pcPlusTwo;
    muxInputs(2) <= stackOutput;
    muxInputs(3) <= branchAddress;
    muxInputs(4)(wordSize-1 DOWNTO 0) <= M0;
    muxInputs(4)((2*wordSize)-1 DOWNTO wordSize) <= (OTHERS => '0');
    muxInputs(5)(wordSize-1 DOWNTO 0) <= M1;
    muxInputs(5)((2*wordSize)-1 DOWNTO wordSize) <= (OTHERS => '0');

    pcInMuxMap: ENTITY work.Mux GENERIC MAP(pcInputsNum , (2*wordSize)) PORT MAP (
        inputs =>  muxInputs,
        selectionLines =>  pcSrcSelector,
        output => muxOutput
    );

    pcRegMap: ENTITY work.Reg GENERIC MAP ((2*wordSize)) PORT MAP (
        D =>  muxOutput,
        en => pcEn, clk => clk , rst => '0' ,
        Q => pc
    );

    instructionMemMap: ENTITY work.InstructionMemory GENERIC MAP (addressBits, wordSize) PORT MAP (
        clk =>  clk ,
        we =>  '0',
        address => pc(addressBits-1 downto 0) ,
        datain  =>  (OTHERS => '0' ),
        M0 => M0, M1 => M1,
        dataOut1 => dataOut1,
        dataOut2 => dataOut2
    );


		
		
END ARCHITECTURE;