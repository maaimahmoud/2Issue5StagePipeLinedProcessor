LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;


package Constants is

    Constant opModeSize:Integer:=2;
    Constant opCodeSize:Integer:=3;
    Constant numRegister:Integer:=3;
    --opmodes
    Constant oneOperand :STD_LOGIC_VECTOR(opModeSize-1 downto 0) :="00";
    Constant twoOperand:STD_LOGIC_VECTOR(opModeSize-1 downto 0) :="01";
    Constant memoryInstructions :STD_LOGIC_VECTOR(opModeSize-1 downto 0) :="10";
    Constant changeOFControlInstructions :STD_LOGIC_VECTOR(opModeSize-1 downto 0) :="11";
    

    -- alu operations
    CONSTANT operationSize: INTEGER := 5;
    constant opNOP: STD_LOGIC_VECTOR(operationSize-1 downto 0) := "00000" ;
    CONSTANT opSETC: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "00001";
    CONSTANT opCLRC: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "00010";
    CONSTANT opNOT: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "00011";
    CONSTANT opINC: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "00100";
    CONSTANT opDEC: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "00101";
    Constant opOUT: STD_LOGIC_VECTOR(operationSize-1 downto 0) := "00110" ;
    CONSTANT opIN: STD_LOGIC_VECTOR(operationSize-1 downto 0) := "00111" ;


    CONSTANT opMOV: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "01000";
    CONSTANT opADD: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "01001";
    CONSTANT opSUB: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "01010";
    CONSTANT opAND: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "01011";
    CONSTANT opOR: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "01100";
    CONSTANT opSHL: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "01101";
    CONSTANT opSHR: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "01110";
    

     --Memory Instructions
     CONSTANT opPUSH: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "10000";
     CONSTANT opPOP: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "10001";
     CONSTANT opLDM: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "10010";
     CONSTANT opLDD: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "10011";
     CONSTANT opSTD: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "10100";
 
 
     --Change of controls instructions
     CONSTANT opJZ: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "11000";
     CONSTANT opJN: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "11001";
     CONSTANT opJC: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "11010";
     CONSTANT opJMP: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "11011";
     CONSTANT opCALL: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "11100";
     CONSTANT opRET: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "11101";
     CONSTANT opRTI: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "11110";


    -- flags
    CONSTANT flagSize: INTEGER := 3;
    CONSTANT ZFLAG: INTEGER := 0;
    CONSTANT CFLAG: INTEGER := 1;
    CONSTANT NFLAG: INTEGER := 2;  

END package;