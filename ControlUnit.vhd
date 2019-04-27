LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.math_real.all;
LIBRARY work;

USE work.Constants.all;

Entity ControlUnit IS 

    PORT(
    opMode: IN std_logic_vector(opModeSize-1 DOWNTO 0) ;
    opCode:IN std_logic_vector(OperationSize-1 downto 0) ;
    Execute :OUT std_logic;
    readFromMemory:OUT std_logic;
    writeToMemory:OUT std_logic;
    WB:OUT std_logic;
    Branch:OUT std_logic
    );  
END Entity ControlUnit;

architecture ControlUnitArch of ControlUnit is 
begin

    --Execute =1 at all 2 operands operations
    --(opCode=opMOV OR opCode=opADD or opCode=opSUB or opCode=opAND or opCode=opOR OR opCode=opSHL or opCode=opSHR)AND
    Execute <='1' when ((opCode=opNOT OR opCode=opINC OR opCode=opDEC or opCode=opSETC or opCode=opCLRC)AND opMode=oneOperand)
    OR ( opMode=twoOperand)
    OR(opMode=memoryInstructions AND(opcode=opPUSH or opCode=opPOP)) 
    else '0';
    
    readFromMemory <='1' when(opMode=memoryInstructions AND(opCode=opLDM or opCode=opLDD or opCode=opPop ))
    else '0';
    
    writeToMemory <='1' when (opMode=memoryInstructions AND (opCode=opSTD OR opCode=opPUSH))
    else '0';
    
    --i will wb all the 2 operand instructions 
    WB <='1' when (opMode=memoryInstructions AND opcode=opSTD)OR(opMode=twoOperand) 
    else '0';
    
    Branch<='1' when (opMode=changeOFControlInstructions AND (opcode=opJZ or opcode=opJN or opcode=opJC or opcode=opJMP))
    else '0';
end architecture ;   