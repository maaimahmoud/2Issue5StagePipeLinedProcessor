LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
USE IEEE.math_real.all;
USE work.Constants.all;

ENTITY MotherBoard IS

	Generic(regNum: integer := 3; addressBits: integer := 20; wordSize: integer :=16; pcInputsNum: integer := 6);

	PORT(
            clk, reset, INTEREPT : IN STD_LOGIC;

            inPort : IN STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
            
            outPort : OUT STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0)
		);

END ENTITY MotherBoard;

------------------------------------------------------------

ARCHITECTURE MotherBoardArch OF MotherBoard IS

    -- General Parameters
        SIGNAL M0, M1 : STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
        SIGNAL notClk: STD_LOGIC;

    -- Fetch Parameters
        SIGNAL pcEn: STD_LOGIC;
        SIGNAL pcSrcSelector: STD_LOGIC_VECTOR( integer(ceil(log2(real(pcInputsNum))))-1 DOWNTO 0);
        SIGNAL pcFetchOut: STD_LOGIC_VECTOR((2*wordSize)-1 DOWNTO 0);
        SIGNAL fetchInstruction1, fetchInstruction2: STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
        SIGNAL stackOutput, branchAddress: STD_LOGIC_VECTOR((2*wordSize)-1 DOWNTO 0);

    -- Fetch/Decode Buffer
        SIGNAL fetchDecodeBufferEn: STD_LOGIC;
        SIGNAL pcFetDecodeBufOut: STD_LOGIC_VECTOR((2*wordSize)-1 DOWNTO 0);
        SIGNAL instruction1FetDecodeBufOut, instruction2FetDecodeBufOut: STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);


    -- Decode Parameters
        SIGNAL inOperation: STD_LOGIC;       


    -- Decode/Execute Parameters
        SIGNAL enableRead1, enableRead2, EX1InIDEX, Read1InIDEX, Write1InIDEX, WB1InIDEX, EX2InIDEX, Read2InIDEX, Write2InIDEX, WB2InIDEX: STD_LOGIC;
        SIGNAL EX1OutIDEX, Read1OutIDEX, Write1OutIDEX, WB1OutIDEX, EX2OutIDEX, Read2OutIDEX, Write2OutIDEX, WB2OutIDEX: STD_LOGIC;
        SIGNAL RSrcValue1InIDEX, RdstValue1InIDEX, RSrcValue2InIDEX, RdstValue2InIDEX: STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
        SIGNAL RSrcValue1OutIDEX, RdstValue1OutIDEX, RSrcValue2OutIDEX, RdstValue2OutIDEX: STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
        SIGNAL RSrc1InIDEX, RDst1InIDEX, RSrc2InIDEX, RDst2InIDEX: STD_LOGIC_VECTOR(regNum-1 DOWNTO 0);
        SIGNAL RSrc1OutIDEX, RDst1OutIDEX, RSrc2OutIDEX, RDst2OutIDEX: STD_LOGIC_VECTOR(regNum-1 DOWNTO 0);
        SIGNAL pcOutIDEX: STD_LOGIC_VECTOR((2*wordSize)-1 DOWNTO 0);
        SIGNAL inPortIn1IDEX, inPortIn2IDEX, inPortOut1IDEX, inPortOut2IDEX: STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
        SIGNAL mux1WBSelectorInIDEX, mux2WBSelectorInIDEX, mux1WBSelectorOutIDEX, mux2WBSelectorOutIDEX: std_logic_vector(1 downto 0);


    -- Execute Parameters
        SIGNAL MEM1In, MEM2In, WB1In, WB2In: STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
        SIGNAL mux1SelectorEX, mux2SelectorEX, mux3SelectorEX, mux4SelectorEX: STD_LOGIC_VECTOR(2 DOWNTO 0);
        SIGNAL alu1Operation, alu2Operation: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0);
        SIGNAL ALU1Out, ALU2Out: STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);


    -- Execute/Memory Parameters
        SIGNAL ExecuteMemoryBuffer1En, ExecuteMemoryBuffer2En: STD_LOGIC;
        SIGNAL Read1ExMemBufOut , Read2ExMemBufOut , Write1ExMemBufOut ,Write2ExMemBufOut : STD_LOGIC;
        SIGNAL pcExMemBufOut: STD_LOGIC_VECTOR((2*wordSize)-1 DOWNTO 0);
        SIGNAL alu1ExMemBufOut, alu2ExMemBufOut :STD_LOGIC_VECTOR(wordSize - 1 DOWNTO 0);
        SIGNAL Src1DataExMemBufOut, Src2DataExMemBufOut : STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
        SIGNAL Dst1DataExMemBufOut, Dst2DataExMemBufOut : STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);

    -- Memory Parameters
        

    -- Memory/WriteBack Parameters
        SIGNAL WB1InMEMWB, WB2InMEMWB, WB1OutMEMWB, WB2OutMEMWB: STD_LOGIC;
        SIGNAL ALU1InMEMWB, ALU2InMEMWB, MemInMEMWB, ALU1OutMEMWB, ALU2OutMEMWB, MemOutMEMWB: std_logic_vector(wordSize-1 downto 0);
        SIGNAL mux1WBSelectorIn, mux2WBSelectorIn, mux1WBSelectorOut, mux2WBSelectorOut: std_logic_vector(1 downto 0);
        SIGNAL RSrc1InMemWB, RDst1InMemWB, RSrc2InMemWB, RDst2InMemWB, RSrc1OutMemWB, RDst1OutMemWB, RSrc2OutMemWB, RDst2OutMemWB: std_logic_vector(2 downto 0);
        SIGNAL inPortIn1MemWB, inPortIn2MemWB, inPortOut1IDEXMemWB, inPortOut2IDEXMemWB: STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);

    -- WriteBack Parameters
        SIGNAL WBOut1, WBOut2: std_logic_vector(wordSize-1 downto 0);

    
    -- flag register
        SIGNAL flagIn, flagOut: std_logic_vector(flagSize-1 downto 0);


	BEGIN
    
        notClk <= NOT clk;


    -- ###########################################################################################
    -- Fetch Stage
        fetchMap: ENTITY work.Fetch GENERIC MAP (addressBits, wordSize, pcInputsNum) PORT MAP (
            clk => clk , reset => reset,
            pcEn => pcEn,
            pcSrcSelector => pcSrcSelector,     -- TODO: control unit 

            stackOutput => stackOutput , branchAddress => branchAddress,-- : IN STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);  -- TODO

            M0 => M0 , M1 => M1 ,

            dataOut1 => fetchInstruction1, dataOut2 => fetchInstruction2,
            
            pc => pcFetchOut
        );
    -- ###########################################################################################
    -- Fetch/Decode Buffer
        FetchDecodeBufferMap: ENTITY work.FetchDecodeBuffer GENERIC MAP (wordSize) PORT MAP (
            clk => notClk, reset => reset,
			bufferEn  => fetchDecodeBufferEn,
			pcIn => pcFetchOut,
            instruction1In =>fetchInstruction1 , instruction2In => fetchInstruction2,
			pc => pcFetDecodeBufOut,
            instruction1Out => instruction1FetDecodeBufOut ,instruction2Out => instruction2FetDecodeBufOut
        );
    -- ###########################################################################################
    -- Decode Stage
        DecodeMap: ENTITY work.Decode GENERIC MAP( regNum, wordSize ) PORT MAP (
            clk => clk , reset => reset,

            -- pc => pcFetDecodeBufOut,

            instruction1 => instruction1FetDecodeBufOut, instruction2 => instruction2FetDecodeBufOut,
            
            writeReg1 => RDst1OutMemWB, writeReg2 =>  RDst2OutMemWB,

            writeData1 => WBOut1, writeData2 => WBOut2,

            inOperation => inOperation,

            outPort => outPort,

            Src1 => RSrc1InIDEX, Src2 => RSrc2InIDEX, Dst1 => RDst1InIDEX, Dst2 => RDst2InIDEX,

            src1Data => RSrcValue1InIDEX , dst1Data => RdstValue1InIDEX, 
            src2Data => RSrcValue2InIDEX, dst2Data => RdstValue2InIDEX-- : OUT STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0)
        );

    -- ###########################################################################################
    --Decode/execute buffer

        IDEXBufferMap: ENTITY work.IDEXBuffer GENERIC MAP(regNum, wordSize) PORT MAP(
            clk, reset, enableRead1, enableRead2,

            EX1InIDEX, Read1InIDEX, Write1InIDEX, WB1InIDEX,
            EX2InIDEX, Read2InIDEX, Write2InIDEX, WB2InIDEX,

            RSrcValue1InIDEX, RdstValue1InIDEX,
            RSrcValue2InIDEX, RdstValue2InIDEX,

            RSrc1InIDEX, RDst1InIDEX,
            RSrc2InIDEX, RDst2InIDEX,

            pcFetDecodeBufOut,
            inPort, inPort,

            mux1WBSelectorInIDEX, mux2WBSelectorInIDEX,

            EX1OutIDEX, Read1OutIDEX, Write1OutIDEX, WB1OutIDEX,
            EX2OutIDEX, Read2OutIDEX, Write2OutIDEX, WB2OutIDEX,

            RSrcValue1OutIDEX, RdstValue1OutIDEX,
            RSrcValue2OutIDEX, RdstValue2OutIDEX,


            RSrc1OutIDEX, RDst1OutIDEX,
            RSrc2OutIDEX, RDst2OutIDEX,

            pcOutIDEX,
            inPortOut1IDEX, inPortOut2IDEX,

            mux1WBSelectorOutIDEX, mux2WBSelectorOutIDEX
        );

    -- ###########################################################################################
    -- Execute Stage

        ExecuteMap: ENTITY work.ExecuteStage GENERIC MAP(wordSize) PORT MAP(
            RSrcValue1InIDEX, RdstValue1InIDEX,
            RSrcValue2InIDEX, RdstValue2InIDEX,

            alu1ExMemBufOut, alu2ExMemBufOut, WBOut1, WBOut2,

            mux1SelectorEX, mux2SelectorEX,
            mux3SelectorEX, mux4SelectorEX,

            alu1Operation, alu2Operation,   -- TODO from opcode

            flagOut,    -- TODO FLAG register

            EX1OutIDEX, EX2OutIDEX,

            ALU1Out, ALU2Out,

            flagIn
        );

    -- ###########################################################################################
    -- Execute/Memory Buffer
        ExecuteMemoryBufferMap: ENTITY work.ExecuteMemoryBuffer GENERIC MAP (regNum, addressBits, wordSize) PORT MAP(
            clk => notClk,
            bufferEn1 => ExecuteMemoryBuffer1En, bufferEn2 =>ExecuteMemoryBuffer2En,

            -- inputs from Execute Stage
            Read1In => Read1OutIDEX, Read2In => Read2OutIDEX, Write1In => Write1OutIDEX, Write2In =>  Write2OutIDEX,--: IN STD_LOGIC;
            WB1In =>  WB1OutIDEX, WB2In =>  WB2OutIDEX,
            inPort1In => inPortOut1IDEX,  inPort2In => inPortOut2IDEX,

            pcIn => pcOutIDEX, 
            alu1OutIn => ALU1Out, alu2OutIn => ALU2Out,
            
            Src1In => RSrc1OutIDEX, Src2In => RSrc2OutIDEX, Dst1In => RDst1OutIDEX, Dst2In => RDst2OutIDEX,
            Src1DataIn => RSrcValue1OutIDEX, Src2DataIn => RSrcValue2OutIDEX, Dst1DataIn => RdstValue1OutIDEX, Dst2DataIn => RdstValue2OutIDEX,
            mux1WBSelectorIn => mux1WBSelectorInIDEX , mux2WBSelectorIn =>  mux2WBSelectorInIDEX,

            -- outputs to Memory Stage
            Read1 =>Read1ExMemBufOut , Read2 => Read2ExMemBufOut , Write1 =>Write1ExMemBufOut ,Write2 =>Write2ExMemBufOut ,
            WB1 => WB1InMEMWB, WB2 =>  WB2InMEMWB ,
            inPort1 => inPortIn1MemWB,  inPort2 => inPortIn2MemWB,

            pc => pcExMemBufOut , alu1Out => alu1ExMemBufOut , alu2Out => alu2ExMemBufOut,

            Src1 => RSrc1InMemWB, Src2 => RSrc2InMemWB, Dst1 => RDst1InMemWB, Dst2 => RDst2InMemWB,

            Src1Data => Src1DataExMemBufOut, Src2Data => Src2DataExMemBufOut,
            Dst1Data => Dst1DataExMemBufOut, Dst2Data => Dst2DataExMemBufOut,
            mux1WBSelector =>  mux1WBSelectorIn, mux2WBSelector => mux2WBSelectorIn
        );
    -- ###########################################################################################
    --Memory Stage
        MemoryMap: ENTITY work.Memory GENERIC MAP ( regNum, addressBits, wordSize  ) PORT MAP(
            clk => clk,
            Read1 =>Read1ExMemBufOut , Read2 =>Read2ExMemBufOut , Write1 =>Write1ExMemBufOut ,Write2 => Write2ExMemBufOut,
            pc => pcExMemBufOut , alu1Out => alu1ExMemBufOut , alu2Out => alu2ExMemBufOut,
            Src1Data => Src1DataExMemBufOut, Src2Data => Src2DataExMemBufOut,
            Dst1Data => Dst1DataExMemBufOut, Dst2Data => Dst2DataExMemBufOut,

			M0 => M0, M1 => M1,
            memoryOut=> MemInMEMWB

        );
    
    -- ###########################################################################################
    --Memory/WriteBack Buffer

        MEMWBMap: ENTITY work.MemWBBuffer GENERIC MAP (regNum, wordSize) PORT MAP(
            clk, reset, enableRead1, enableRead2,

            WB1InMEMWB, WB2InMEMWB,

            alu1ExMemBufOut, alu2ExMemBufOut, MemInMEMWB,

            inPortIn1MemWB, inPortIn2MemWB,

            mux1WBSelectorIn, mux2WBSelectorIn,

            RSrc1InMemWB, RDst1InMemWB, RSrc2InMemWB, RDst2InMemWB,

            WB1OutMEMWB, WB2OutMEMWB,

            ALU1OutMEMWB, ALU2OutMEMWB, MemOutMEMWB,

            inPortOut1IDEXMemWB, inPortOut2IDEXMemWB,

            mux1WBSelectorOut, mux2WBSelectorOut,

            RSrc1OutMemWB, RDst1OutMemWB, RSrc2OutMemWB, RDst2OutMemWB

        );

    -- ###########################################################################################
    -- Write Back Stage

        WBStageMap: ENTITY work.WBStage Generic map (wordSize) PORT MAP (
                
                ALU1OutMEMWB, ALU2OutMEMWB, MemOutMEMWB, 
                
                inPortOut1IDEXMemWB, inPortOut2IDEXMemWB,
                
                mux1WBSelectorOut, mux2WBSelectorOut,
    
                WBOut1, WBOut2 --: std_logic_vector(wordSize downto 0)
            );


END ARCHITECTURE;