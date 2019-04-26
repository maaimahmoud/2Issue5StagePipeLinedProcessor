LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY Ram IS

	Generic(addressBits: integer := 5; wordSize: integer :=32);

	PORT(
			clk : IN STD_LOGIC;
			we  : IN STD_LOGIC;
			address : IN  STD_LOGIC_VECTOR(addressBits - 1 DOWNTO 0);
			datain  : IN  STD_LOGIC_VECTOR(wordSize - 1 DOWNTO 0);
			dataout : OUT STD_LOGIC_VECTOR(wordSize - 1 DOWNTO 0)
		);

END ENTITY Ram;

------------------------------------------------------------

ARCHITECTURE RamArch OF Ram IS

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

		dataout <= Ram(TO_INTEGER(UNSIGNED(address)));
		
END ARCHITECTURE;