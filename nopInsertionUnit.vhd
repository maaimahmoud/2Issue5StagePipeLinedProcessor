LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.math_real.all;
LIBRARY work;

USE work.Constants.all;
----------------------------------------------------------------------------------------------------------
-----this unit is responsible for detecting hazards between the instructions in the two pipes
-----it takes as input the opcodes of the instructions in the two pipes and the registers in two pipes
-----this unit outputs 1 if NOP will be inserted
-----cases that will lead to stalling one pipe :
-----1-if the Rdst of the instruction in the first pipe is the same as the destination register or source register in 2nd  pipe
-----2-If the 1st operation ALU operation and 2nd operation is branch operation
-----3-if the first pipe is LDD instruction and 2nd pipe is an instruction that uses the Rdst of 1st pipe
-----4-if the instruction in the 1st pipe is unconditional branch  
-----5-if the instruction in the 1st pipe is LDM and 2nd pipe and the instruction in the 2nd pipe depends on that destination register
-----6-if the instruction in the 1st pipe is IN and instruction in 2nd pipe uses this register (note we will insert NOP once then forwarding will be used)
----------------------------------------------------------------------------------------------------------
Entity NOPInsertionUnit is 

port(
        Rdst1,Rsrc2,Rdst2:in std_logic_vector(numRegister-1 downto 0) ;
        instructionType1,instructionType2 :in std_logic_vector(opModeSize-1 downto 0) ;
        instruction1OpCode,instruction2OpCode:in std_logic_vector(operationSize-1 downto 0) ;
        insertNOP:out std_logic
);
end entity NOPInsertionUnit;

architecture NOPInsertionUnitArch of NOPInsertionUnit is 

begin
insertNOP <='1' When (Rdst1=Rsrc2 or Rdst1=Rdst2) or 

--check if the 1st instruction will change the carry flags and the 2nd instruction will use the flags to branch
((instructionType1=twoOperand or
((instructionType1=oneOperand and instruction1OpCode/=opOUT and instruction1OpCode/=opIN and instruction1OpCode/=opNOP)
 ))
and (instructionType2=changeOFControlInstructions and (instruction2OpCode=opJZ or instruction2OpCode=opJN or instruction2OpCode=opJC)))
--check if the 1st instruction is LDD instruction and the 2nd pipe uses that registe(load use case)
or(instructionType1=memoryInstructions and instruction1OpCode=opLDD and (Rdst1=Rsrc2 or Rdst1=Rdst2))

--check if the instruction in the 1st pipe is unconditional branch
or(instructionType1=changeOFControlInstructions and(instruction2OpCode/=opJZ and instruction2OpCode/=opJN and instruction2OpCode/=opJC))

--check if the instruction in 1st pipe in LDM and instruction in 2nd pipe depends on it
or(instructionType1=memoryInstructions and instruction1OpCode=opLDM and (Rdst1=Rsrc2 or Rdst1=Rdst2))

--check if the instruction in the 1st pipe is IN and instruction in 2nd pipe uses that register
or(instructionType1=oneOperand and instruction1OpCode=opIN and (Rdst1=Rsrc2 or Rdst1=Rdst2))
else '0';

end architecture   ; 