LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
USE IEEE.math_real.all;

ENTITY MotherBoard IS

	Generic(regNum: integer := 3; addressBits: integer := 10; wordSize: integer :=16; pcInputsNum: integer := 6);

	PORT(
            clk, reset : IN STD_LOGIC;

            inPort : IN STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
            
            outPort : OUT STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0)
		);

END ENTITY MotherBoard;

------------------------------------------------------------

ARCHITECTURE MotherBoardArch OF MotherBoard IS

    -- General Parameters
        SIGNAL M0, M1 : STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);

    -- Fetch Parameters
        SIGNAL pcEn: STD_LOGIC;
        SIGNAL pcSrcSelector: STD_LOGIC_VECTOR( integer(ceil(log2(real(pcInputsNum))))-1 DOWNTO 0);
        SIGNAL pcFetchOut: STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
        SIGNAL fetchInstruction1, fetchInstruction2: STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);

    -- Fetch/Decode Buffer
        SIGNAL fetchDecodeBufferEn: STD_LOGIC;
        SIGNAL pcFetDecodeBufOut: STD_LOGIC_VECTOR((2*wordSize)-1 DOWNTO 0);
        SIGNAL instruction1FetDecodeBufOut, instruction2FetDecodeBufOut: STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);


    -- Decode Parameters
       


    -- Decode/Execute Parameters


    -- Execute Parameters


    -- Execute/Memory Parameters
        SIGNAL ExecuteMemoryBufferEn: STD_LOGIC;
        SIGNAL Read1ExMemBufOut , Read2ExMemBufOut , Write1ExMemBufOut ,Write2ExMemBufOut : STD_LOGIC;
        SIGNAL pcExMemBufOut, alu1ExMemBufOut, alu2ExMemBufOut :STD_LOGIC_VECTOR(wordSize - 1 DOWNTO 0);
        SIGNAL Src1DataExMemBufOut, Src2DataExMemBufOut : STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
        SIGNAL Dst1DataExMemBufOut, Dst2DataExMemBufOut : STD_LOGIC_VECTOR(regNum-1 DOWNTO 0);

    -- Memory Parameters
        

    -- Memory/WriteBack Parameters

    
    -- WriteBack Parameters

	
	BEGIN
    
    -- ###########################################################################################
    -- Fetch Stage
        fetchMap: ENTITY work.Fetch GENERIC MAP (wordSize, pcInputsNum) PORT MAP (
            clk => clk , reset => reset,
            pcEn => pcEn,
            pcSrcSelector => pcSrcSelector,

            -- stackOutput => , branchAddress => , : IN STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);

            M0 => M0 , M1 => M1 ,

            dataOut1 =>fetchInstruction1 , dataOut2 =>fetchInstruction2  ,
            
            pc => pcFetchOut
        );
    -- ###########################################################################################
    -- Fetch/Decode Buffer
        FetchDecodeBufferMap: ENTITY work.FetchDecodeBuffer GENERIC MAP (wordSize) PORT MAP (
            clk => clk,
			bufferEn  => fetchDecodeBufferEn,
			pcIn => pcFetchOut,
            instruction1In =>fetchInstruction1 , instruction2In => fetchInstruction2,
			pc => pcFetDecodeBufOut,
            instruction1 => instruction1FetDecodeBufOut ,instruction2 => instruction2FetDecodeBufOut
        );
    -- ###########################################################################################
    -- Decode Stage
        DecodeMap: ENTITY work.Decode GENERIC MAP( regNum, wordSize ) PORT MAP (
            clk => clk , reset => reset,

            pc => pcFetDecodeBufOut,

            instruction1 => instruction1FetDecodeBufOut, instruction2 => instruction2FetDecodeBufOut,
            
            writeReg1 => , writeReg2 =>  , --: IN STD_LOGIC_VECTOR((2**regNum)-1 DOWNTO 0);

            writeData1 => , writeData2 => , --: IN STD_LOGIC_VECTOR(wordSize-1  DOWNTO 0);

            outPort => outPort,

            src1Data => , dst1Data => , src2Data => , dst2Data => -- : OUT STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0)
        );

    -- ###########################################################################################
    --Decode/execute buffer

    -- ###########################################################################################
    -- Execute Stage

    -- ###########################################################################################
    -- Execute/Memory Buffer
        ExecuteMemoryBufferMap: ENTITY work.ExecuteMemoryBuffer GENERIC MAP (regNum, addressBits, wordSize) PORT MAP(
			clk => clk,
			bufferEn => ExecuteMemoryBufferEn,
            -- inputs from Execute Stage
            -- Read1In => , Read2In => , Write1In => ,Write2In =>  --: IN STD_LOGIC;
			-- pcIn => , alu1OutIn => , alu2OutIn => ,--: IN  STD_LOGIC_VECTOR(wordSize - 1 DOWNTO 0);
            -- Src1DataIn => , Src2DataIn => ,  --: IN STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
            -- Dst1DataIn => , Dst2DataIn =>  ,--: IN STD_LOGIC_VECTOR(regNum-1 DOWNTO 0);
              
            -- outputs to Memory Stage
            Read1 =>Read1ExMemBufOut , Read2 => Read2ExMemBufOut , Write1 =>Write1ExMemBufOut ,Write2 =>Write2ExMemBufOut ,
            pc => pcExMemBufOut , alu1Out => alu1ExMemBufOut , alu2Out => alu2ExMemBufOut,
            Src1Data => Src1DataExMemBufOut, Src2Data => Src2DataExMemBufOut,
            Dst1Data => Dst1DataExMemBufOut, Dst2Data => Dst2DataExMemBufOut 
        );
    -- ###########################################################################################
    --Memory Stage
        MemoryMap: ENTITY work.Memory GENERIC MAP ( regNum, addressBits, wordSize  ) PORT MAP(
            clk => clk,
            Read1 =>Read1ExMemBufOut , Read2 =>Read2ExMemBufOut , Write1 =>Write1ExMemBufOut ,Write2 => Write2ExMemBufOut,
            pc => pcExMemBufOut , alu1Out => alu1ExMemBufOut , alu2Out => alu2ExMemBufOut,
            Src1Data => Src1DataExMemBufOut, Src2Data => Src2DataExMemBufOut,
            Dst1Data => Dst1DataExMemBufOut, Dst2Data => Dst2DataExMemBufOut,

			M0 => M0, M1 => M1
            --, memoryOut=> --: OUT STD_LOGIC_VECTOR(wordSize - 1 DOWNTO 0)

        );
    
    -- ###########################################################################################
    --Memory/WriteBack Buffer

    -- ###########################################################################################
    -- Write Back Stage


END ARCHITECTURE;