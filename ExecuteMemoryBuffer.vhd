LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY ExecuteMemoryBuffer IS

	Generic(regNum: integer:=3 ; addressBits: integer := 2; wordSize: integer :=32);

	PORT(
			clk : IN STD_LOGIC;
			bufferEn  : IN STD_LOGIC;
            Read1In, Read2In, Write1In,Write2In : IN STD_LOGIC;
			pcIn, alu1OutIn, alu2OutIn : IN  STD_LOGIC_VECTOR(wordSize - 1 DOWNTO 0);
            Src1DataIn, Src2DataIn  : IN STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
            Dst1DataIn, Dst2DataIn : IN STD_LOGIC_VECTOR(regNum-1 DOWNTO 0);

            Read1, Read2, Write1,Write2 : OUT STD_LOGIC;
            pc, alu1Out, alu2Out : OUT  STD_LOGIC_VECTOR(wordSize - 1 DOWNTO 0);
            Src1Data, Src2Data: OUT STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
            Dst1Data, Dst2Data : OUT STD_LOGIC_VECTOR(regNum-1 DOWNTO 0)
		);

END ENTITY ExecuteMemoryBuffer;

------------------------------------------------------------

ARCHITECTURE ExecuteMemoryBufferArch OF ExecuteMemoryBuffer IS

    SIGNAL Read1Mem, Read2Mem, Write1Mem,Write2Mem : STD_LOGIC;
    SIGNAL pcMem, alu1OutMem, alu2OutMem : STD_LOGIC_VECTOR(wordSize - 1 DOWNTO 0);
    SIGNAL Src1DataMem, Src2DataMem, Dst1Mem, Dst2Mem : STD_LOGIC_VECTOR(regNum-1 DOWNTO 0);

	BEGIN

		PROCESS(clk) IS
			BEGIN
				IF rising_edge(clk) THEN  
					IF bufferEn = '1' THEN
						pcMem <= pcIn;
                        alu1OutMem <= alu1OutIn;
                        alu2OutMem <= alu2OutIn;
                        Src1DataMem <= Src1DataIn;
                        Dst1Mem <= Dst1DataIn;
                        Src2DataMem <= Src2DataIn;
                        Dst2Mem <= Dst2DataIn;
                        
                        Read1Mem <= Read1In;
                        Read2Mem <= Read2In;
                        Write1Mem <= Write1In;
                        Write2Mem <= Write2In;
					END IF;
				END IF;
		END PROCESS;

        pc <= pcMem;
        alu1Out <= alu1OutMem;
        alu2Out <= alu2OutMem;
        Src1Data <= Src1DataMem;
        Dst1Data <= Dst1Mem;
        Src2Data <= Src2DataMem;
        Dst2Data <= Dst2Mem;

        Read1 <= Read1Mem;
        Read2 <= Read2Mem;
        Write1 <= Write1Mem;
        Write2 <= Write2Mem;
        
END ARCHITECTURE;