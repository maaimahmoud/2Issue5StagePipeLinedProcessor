LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.math_real.all;
LIBRARY work;

USE work.Constants.all;

Entity OnePipeControlUnit IS 
    PORT(
    opCode:IN std_logic_vector(operationSize-1 downto 0) ;
    STALL:IN std_logic;
    Execute :OUT std_logic;
    readFromMemory:OUT std_logic;
    writeToMemory:OUT std_logic;
    WB:OUT std_logic;
    Branch:OUT std_logic;
    incSP:OUT std_logic;
    decSP:OUT std_logic;
    wbMuxSelector:OUT std_logic_vector(1 downto 0)
    );  
END Entity OnePipeControlUnit;

architecture OnePipeControlUnitArch of OnePipeControlUnit is 
signal opMode :std_logic_vector(opModeSize-1 downto 0)  ;
begin

    --Execute =1 at all 2 operands operations
    --(opCode=opMOV OR opCode=opADD or opCode=opSUB or opCode=opAND or opCode=opOR OR opCode=opSHL or opCode=opSHR)AND
    opMode<=opCode(operationSize-1 downto opCodeSize);
    Execute <='1' when (((opCode=opNOT OR opCode=opINC OR opCode=opDEC or opCode=opSETC or opCode=opCLRC)
    AND opMode=oneOperand)
    OR ( opMode=twoOperand) or (opCode = opJZ) or (opCode = opJN) or (opCode = opJC) )and stall='0'
    --OR(opMode=memoryInstructions AND(opcode=opPUSH or opCode=opPOP)) 
    else '0';
    
    readFromMemory <='1' when(opMode=memoryInstructions AND(opCode=opLDD or opCode=opPop )) 
    and stall='0'
    else '0';
    
    writeToMemory <='1' when (opMode=memoryInstructions 
    AND (opCode=opSTD OR opCode=opPUSH))
    and stall='0'
    else '0';
    
    --i will wb all the 2 operand instructions 
    WB <='1' when ((opcode=opLDD or opcode=opPop or opCode=opLDM or opCode=opLDD )
    OR(opMode=twoOperand)Or(opcode=opINC or opcode=opDEC or opCode=opNOT or opCode=opIN)) 
    and stall='0'
    else '0';
    
    Branch<='1' when (opMode=changeOFControlInstructions and stall='0') --AND (opcode=opJZ or opcode=opJN or opcode=opJC or opcode=opJMP or opCode=opCall))
    else '0';

    --enableOut<='1' WHEN opcode=opOUT
    --else '0';
    incSP<='1' when opCode=opPOP --or opCode=opRET or opCode=opRTI
    else '0';
    decSP<='1' when opCode=opPUSH --or opCode=opCALL 
    else '0';
    --loadImmediate<='1' when opCode=opLDM
    --else '0';
    --this selector will be 00 at ALU operation or 01 at load instruction or 10 at in instruction
    --11 means don't select(No WB in this instruction)
    wbMuxSelector<="00" when (Execute='1' and opCode/=opNOP and opCode/=opSETC and opcode/=opCLRC ) 
    else "01" when readFromMemory='1'
    else "10" when opCode=opIN
    else "11" when opCode=opLDM;

   



end architecture ;   