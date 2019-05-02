LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY ExecuteMemoryBuffer IS

	Generic(regNum: integer:=3 ; addressBits: integer := 20; wordSize: integer :=16);

	PORT(
			clk, reset : IN STD_LOGIC;
			bufferEn1, bufferEn2  : IN STD_LOGIC;
            ---------------------------------------------------------------------------

            Read1In, Read2In, Write1In,Write2In, WB1In,WB2In : IN STD_LOGIC;
            inPort1In, inPort2In : IN STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
            pcIn: IN STD_LOGIC_VECTOR( (2*wordSize)-1 DOWNTO 0);
            alu1OutIn, alu2OutIn : IN  STD_LOGIC_VECTOR(wordSize - 1 DOWNTO 0);
            Src1In, Src2In, Dst1In, Dst2In : IN STD_LOGIC_VECTOR(regNum-1 DOWNTO 0);
            Src1DataIn, Src2DataIn, Dst1DataIn, Dst2DataIn : IN STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
            mux1WBSelectorIn, mux2WBSelectorIn: IN STD_LOGIC_VECTOR(1 downto 0);
            
            incSP1In , incSP2In,
            decSP1In , decSP2In: IN STD_LOGIC;
      
            immediateValueIn: IN STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);

            ----------------------------------------------------------------------------

            Read1, Read2, Write1,Write2, WB1, WB2 : OUT STD_LOGIC;
            inPort1, inPort2 : OUT STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
            pc: OUT STD_LOGIC_VECTOR( (2*wordSize)-1 DOWNTO 0);
            alu1Out, alu2Out : OUT  STD_LOGIC_VECTOR(wordSize - 1 DOWNTO 0);
            Src1, Src2, Dst1, Dst2 : OUT STD_LOGIC_VECTOR(regNum-1 DOWNTO 0);
            Src1Data, Src2Data, Dst1Data, Dst2Data : OUT STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
            mux1WBSelector, mux2WBSelector: OUT STD_LOGIC_VECTOR(1 downto 0);
            MEM1, MEM2: OUT STD_LOGIC;

            incSP1 , incSP2,
            decSP1 , decSP2: OUT STD_LOGIC;

            immediateValue: OUT STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0)
		);

END ENTITY ExecuteMemoryBuffer;

------------------------------------------------------------

ARCHITECTURE ExecuteMemoryBufferArch OF ExecuteMemoryBuffer IS

	BEGIN

		
        read1Map: ENTITY work.DFlipFlop PORT MAP
        (
            Read1In, bufferEn1, clk, reset, Read1
        );

        write1Map: ENTITY work.DFlipFlop PORT MAP
        (
            Write1In, bufferEn1, clk, reset, Write1
        );
        
        wb1Map: ENTITY work.DFlipFlop PORT MAP
        (
            WB1In, bufferEn1, clk, reset, WB1
        );

 
        inPort1Map: ENTITY work.Reg GENERIC MAP (wordSize) PORT MAP (
            inPort1In, bufferEn1, clk, reset, inPort1
        );

        pcMap: ENTITY work.Reg GENERIC MAP ((2*wordSize)) PORT MAP (
            pcIn, bufferEn1, clk, reset, pc
        );

        alu1Map: ENTITY work.Reg GENERIC MAP (wordSize) PORT MAP (
            alu1OutIn, bufferEn1, clk, reset, alu1Out
        );

        

        src1Map: ENTITY work.Reg GENERIC MAP (regNum) PORT MAP (
            Src1In, bufferEn1, clk, reset, Src1
        );

        dst1Map: ENTITY work.Reg GENERIC MAP (regNum) PORT MAP (
            Dst1In, bufferEn1, clk, reset, Dst1
        );

        
        srcData1Map: ENTITY work.Reg GENERIC MAP (wordSize) PORT MAP (
            Src1DataIn, bufferEn1, clk, reset, Src1Data
        );

        dst1DataMap: ENTITY work.Reg GENERIC MAP (wordSize) PORT MAP (
            Dst1DataIn, bufferEn1, clk, reset, Dst1Data
        );

        mux1SelectorMap: ENTITY work.Reg GENERIC MAP (2) PORT MAP (
            mux1WBSelectorIn, bufferEn1, clk, reset, mux1WBSelector
        );

        ---------------------------------------------------------------

        
        read2Map: ENTITY work.DFlipFlop PORT MAP
        (
            Read2In, bufferEn2, clk, reset, Read2
        );

        write2Map: ENTITY work.DFlipFlop PORT MAP
        (
            Write2In, bufferEn2, clk, reset, Write2
        );
        
        wb2Map: ENTITY work.DFlipFlop PORT MAP
        (
            WB2In, bufferEn2, clk, reset, WB2
        );



        inPort2Map: ENTITY work.Reg GENERIC MAP (wordSize) PORT MAP (
            inPort2In, bufferEn2, clk, reset, inPort2
        );


        alu2Map: ENTITY work.Reg GENERIC MAP (wordSize) PORT MAP (
            alu2OutIn, bufferEn2, clk, reset, alu2Out
        );

        

        src2Map: ENTITY work.Reg GENERIC MAP (regNum) PORT MAP (
            Src2In, bufferEn2, clk, reset, Src2
        );

        dst2Map: ENTITY work.Reg GENERIC MAP (regNum) PORT MAP (
            Dst2In, bufferEn2, clk, reset, Dst2
        );

        
        srcData2Map: ENTITY work.Reg GENERIC MAP (wordSize) PORT MAP (
            Src2DataIn, bufferEn2, clk, reset, Src2Data
        );

        dst2DataMap: ENTITY work.Reg GENERIC MAP (wordSize) PORT MAP (
            Dst2DataIn, bufferEn2, clk, reset, Dst2Data
        );


        mux2SelectorMap: ENTITY work.Reg GENERIC MAP (2) PORT MAP (
            mux2WBSelectorIn, bufferEn2, clk, reset, mux2WBSelector
        );
        

        immediateValueRegMap: ENTITY work.Reg GENERIC MAP(wordSize) PORT MAP
        (
            immediateValueIn, bufferEn1, clk, reset, immediateValue
        );


        -----------------------------------------------------------------------------

        incSP1Map: ENTITY work.DFlipFlop PORT MAP
        (
            incSP1In, bufferEn1, clk, reset, incSP1
        );

        decSP1Map: ENTITY work.DFlipFlop PORT MAP
        (
            decSP1In, bufferEn1, clk, reset, decSP1
        );


        incSP2Map: ENTITY work.DFlipFlop PORT MAP
        (
            incSP2In, bufferEn2, clk, reset, incSP2
        );

        decSP2Map: ENTITY work.DFlipFlop PORT MAP
        (
            decSP2In, bufferEn2, clk, reset, decSP2
        );


        MEM1 <= Read1 OR Write1;

        MEM1 <= Read2 OR Write2;
END ARCHITECTURE;