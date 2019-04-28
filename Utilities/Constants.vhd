LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;


package Constants is

    Constant opModeSize:Integer:=2;
    Constant numRegister:Integer:=3;
    --opmodes
    Constant oneOperand :STD_LOGIC_VECTOR(opModeSize-1 downto 0) :="00";
    Constant twoOperand:STD_LOGIC_VECTOR(opModeSize-1 downto 0) :="01";
    Constant memoryInstructions :STD_LOGIC_VECTOR(opModeSize-1 downto 0) :="10";
    Constant changeOFControlInstructions :STD_LOGIC_VECTOR(opModeSize-1 downto 0) :="11";
    
    
    -- alu operations
    CONSTANT operationSize: INTEGER := 6;
    constant opNOP: STD_LOGIC_VECTOR(operationSize-1 downto 0) := "000000" ;
    CONSTANT opSETC: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "000001";
    CONSTANT opCLRC: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "000010";
    CONSTANT opNOT: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "000100";
    CONSTANT opINC: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "000101";
    CONSTANT opDEC: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "000110";
    Constant opOUT: STD_LOGIC_VECTOR(operationSize-1 downto 0) := "001000" ;
    CONSTANT opIN: STD_LOGIC_VECTOR(operationSize-1 downto 0) := "001001" ;


    CONSTANT opMOV: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "010000";
    CONSTANT opADD: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "010001";
    CONSTANT opSUB: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "010010";
    CONSTANT opAND: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "010011";
    CONSTANT opOR: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "010100";
    CONSTANT opSHL: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "010101";
    CONSTANT opSHR: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "010110";
    

     --Memory Instructions
     CONSTANT opPUSH: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "100000";
     CONSTANT opPOP: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "100001";
     CONSTANT opLDM: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "100100";
     CONSTANT opLDD: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "101000";
     CONSTANT opSTD: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "101001";
 
 
     --Change of controls instructions
     CONSTANT opJZ: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "110000";
     CONSTANT opJN: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "110001";
     CONSTANT opJC: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "110010";
     CONSTANT opJMP: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "110100";
     CONSTANT opCALL: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "111001";
     CONSTANT opRET: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "111100";
     CONSTANT opRTI: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "111101";


    -- flags
    CONSTANT flagSize: INTEGER := 3;
    CONSTANT ZFLAG: INTEGER := 0;
    CONSTANT CFLAG: INTEGER := 1;
    CONSTANT NFLAG: INTEGER := 2;  

END package;