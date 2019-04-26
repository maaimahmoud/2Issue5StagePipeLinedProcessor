LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;


package Constants is

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


    -- flags
    CONSTANT flagSize: INTEGER := 3;
    CONSTANT ZFLAG: INTEGER := 0;
    CONSTANT CFLAG: INTEGER := 1;
    CONSTANT NFLAG: INTEGER := 2;    

end package;