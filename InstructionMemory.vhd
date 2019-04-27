LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY InstructionMemory IS

	Generic(addressBits: integer := 20; wordSize: integer :=16);

	PORT(
			clk : IN STD_LOGIC;
			we  : IN STD_LOGIC;
			address: IN  STD_LOGIC_VECTOR(addressBits - 1 DOWNTO 0);
			datain  : IN  STD_LOGIC_VECTOR(wordSize - 1 DOWNTO 0);
			dataOut1,dataOut2 : OUT STD_LOGIC_VECTOR(wordSize - 1 DOWNTO 0)
		);

END ENTITY InstructionMemory;

------------------------------------------------------------

ARCHITECTURE InstructionMemoryArch OF InstructionMemory IS

	TYPE RamType IS ARRAY(0 TO (2**addressBits) - 1) OF STD_LOGIC_VECTOR(wordSize - 1 DOWNTO 0);
	
	SIGNAL Ram : RamType ;
	
	BEGIN

		PROCESS(clk) IS
			BEGIN
				IF rising_edge(clk) THEN  
					IF we = '1' THEN
						Ram(TO_INTEGER(UNSIGNED(address))) <= datain;
					END IF;
				END IF;
		END PROCESS;

		dataout1 <= Ram(TO_INTEGER(UNSIGNED(address)));
        dataout2 <= Ram(TO_INTEGER(UNSIGNED(address)+1));
		

END ARCHITECTURE;