LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
use IEEE.math_real.all;
USE work.Types.ARRAYOFREGS;

ENTITY Fetch IS

	Generic(wordSize: integer :=16; pcInputsNum: integer := 6);

	PORT(
            clk, reset: IN STD_LOGIC;
            pcEn: IN STD_LOGIC;
            pcSrcSelector: IN STD_LOGIC_VECTOR( integer(ceil(log2(real(pcInputsNum))))-1 DOWNTO 0);

            stackOutput, branchAddress, M0, M1: IN STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);

            dataOut1, dataOut2: OUT STD_LOGIC_VECTOR (wordSize-1 DOWNTO 0);
            pc: OUT STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0)

		);

END ENTITY Fetch;

------------------------------------------------------------

ARCHITECTURE FetchArch OF Fetch IS


    SIGNAL muxInputs : ARRAYOFREGS(0 TO pcInputsNum-1)(wordSize-1 DOWNTO 0);

    SIGNAL muxOutput : STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);

    SIGNAL pcPlusOne,pcPlusTwo : STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);

    SIGNAL pcPlusOneCarry, pcPlusTwoCarry : STD_LOGIC;

	
	BEGIN

    adderOneMap: ENTITY work.NBitAdder GENERIC MAP( wordSize ) PORT MAP (
                                                                            a => pc,
                                                                            b => ( 0=>'1', OTHERS=>'0'),
                                                                            carryIn=> '0',
                                                                            sum => pcPlusOne,
                                                                            carryOut =>pcPlusOneCarry
                                                                      );

    adderTwoMap: ENTITY work.NBitAdder GENERIC MAP( wordSize ) PORT MAP (
                                                                            a => pc,
                                                                            b => ( 1=>'1', OTHERS=>'0'),
                                                                            carryIn=> '0',
                                                                            sum => pcPlusTwo,
                                                                            carryOut =>pcPlusTwoCarry
                                                                        );

    muxInputs(0) <= pcPlusOne;
    muxInputs(1) <= pcPlusTwo;
    muxInputs(2) <= stackOutput;
    muxInputs(3) <= branchAddress;
    muxInputs(4) <= M0;
    muxInputs(5) <= M1;

    pcInMuxMap: ENTITY work.Mux GENERIC MAP(pcInputsNum , wordSize) PORT MAP (
                                                                        inputs =>  muxInputs,
                                                                        selectionLines =>  pcSrcSelector,
                                                                        output => muxOutput
                                                                    );

    pcRegMap: ENTITY work.Reg GENERIC MAP (wordSize) PORT MAP (
                                                        D =>  muxOutput,
                                                        en => pcEn, clk => clk , rst => reset ,
                                                        Q => pc
                                                    );

    instructionMemMap: ENTITY work.InstructionMemory GENERIC MAP (wordSize, wordSize) PORT MAP (
                                                                                                    clk =>  clk ,
                                                                                                    we =>  '0',
                                                                                                    address => pc ,
                                                                                                    addressPlusOne => pcPlusOne ,
                                                                                                    datain  =>  (OTHERS => '0' ),
                                                                                                    dataOut1 => dataOut1,
                                                                                                    dataOut2 => dataOut2
                                                                                                );


		
		
END ARCHITECTURE;