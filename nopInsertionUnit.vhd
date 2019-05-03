LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.math_real.all;
LIBRARY work;

USE work.Constants.all;
----------------------------------------------------------------------------------------------------------
-----this unit is responsible for detecting hazards between the instructions in the two pipes
-----it takes as input the opcodes of the instructions in the two pipes and the registers in two pipes
-----this unit outputs 1 if NOP have to be inserted (The NOP will be inserted in the 2nd pipe and pc will be incremented by one)
-----cases that will lead to stalling one pipe :
-----1-if the Rdst of the instruction in the first pipe  will be the Rsrc of the instruction in 2nd pipe 
-----2-if the Rdst of the instruction in the first pipe will be the the Rdst in the 2nd pipe and the instruction in the 2nd pipe will be using that new value
-----3-If the 1st operation ALU operation and 2nd operation is branch operation
-----4-if the first pipe is LDD instruction and 2nd pipe is an instruction that uses the Rdst of 1st pipe
-----6-if the instruction in the 1st pipe is IN and instruction in 2nd pipe uses this register (note we will insert NOP once then forwarding will be used)
-----7-if the instructions in 1st  and 2nd pipe are memory instructions
-----8-if the instruction in 2nd pipe is LDM 
-----9-if the instruction in the 1st pipe is RET or RTI
-----10-if the two instructions are OUT 
-----11-if the two instructions are IN 
----------------------------------------------------------------------------------------------------------
Entity NOPInsertionUnit is 

port(
        Rdst1,Rsrc2,Rdst2:in std_logic_vector(numRegister-1 downto 0) ;
      --  instructionType1,instructionType2 :in std_logic_vector(opModeSize-1 downto 0) ;
        instruction1OpCode,instruction2OpCode:in std_logic_vector(operationSize-1 downto 0) ;
        insertNOP:out std_logic
);
end entity NOPInsertionUnit;

------------------------------------------------------------------

architecture NOPInsertionUnitArch of NOPInsertionUnit is 

    signal instructionType1,instructionType2 : std_logic_vector(opModeSize-1 downto 0);

begin
  instructionType1<=instruction1OpCode(operationSize-1 downto opCodeSize);
  instructionType2<=instruction2OpCode(operationSize-1 downto opCodeSize);
  
  --checks if the two instructions in the two pipes will use the same registers
  insertNOP <='1' when ((instructionType1=oneOperand and instructionType2=oneOperand)and (Rdst1=Rdst2 and instruction1OpCode/=opNOP and instruction2OpCode/=opNOP and instruction1OpCode/=opSETC and instruction2OpCode/=opSETC and instruction1OpCode/=opCLRC and instruction2OpCode/=opCLRC and instruction2OpCode/=opIN and instruction1OpCode/=opOUT and instruction2OpCode/=opOUT))
  or ((instructionType1=oneOperand and instructionType2=twoOperand)and ((Rdst1=Rdst2 or Rdst1=Rsrc2)and (instruction1OpCode/=opNOP and instruction1OpCode/=opSETC and instruction1OpCode/=opCLRC and instruction1OpCode/=opOUT and not(instruction2OpCode=opMOV and Rdst1=Rsrc2))))
  or ((instructionType1=twoOperand and instructionType2=oneOperand)and(Rdst1=Rdst2 and (instruction2OpCode/=opNOP and instruction2OpCode/=opSETC and instruction2OpCode/=opCLRC)))
  or ((instructionType1=twoOperand and instructionType2=twoOperand)and ((Rdst1=Rdst2 or Rdst1=Rsrc2) and not(instruction2OpCode=opMOV and Rsrc2=Rdst1)))
  
  
  --When((Rdst1=Rsrc2) and instructionType2=twoOperand and instruction1OpCode/=opNOP)or
 -- ((Rdst1=Rdst2)and (instructionType2=oneOperand and instruction1OpCode/=opNOP and instruction1OpCode/=opSETC and instruction1OpCode/=opCLRC  and instruction1OpCode/=opIN )
  --  and (instructionType2=twoOperand and instruction2OpCode/=opMOV)
  --)
 
--check if the 1st instruction will change the carry flags and the 2nd instruction will use the flags to branch 
or((instructionType1=twoOperand or
((instructionType1=oneOperand and instruction1OpCode/=opOUT and instruction1OpCode/=opIN and instruction1OpCode/=opNOP)
 ))
and (instructionType2=changeOFControlInstructions and (instruction2OpCode=opJZ or instruction2OpCode=opJN or instruction2OpCode=opJC)))


--check if the 1st instruction is LDD instruction and the 2nd pipe uses that registe(load use case)
or(instruction1OpCode=opLDD and  ((instructionType2=oneOperand and Rdst1=Rdst2) or(instructionType2=twoOperand and (Rdst1=Rsrc2 or Rdst1=Rdst2)) ) )

--check if the instruction in the 1st pipe is IN and instruction in 2nd pipe uses that register
or( instruction1OpCode=opIN and ((instructionType2=oneOperand and Rdst1=Rdst2) or(instructionType2=twoOperand and (Rdst1=Rsrc2 or Rdst1=Rdst2))))
--check if 1st instruction and 2nd instruction are memory instructions
or(instructionType1=memoryInstructions and instructionType2=memoryInstructions)

or (instruction2OpCode=opLDM and instruction1OpCode/=opLDM)

or (instruction2OpCode=opRET or instruction2OpCode=opRTI or instruction2OpCode=opCALL)

or(instruction1OpCode=opOUT and instruction2OpCode=opOut)

or(instruction1OpCode=opIN and instruction2OpCode=opIN)
else '0';


end architecture   ; 
