LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.math_real.all;
LIBRARY work;
USE IEEE.numeric_std.all;
use work.Constants.all;

-- Register File Entity

ENTITY Decode IS

    GENERIC (regNum : integer := 3 ; wordSize : integer := 16); -- log of Number of registers , Size of each Register

  PORT(
        clk, reset: IN STD_LOGIC;

        instruction1, instruction2 : IN STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
        
        writeReg1, writeReg2 : IN STD_LOGIC_VECTOR(regNum-1 DOWNTO 0);

        writeData1, writeData2 : IN STD_LOGIC_VECTOR(wordSize-1  DOWNTO 0);

        ---------------------------------------------

        alu1Operation, alu2Operation : OUT STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0);

        inOperation: OUT STD_LOGIC;
        
        outPort : OUT STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);

        Src1, Src2, Dst1, Dst2 : OUT STD_LOGIC_VECTOR(regNum-1 DOWNTO 0);

        src1Data, dst1Data, src2Data, dst2Data : OUT STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0)

      );

END Decode;

----------------------------------------------------------------------
-- Register File Architecture

ARCHITECTURE DecodeArch OF Decode IS
     
      SIGNAL Src1Decoded, Dst1Decoded, Src2Decoded, Dst2Decoded, write1Decoded, write2Decoded : std_logic_vector((2**regNum - 1) DOWNTO 0);

      type myArray is array(0 to 2**regNum -1) of STD_LOGIC_VECTOR(wordSize-1 downto 0);

      SIGNAL myRegisters :myArray;

      SIGNAL writingData :myArray;

      SIGNAL regEn : STD_LOGIC_VECTOR((2**regNum)-1 DOWNTO 0);

      SIGNAL outRegInput : STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
      SIGNAL outRegSelect, outRegEn : STD_LOGIC;


  BEGIN

    alu1Operation <= instruction1(15 DOWNTO 10);

    Src1 <= instruction1(9 DOWNTO 7);
    Dst1 <= instruction1(6 DOWNTO 4);

    alu2Operation <= instruction2(15 DOWNTO 10);

    Src2 <= instruction2(9 DOWNTO 7);
    Dst2 <= instruction2(6 DOWNTO 4);

    src1DecodMap: ENTITY work.decoder GENERIC MAP (regNum) PORT MAP (Src1,'1',Src1Decoded);
    dst1DecodMap: ENTITY work.decoder GENERIC MAP (regNum) PORT MAP (Dst1,'1',Dst1Decoded);

    src2DecodMap: ENTITY work.decoder GENERIC MAP (regNum) PORT MAP (Src2,'1',Src2Decoded);
    dst2DecodMap: ENTITY work.decoder GENERIC MAP (regNum) PORT MAP (Dst2,'1',Dst2Decoded);

    write1DecodAMap: ENTITY work.decoder GENERIC MAP (regNum) PORT MAP (writeReg1,'1',write1Decoded);
    write2DecodAMap: ENTITY work.decoder GENERIC MAP (regNum) PORT MAP (writeReg2,'1',write2Decoded);

    regEn <= write1Decoded OR write2Decoded;

    writingData(TO_INTEGER(UNSIGNED(writeReg1))) <= writeData1;
    writingData(TO_INTEGER(UNSIGNED(writeReg2))) <= writeData2;

      loop1: FOR i IN 0 TO (2**regNum - 1)
          GENERATE

              regMap: ENTITY work.reg GENERIC MAP(wordSize) PORT MAP (writingData(i),regEn(i),reset,clk,myRegisters(i));
              
              tristateSrc1Map: ENTITY work.tristate GENERIC MAP(wordSize) PORT MAP (myRegisters(i),Src1Decoded(i),src1Data);
              tristateSrc2Map: ENTITY work.tristate GENERIC MAP(wordSize) PORT MAP (myRegisters(i),Src2Decoded(i),src2Data);
              tristateDst1Map: ENTITY work.tristate GENERIC MAP(wordSize) PORT MAP (myRegisters(i),Dst1Decoded(i),dst1Data);
              tristateDst2Map: ENTITY work.tristate GENERIC MAP(wordSize) PORT MAP (myRegisters(i),Dst2Decoded(i),dst2Data);

          END GENERATE;

    inOperation <= '1' WHEN ( instruction1(15 DOWNTO 10) = "001001" OR instruction2(15 DOWNTO 10) = "001001" )
    ELSE '0';


    outRegEn <= '1' WHEN ( instruction1(15 DOWNTO 10) = "001000" OR instruction2(15 DOWNTO 10) = "001000" )
    ELSE '0';
    
    outRegSelect <= '0' WHEN ( instruction1(15 DOWNTO 10) = "001000" )
    ELSE '1';

    outMuxMap: ENTITY work.mux2 GENERIC MAP(wordSize) PORT MAP(
                                                        A => dst1Data, B => dst2Data ,
                                                        S => outRegSelect,
                                                        C => outRegInput
                                                      );

    outRegMap: ENTITY work.Reg GENERIC MAP(wordSize) PORT MAP (
                                                                D => outRegInput,
                                                                en => outRegEn, clk => clk, rst =>reset ,
                                                                Q => outPort
                                                                );

  END DecodeArch;