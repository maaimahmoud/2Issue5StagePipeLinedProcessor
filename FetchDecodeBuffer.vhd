LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY FetchDecodeBuffer IS

	Generic(wordSize: integer :=16);

	PORT(
			clk, reset: IN STD_LOGIC;
			bufferEn  : IN STD_LOGIC;
			pcIn : IN STD_LOGIC_VECTOR((2*wordSize-1) DOWNTO 0);
            instruction1In, instruction2In : IN  STD_LOGIC_VECTOR(wordSize - 1 DOWNTO 0);
			pc : OUT STD_LOGIC_VECTOR((2*wordSize-1) DOWNTO 0);
            instruction1Out,instruction2Out : OUT STD_LOGIC_VECTOR(wordSize - 1 DOWNTO 0)
		);

END ENTITY FetchDecodeBuffer;

------------------------------------------------------------

ARCHITECTURE FetchDecodeBufferArch OF FetchDecodeBuffer IS

    SIGNAL pcMem : STD_LOGIC_VECTOR((2*wordSize-1) DOWNTO 0);
    SIGNAL instruction1Mem, instruction2Mem : STD_LOGIC_VECTOR(wordSize - 1 DOWNTO 0);
	

	BEGIN

		-- PROCESS(clk) IS
		-- 	BEGIN
		-- 		IF rising_edge(clk) THEN  
		-- 			IF bufferEn = '1' THEN
		-- 				instruction1 <= instruction1In;
        --                 instruction2 <= instruction2In;
        --                 pc <= pcIn;
		-- 			END IF;
		-- 		END IF;
		-- END PROCESS;


		-- pc <= pcMem;
		-- instruction1 <= instruction1Mem;
        -- instruction2 <= instruction2Mem;

		instruction1Map: ENTITY work.Reg GENERIC MAP(wordSize) PORT MAP
        (
            instruction1In, bufferEn, clk, reset, instruction1Out
        );

		instruction2Map: ENTITY work.Reg GENERIC MAP(wordSize) PORT MAP
        (
            instruction2In, bufferEn, clk, reset, instruction2Out
        );

END ARCHITECTURE;