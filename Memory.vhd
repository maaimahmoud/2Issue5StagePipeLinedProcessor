LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY Memory IS

	Generic(regNum: integer := 3; addressBits: integer := 10; wordSize: integer :=16);

	PORT(
			clk : IN STD_LOGIC;
            Read1, Read2, Write1,Write2: IN STD_LOGIC;
            alu1Out, alu2Out : IN  STD_LOGIC_VECTOR(wordSize - 1 DOWNTO 0);
            Src1Data, Src2Data: IN STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
            Dst1Data, Dst2Data : IN STD_LOGIC_VECTOR(regNum-1 DOWNTO 0);

			M0, M1, memoryOut : OUT STD_LOGIC_VECTOR(wordSize - 1 DOWNTO 0)
		);

END ENTITY Memory;

------------------------------------------------------------

ARCHITECTURE MemoryArch OF Memory IS

    SIGNAL we: STD_LOGIC;

    SIGNAL address: STD_LOGIC_VECTOR(addressBits-1 DOWNTO 0);
    SIGNAL data: STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
	
	BEGIN

        address <= Src1Data WHEN Read1 = '1'
        ELSE Src2Data WHEN Read2 = '1'
        ELSE Dst1Data WHEN Write1 = '1'
        ELSE Dst2Data;


        data <= Src1Data WHEN Read1 = '1'
        ELSE Src2Data;

        we <= Write1 OR Write2;


        dataMemoryMap: ENTITY work.DataMemory GENERIC MAP(addressBits, wordSize) PORT MAP(
                                                                                            clk => clk ,
                                                                                            we  => we ,
                                                                                            address => address,
                                                                                            datain => data,
                                                                                            M0 =>  M0,
                                                                                            M1 =>  M1,
                                                                                            dataout => memoryOut
                                                                                        );


END ARCHITECTURE;