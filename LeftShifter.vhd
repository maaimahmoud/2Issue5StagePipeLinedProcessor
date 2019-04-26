LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

-- Left Shifter Entity

ENTITY LeftShifter IS
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

END LeftShifter;

------------------------------------------------------------

-- Left Shifter Architecture

ARCHITECTURE LeftShifterArch OF LeftShifter IS


    BEGIN

        output <= input when shiftAmount = "00000"
        else input(wordSize-2 DOWNTO 0) & '0' when shiftAmount = "00001"
        else input(wordSize-3 DOWNTO 0) & "00" when shiftAmount = "00010"
        else input(wordSize-4 DOWNTO 0) & "000" when shiftAmount = "00011"
        else input(wordSize-5 DOWNTO 0) & "0000" when shiftAmount = "00100"
        else input(wordSize-6 DOWNTO 0) & "00000" when shiftAmount = "00101"
        else input(wordSize-7 DOWNTO 0) & "000000" when shiftAmount = "00110"
        else input(wordSize-8 DOWNTO 0) & "0000000" when shiftAmount = "00111"
        else input(wordSize-9 DOWNTO 0) & "00000000" when shiftAmount = "01000"
        else input(wordSize-10 DOWNTO 0) & "000000000" when shiftAmount = "01001"
        else input(wordSize-11 DOWNTO 0) & "0000000000" when shiftAmount = "01010"
        else input(wordSize-12 DOWNTO 0) & "00000000000" when shiftAmount = "01011"
        else input(wordSize-13 DOWNTO 0) & "000000000000" when shiftAmount = "01100"
        else input(wordSize-14 DOWNTO 0) & "0000000000000" when shiftAmount = "01101"
        else input(wordSize-15 DOWNTO 0) & "00000000000000" when shiftAmount = "01110"
        else input(wordSize-16 DOWNTO 0) & "000000000000000" when shiftAmount = "01111"
        else "0000000000000000";


        carryOut <= carryIn                 when shiftAmount = "00000"
            else    input(wordSize-1)       when shiftAmount = "00001"
            else    input(wordSize-2)       when shiftAmount = "00010"
            else    input(wordSize-3)       when shiftAmount = "00011"
            else    input(wordSize-4)       when shiftAmount = "00100"
            else    input(wordSize-5)       when shiftAmount = "00101"
            else    input(wordSize-6)       when shiftAmount = "00110"
            else    input(wordSize-7)       when shiftAmount = "00111"
            else    input(wordSize-8)       when shiftAmount = "01000"
            else    input(wordSize-9)       when shiftAmount = "01001"
            else    input(wordSize-10)      when shiftAmount = "01010"
            else    input(wordSize-11)      when shiftAmount = "01011"
            else    input(wordSize-12)      when shiftAmount = "01100"
            else    input(wordSize-13)      when shiftAmount = "01101"
            else    input(wordSize-14)      when shiftAmount = "01110"
            else    input(wordSize-15)      when shiftAmount = "01111"
            else    input(wordSize-16);

END architecture;
