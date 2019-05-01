LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.math_real.all;
USE IEEE.numeric_std.all;
use work.Constants.all;

-- Register File Entity

ENTITY Decode IS

    GENERIC (regNum : integer := 3 ; wordSize : integer := 16); -- log of Number of registers , Size of each Register

  PORT(
        clk, reset: IN STD_LOGIC;

        instruction1, instruction2 : IN STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);

        wb1, wb2: IN STD_LOGIC;
        
        writeReg1, writeReg2 : IN STD_LOGIC_VECTOR(regNum-1 DOWNTO 0);

        writeData1, writeData2 : IN STD_LOGIC_VECTOR(wordSize-1  DOWNTO 0);

        ---------------------------------------------

        alu1Operation, alu2Operation : OUT STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0);

        inOperation: OUT STD_LOGIC;
        
        outPort : OUT STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);

        Src1, Src2, Dst1, Dst2 : OUT STD_LOGIC_VECTOR(regNum-1 DOWNTO 0);

        src1Data, dst1DataFinal, src2Data, dst2DataFinal : OUT STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);

        immediateValue : OUT STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0)
      );

END Decode;

----------------------------------------------------------------------
-- Register File Architecture

ARCHITECTURE DecodeArch OF Decode IS
     
      SIGNAL Src1Decoded, Dst1Decoded, Src2Decoded, Dst2Decoded, write1Decoded, write2Decoded : std_logic_vector((2**regNum - 1) DOWNTO 0);

      type myArray is array(0 to 2**regNum -1) of STD_LOGIC_VECTOR(wordSize-1 downto 0);

      SIGNAL myRegisters :myArray;

      SIGNAL writingData : myArray;--STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);

      SIGNAL regEn : STD_LOGIC_VECTOR((2**regNum)-1 DOWNTO 0);

      SIGNAL dst1Data, dst2Data, shiftAmount1, shiftAmount2: std_logic_vector(wordSize-1 downto 0) ;

  BEGIN

    alu1Operation <= instruction1(15 DOWNTO 11);

    Src1 <= instruction1(10 DOWNTO 8);
    Dst1 <= instruction1(7 DOWNTO 5);

    shiftAmount1(4 DOWNTO 0) <= instruction1(4 DOWNTO 0);
    shiftAmount1(15 DOWNTO 5) <= (others => '0');

    alu2Operation <= instruction2(15 DOWNTO 11);

    Src2 <= instruction2(10 DOWNTO 8);
    Dst2 <= instruction2(7 DOWNTO 5);

    shiftAmount2(4 DOWNTO 0) <= instruction2(4 DOWNTO 0);
    shiftAmount2(15 DOWNTO 5) <= (others => '0');

    src1DecodMap: ENTITY work.decoder GENERIC MAP (regNum) PORT MAP (Src1,'1',Src1Decoded);
    dst1DecodMap: ENTITY work.decoder GENERIC MAP (regNum) PORT MAP (Dst1,'1',Dst1Decoded);

    src2DecodMap: ENTITY work.decoder GENERIC MAP (regNum) PORT MAP (Src2,'1',Src2Decoded);
    dst2DecodMap: ENTITY work.decoder GENERIC MAP (regNum) PORT MAP (Dst2,'1',Dst2Decoded);

    write1DecodAMap: ENTITY work.decoder GENERIC MAP (regNum) PORT MAP (writeReg1, wb1, write1Decoded);
    write2DecodAMap: ENTITY work.decoder GENERIC MAP (regNum) PORT MAP (writeReg2, wb2, write2Decoded);

    regEn <= write1Decoded OR write2Decoded;

    -- TODO : problem , it does not write in writing data array
    -- writingData(TO_INTEGER(UNSIGNED(writeReg1))) <= writeData1;
    -- writingData(TO_INTEGER(UNSIGNED(writeReg2))) <= writeData2;

    -- writingData <= writeData1 when wb1 = '1' and wb2 = '0'
    -- else writeData2;

      loop1: FOR i IN 0 TO (2**regNum - 1)
          GENERATE

              writingData(i) <= writeData1 when write1Decoded(i) = '1' and write2Decoded(i) = '0'
              else writeData2;

              regMap: ENTITY work.reg GENERIC MAP(wordSize) PORT MAP (writingData(i), regEn(i), clk, reset, myRegisters(i));
              
              tristateSrc1Map: ENTITY work.tristate GENERIC MAP(wordSize) PORT MAP (myRegisters(i),Src1Decoded(i),src1Data);
              tristateSrc2Map: ENTITY work.tristate GENERIC MAP(wordSize) PORT MAP (myRegisters(i),Src2Decoded(i),src2Data);
              tristateDst1Map: ENTITY work.tristate GENERIC MAP(wordSize) PORT MAP (myRegisters(i),Dst1Decoded(i),dst1Data);
              tristateDst2Map: ENTITY work.tristate GENERIC MAP(wordSize) PORT MAP (myRegisters(i),Dst2Decoded(i),dst2Data);

      END GENERATE;

    inOperation <= '1' WHEN ( instruction1(15 DOWNTO 11) = opIN OR instruction2(15 DOWNTO 11) = opIN )
    ELSE '0';

    dst1DataFinal <= shiftAmount1 when instruction1(15 DOWNTO 11) = opSHL or instruction1(15 DOWNTO 11) = opSHR
    else dst1Data; 

    dst2DataFinal <= shiftAmount2 when instruction2(15 DOWNTO 11) = opSHL or instruction2(15 DOWNTO 11) = opSHR
    else dst2Data;

    immediateValue <= instruction2;

  END DecodeArch;