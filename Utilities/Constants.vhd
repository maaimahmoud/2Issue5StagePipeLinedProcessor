LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;


package Constants is

    Constant opModeSize:Integer:=2;
    Constant numRegister:Integer:=3;
    --opmodes
    Constant oneOperand :std_logic_vector(opModeSize-1 downto 0) :="00";
    Constant twoOperand:std_logic_vector(opModeSize-1 downto 0) :="01";
    Constant memoryInstructions :std_logic_vector(opModeSize-1 downto 0) :="10";
    Constant changeOFControlInstructions :std_logic_vector(opModeSize-1 downto 0) :="11";
    
    
    -- alu operations
    CONSTANT operationSize: INTEGER := 4;
    CONSTANT opSETC: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "0000";
    CONSTANT opCLRC: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "0001";
    CONSTANT opNOT: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "0010";
    CONSTANT opINC: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "0011";
    CONSTANT opDEC: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "0100";
    CONSTANT opMOV: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "0101";
    CONSTANT opADD: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "0110";
    CONSTANT opSUB: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "0111";
    CONSTANT opAND: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "1000";
    CONSTANT opOR: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "1001";
    CONSTANT opSHL: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "1010";
    CONSTANT opSHR: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "1011";
    CONSTANT opIN:std_logic_vector(operationSize-1 downto 0):="1100" ;
    



     --Memory Instructions
     CONSTANT opPUSH: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "0000";
     CONSTANT opPOP: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "0001";
     CONSTANT opLDM: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "0010";
     CONSTANT opLDD: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "0011";
     CONSTANT opSTD: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "0100";
 
 
     --Change of controls instructions
     CONSTANT opJZ: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "0000";
     CONSTANT opJN: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "0001";
     CONSTANT opJC: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "0010";
     CONSTANT opJMP: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "0011";
     CONSTANT opCALL: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "0100";
     CONSTANT opRET: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "0101";
     CONSTANT opRTI: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0) := "0110";


    -- flags
    CONSTANT flagSize: INTEGER := 3;
    CONSTANT ZFLAG: INTEGER := 0;
    CONSTANT CFLAG: INTEGER := 1;
    CONSTANT NFLAG: INTEGER := 2;  

end package;