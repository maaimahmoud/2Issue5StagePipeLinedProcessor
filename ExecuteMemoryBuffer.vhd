LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY ExecuteMemoryBuffer IS

	Generic(regNum: integer:=3 ; addressBits: integer := 20; wordSize: integer :=16);

	PORT(
			clk : IN STD_LOGIC;
			bufferEn1, bufferEn2  : IN STD_LOGIC;
            Read1In, Read2In, Write1In,Write2In, WB1In,WB2In : IN STD_LOGIC;
            inPort1In, inPort2In : IN STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
            pcIn: IN STD_LOGIC_VECTOR( (2*wordSize)-1 DOWNTO 0);
            alu1OutIn, alu2OutIn : IN  STD_LOGIC_VECTOR(wordSize - 1 DOWNTO 0);
            Src1In, Src2In, Dst1In, Dst2In : IN STD_LOGIC_VECTOR(regNum-1 DOWNTO 0);
            Src1DataIn, Src2DataIn, Dst1DataIn, Dst2DataIn : IN STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
            mux1WBSelectorIn, mux2WBSelectorIn: IN STD_LOGIC_VECTOR(1 downto 0);

            Read1, Read2, Write1,Write2, WB1, WB2 : OUT STD_LOGIC;
            inPort1, inPort2 : OUT STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
            pc: OUT STD_LOGIC_VECTOR( (2*wordSize)-1 DOWNTO 0);
            alu1Out, alu2Out : OUT  STD_LOGIC_VECTOR(wordSize - 1 DOWNTO 0);
            Src1, Src2, Dst1, Dst2 : OUT STD_LOGIC_VECTOR(regNum-1 DOWNTO 0);
            Src1Data, Src2Data, Dst1Data, Dst2Data : OUT STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
            mux1WBSelector, mux2WBSelector: OUT STD_LOGIC_VECTOR(1 downto 0)
		);

END ENTITY ExecuteMemoryBuffer;

------------------------------------------------------------

ARCHITECTURE ExecuteMemoryBufferArch OF ExecuteMemoryBuffer IS

    SIGNAL Read1Mem, Read2Mem, Write1Mem,Write2Mem, WB1Mem, WB2Mem : STD_LOGIC;
    SIGNAL inPort1Mem, inPort2Mem : STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
    SIGNAL pcMem: STD_LOGIC_VECTOR( (2*wordSize)-1 DOWNTO 0);
    SIGNAL alu1OutMem, alu2OutMem : STD_LOGIC_VECTOR(wordSize - 1 DOWNTO 0);
    SIGNAL Src1Mem, Src2Mem, Dst1Mem, Dst2Mem : STD_LOGIC_VECTOR(regNum-1 DOWNTO 0);
    SIGNAL Src1DataMem, Src2DataMem, Dst1DataMem, Dst2DataMem : STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
    SIGNAL mux1WBSelectorMem, mux2WBSelectorMem: STD_LOGIC_VECTOR(1 downto 0);

	BEGIN

		PROCESS(clk) IS
			BEGIN
				IF rising_edge(clk) THEN  
					IF bufferEn1 = '1' THEN
						pcMem <= pcIn;
                        alu1OutMem <= alu1OutIn;
                        Read1Mem <= Read1In;
                        Write1Mem <= Write1In;

                        Src1Mem <= Src1In;
                        Dst1Mem <= Dst1In;
                        Src1DataMem <= Src1DataIn;
                        Dst1DataMem <= Dst1DataIn;

                        WB1Mem <= WB1In;
                        inPort1Mem <= inPort1In; 
                        mux1WBSelectorMem <= mux1WBSelectorIn; 
                       
                    END IF;  
                    IF bufferEn2 = '1' THEN
                        alu2OutMem <= alu2OutIn;
                        Src2Mem <= Src2In;
                        Dst2Mem <= Dst2In;
                        Src2DataMem <= Src2DataIn;
                        Dst2DataMem <= Dst2DataIn;
        
                        Read2Mem <= Read2In;
                        Write2Mem <= Write2In;

                        WB2Mem <= WB2In;

                        inPort2Mem <= inPort2In;
                        
                        mux2WBSelectorMem <= mux2WBSelectorIn;

					END IF;
				END IF;
		END PROCESS;

        pc <= pcMem;

        alu1Out <= alu1OutMem;
        Src1 <= Src1Mem;
        Dst1 <= Dst1Mem;
        Src1Data <= Src1DataMem;
        Dst1Data <= Dst1DataMem;
        Read1 <= Read1Mem;
        Write1 <= Write1Mem;
        WB1 <= WB1Mem;
        inPort1 <= inPort1Mem; 
        mux1WBSelector <= mux1WBSelectorMem;


        Src2 <= Src2Mem;
        Dst2 <= Dst2Mem;
        Src2Data <= Src2DataMem; 
        Dst2Data <= Dst2DataMem;
        
        Read2 <= Read2Mem;
        alu2Out <= alu2OutMem;
        Write2 <= Write2Mem;
        WB2 <= WB2Mem;

        inPort2 <= inPort2Mem;
        mux2WBSelector <= mux2WBSelectorMem; 
        
END ARCHITECTURE;