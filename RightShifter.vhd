LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

-- Right Shifter Entity

ENTITY RightShifter IS
       GENERIC (
           wordSize : INTEGER := 16
           );
  PORT(
      input: IN STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
      shiftAmount: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
      carryIn: IN STD_LOGIC;
      output: OUT STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
      carryOut: OUT STD_LOGIC
    );

END RightShifter;

------------------------------------------------------------

-- Right Shifter Architecture

ARCHITECTURE RightShifterArch OF RightShifter IS


    BEGIN

        output <= input when shiftAmount = "00000"
        else '0' & input(wordSize-1 DOWNTO 1) when shiftAmount = "00001"
        else "00" & input(wordSize-1 DOWNTO 2) when shiftAmount = "00010"
        else "000" & input(wordSize-1 DOWNTO 3) when shiftAmount = "00011"
        else "0000" & input(wordSize-1 DOWNTO 4) when shiftAmount = "00100"
        else "00000" & input(wordSize-1 DOWNTO 5) when shiftAmount = "00101"
        else "000000" & input(wordSize-1 DOWNTO 6) when shiftAmount = "00110"
        else "0000000" & input(wordSize-1 DOWNTO 7) when shiftAmount = "00111"
        else "00000000" & input(wordSize-1 DOWNTO 8) when shiftAmount = "01000"
        else "000000000" & input(wordSize-1 DOWNTO 9) when shiftAmount = "01001"
        else "0000000000" & input(wordSize-1 DOWNTO 10) when shiftAmount = "01010"
        else "00000000000" & input(wordSize-1 DOWNTO 11) when shiftAmount = "01011"
        else "000000000000" & input(wordSize-1 DOWNTO 12) when shiftAmount = "01100"
        else "0000000000000" & input(wordSize-1 DOWNTO 13) when shiftAmount = "01101"
        else "00000000000000" & input(wordSize-1 DOWNTO 14) when shiftAmount = "01110"
        else "000000000000000" & input(wordSize-1 DOWNTO 15) when shiftAmount = "01111"
        else "0000000000000000";


        carryOut <= carryIn         when shiftAmount = "00000"
            else    input(0)        when shiftAmount = "00001"
            else    input(1)        when shiftAmount = "00010"
            else    input(2)        when shiftAmount = "00011"
            else    input(3)        when shiftAmount = "00100"
            else    input(4)        when shiftAmount = "00101"
            else    input(5)        when shiftAmount = "00110"
            else    input(6)        when shiftAmount = "00111"
            else    input(7)        when shiftAmount = "01000"
            else    input(8)        when shiftAmount = "01001"
            else    input(9)        when shiftAmount = "01010"
            else    input(10)       when shiftAmount = "01011"
            else    input(11)       when shiftAmount = "01100"
            else    input(12)       when shiftAmount = "01101"
            else    input(13)       when shiftAmount = "01110"
            else    input(14)       when shiftAmount = "01111"
            else    input(15);

END architecture;
