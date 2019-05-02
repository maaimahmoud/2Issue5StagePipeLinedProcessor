LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
USE IEEE.math_real.all;
USE work.Constants.all;

ENTITY MotherBoard IS

	Generic(regNum: integer := 3; addressBits: integer := 20; wordSize: integer :=16; pcInputsNum: integer := 6);

	PORT(
            clk, reset, INTERRUPT : IN STD_LOGIC;

            inPort : IN STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
            
            outPort : OUT STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0)
		);

END ENTITY MotherBoard;

------------------------------------------------------------

ARCHITECTURE MotherBoardArch OF MotherBoard IS

    -- General Parameters
        SIGNAL M0, M1 : STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
        SIGNAL notClk: STD_LOGIC;

    -- Control Unit Parameters
        SIGNAL insertNOP: STD_LOGIC;
        SIGNAL control_incSP1, control_decSP1, control_incSP2, control_decSP2: STD_LOGIC;
        SIGNAL control_EX1, control_Read1, control_Write1, control_WB1, control_EX2, control_Read2, control_Write2, control_WB2: STD_LOGIC;
        SIGNAL control_WB1Selector, control_WB2Selector: STD_LOGIC_VECTOR(1 DOWNTO 0);

    -- Fetch Parameters
        SIGNAL pcEn: STD_LOGIC;
        SIGNAL pcSrcSelector: STD_LOGIC_VECTOR( integer(ceil(log2(real(pcInputsNum))))-1 DOWNTO 0);
        SIGNAL fetch_pc: STD_LOGIC_VECTOR((2*wordSize)-1 DOWNTO 0);
        SIGNAL fetch_instruction1, fetch_instruction2: STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
        SIGNAL stackOutput, branchAddress: STD_LOGIC_VECTOR((2*wordSize)-1 DOWNTO 0);

    -- Fetch/Decode Buffer
        SIGNAL fetchDecode_En: STD_LOGIC;
        SIGNAL fetchDecode_pc: STD_LOGIC_VECTOR((2*wordSize)-1 DOWNTO 0);
        SIGNAL fetchDecode_instruction1, fetchDecode_instruction2: STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);


    -- Decode Parameters
        SIGNAL Decode_alu1Op: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0);    
        SIGNAL Decode_RSrc1, Decode_RDst1: STD_LOGIC_VECTOR(regNum-1 DOWNTO 0);
        SIGNAL Decode_RSrc1Val, Decode_RDst1Val: STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
        
        SIGNAL Decode_alu2Op: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0); 
        SIGNAL Decode_RSrc2, Decode_RDst2: STD_LOGIC_VECTOR(regNum-1 DOWNTO 0);
        SIGNAL Decode_RSrc2Val, Decode_RDst2Val: STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
        
        SIGNAL Decode_ImmVal: STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);

    -- Decode/Execute Parameters
        SIGNAL decodeExecute_En1, decodeExecute_En2:STD_LOGIC;
        SIGNAL decodeExecute_incSP1, decodeExecute_incSP2, decodeExecute_decSP1, decodeExecute_decSP2:STD_LOGIC;

        SIGNAL decodeExecute_WB1Selector, decodeExecute_WB2Selector: std_logic_vector(1 downto 0);
        SIGNAL decodeExecute_EX1, decodeExecute_Read1, decodeExecute_Write1, decodeExecute_WB1, decodeExecute_EX2, decodeExecute_Read2, decodeExecute_Write2, decodeExecute_WB2: STD_LOGIC;
        SIGNAL decodeExecute_RSrc1Val, decodeExecute_RDst1Val, decodeExecute_RSrc2Val, decodeExecute_RDst2Val: STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
        SIGNAL decodeExecute_RSrc1, decodeExecute_RDst1, decodeExecute_RSrc2, decodeExecute_RDst2: STD_LOGIC_VECTOR(regNum-1 DOWNTO 0);
        SIGNAL decodeExecute_pc: STD_LOGIC_VECTOR((2*wordSize)-1 DOWNTO 0);
        SIGNAL decodeExecute_inPort1Val, decodeExecute_inPort2Val: STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
        SIGNAL decodeExecute_ImmVal: STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
        SIGNAL decodeExecute_alu1Op, decodeExecute_alu2Op: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0);
        

    -- Execute Parameters
        -- SIGNAL MEM1In, MEM2In, WB1In, WB2In: STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
        SIGNAL execute_Mux1Selector, execute_Mux2Selector, execute_Mux3Selector, execute_Mux4Selector: STD_LOGIC_VECTOR(2 DOWNTO 0);
        SIGNAL execute_alu1Out, execute_alu2Out: STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);

        SIGNAL branch1, branch2: STD_LOGIC;
        SIGNAL isBranch: STD_LOGIC;


    -- Execute/Memory Parameters
        SIGNAL executeMem_En1, executeMem_En2: STD_LOGIC;

        SIGNAL executeMem_pc: STD_LOGIC_VECTOR((2*wordSize)-1 DOWNTO 0);
        SIGNAL executeMem_ImmVal: STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);

        SIGNAL executeMem_MEM1, executeMem_Read1, executeMem_Write1,executeMem_WB1:STD_LOGIC;
        SIGNAL executeMem_WB1Selector: std_logic_vector(1 downto 0); 
        SIGNAL executeMem_RSrc1, executeMem_RDst1: STD_LOGIC_VECTOR(regNum-1 DOWNTO 0);
        SIGNAL executeMem_RSrc1Val, executeMem_RDst1Val, executeMem_alu1Out, executeMem_inPort1Val: STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
        SIGNAL executeMem_incSP1, executeMem_decSP1: STD_LOGIC;
        

        SIGNAL executeMem_MEM2, executeMem_Read2 ,executeMem_Write2, executeMem_WB2: STD_LOGIC;
        SIGNAL executeMem_WB2Selector: std_logic_vector(1 downto 0);
        SIGNAL executeMem_RSrc2, executeMem_RDst2: STD_LOGIC_VECTOR(regNum-1 DOWNTO 0);
        SIGNAL executeMem_RSrc2Val, executeMem_RDst2Val, executeMem_alu2Out, executeMem_inPort2Val : STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
        SIGNAL executeMem_incSP2, executeMem_decSP2: STD_LOGIC;


    -- Memory Parameters
        SIGNAL mem_memoryOut: STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);

    -- Memory/WriteBack Parameters
        SIGNAL memWB_En1, memWB_En2: STD_LOGIC;


        SIGNAL memWB_WB1: STD_LOGIC;
        SIGNAL memWB_WB1Selector: std_logic_vector(1 downto 0);
        SIGNAL memWB_RSrc1, memWB_RDst1:STD_LOGIC_VECTOR(2 DOWNTO 0);
        SIGNAL memWB_alu1Out, memWB_inPortVal1: std_logic_vector(wordSize-1 downto 0);

        SIGNAL memWB_WB2: STD_LOGIC;
        SIGNAL memWB_WB2Selector: std_logic_vector(1 downto 0);
        SIGNAL memWB_RSrc2, memWB_RDst2: std_logic_vector(2 downto 0);
        SIGNAL memWB_alu2Out, memWB_inPortVal2: std_logic_vector(wordSize-1 downto 0);

        SIGNAL memWB_MemoryOut: std_logic_vector(wordSize-1 downto 0);
        SIGNAL memWB_ImmVal: STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
        
    -- WriteBack Parameters
        SIGNAL WB_WB1Val, WB_WB2Val: std_logic_vector(wordSize-1 downto 0);

    
    -- flag register
        SIGNAL flagOut: std_logic_vector(flagSize-1 downto 0); -- flagIn,

    -- Out Register Parameters
        SIGNAL outRegEn, outRegSelect: STD_LOGIC;
        SIGNAL outRegInput: STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);


	BEGIN
    
        notClk <= NOT clk;

    -- ###########################################################################################
    -- Fetch Stage
        fetchMap: ENTITY work.Fetch GENERIC MAP (addressBits, wordSize, pcInputsNum) PORT MAP (
            clk => clk , reset => reset,
            pcEn => pcEn, -- TODO: control unit
            pcSrcSelector => pcSrcSelector,     -- TODO: control unit 

            stackOutput => stackOutput , branchAddress => branchAddress,-- : IN STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);  -- TODO:

            M0 => M0 , M1 => M1 ,

            dataOut1 => fetch_instruction1, dataOut2 => fetch_instruction2,
            
            pc => fetch_pc
        );
    -- ###########################################################################################
    -- Fetch/Decode Buffer
        FetchDecodeBufferMap: ENTITY work.FetchDecodeBuffer GENERIC MAP (wordSize) PORT MAP (
            clk => notClk, reset => reset,
			bufferEn  => fetchDecode_En,
			pcIn => fetch_pc,
            instruction1In =>fetch_instruction1 , instruction2In => fetch_instruction2,
			pc => fetchDecode_pc,
            instruction1Out => fetchDecode_instruction1 ,instruction2Out => fetchDecode_instruction2
        );
    -- ###########################################################################################
    -- Decode Stage
        DecodeMap: ENTITY work.Decode GENERIC MAP( regNum, wordSize ) PORT MAP (
            clk => clk , reset => reset,

            instruction1 => fetchDecode_instruction1, instruction2 => fetchDecode_instruction2,

            wb1 => memWB_WB1, wb2 => memWB_WB2,
            
            writeReg1 => memWB_RDst1, writeReg2 =>  memWB_RDst2,

            writeData1 => WB_WB1Val, writeData2 => WB_WB2Val,
            ----------------------------------------------
            alu1Operation => Decode_alu1Op, alu2Operation => Decode_alu2Op,

            Src1 => Decode_RSrc1, Src2 => Decode_RSrc2, Dst1 => Decode_RDst1, Dst2 => Decode_RDst2,

            src1Data => Decode_RSrc1Val , dst1DataFinal => Decode_RDst1Val, 
            src2Data => Decode_RSrc2Val, dst2DataFinal => Decode_RDst2Val, -- : OUT STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0)

            immediateValue => Decode_ImmVal
        );


 -- ##########################################################################################
    -- control unit
        controlUnitMap: ENTITY work.ControlUnit PORT MAP(

                opCode1 =>fetchDecode_instruction1(wordSize-1 DOWNTO wordSize-operationSize) ,
                opCode2 => fetchDecode_instruction2(wordSize-1 DOWNTO wordSize-operationSize),
                interrupt => INTERRUPT,
                reset => reset,
                insertNOP => insertNOP,
                ------------------------------------------------

                Execute1 => control_EX1,Execute2 => control_EX2,
                readFromMemory1 => control_Read1,readFromMemory2 => control_Read2,
                wrtieToMemory1 => control_Write1,wrtieToMemory2 => control_Write2,
                WB1 => control_WB1 ,WB2 => control_WB2,
                Branch1 => branch1,Branch2 => branch2,
                enableOut => outRegEn,
                incSP1 => control_incSP1,incSP2 => control_incSP2,
                decSP1 => control_decSP1,decSP2 => control_decSP2,
                wbMuxSelector1 => control_WB1Selector,wbMuxSelector2 => control_WB2Selector,
                outPortPipe => outRegSelect,
                pcSelector => pcSrcSelector

        );

        insertNOPMAP: ENTITY work.NOPInsertionUnit PORT MAP (
            Rdst1 => Decode_RDst1, Rsrc2 => Decode_RSrc2, Rdst2 =>  Decode_RDst2,
            instruction1OpCode => Decode_alu1Op, instruction2OpCode => Decode_alu2Op,
            insertNOP  => insertNOP -- TODO: use this output signal
        );

        
        -- Out Register
        outMuxMap: ENTITY work.mux2 GENERIC MAP(wordSize) PORT MAP(
            A => Decode_RDst1Val, B =>  Decode_RDst2Val,
            S => outRegSelect,
            C => outRegInput
        );

        outRegMap: ENTITY work.Reg GENERIC MAP(wordSize) PORT MAP (
            D => outRegInput,
            en => outRegEn, clk => clk, rst =>reset ,
            Q => outPort
        );
    -- ###########################################################################################
    --Decode/execute buffer

        IDEXBufferMap: ENTITY work.IDEXBuffer GENERIC MAP(regNum, wordSize) PORT MAP(
            clk, reset, decodeExecute_En1, decodeExecute_En2,

            Decode_alu1Op, Decode_alu2Op,

            control_EX1, control_Read1, control_Write1, control_WB1, -- TODO: Control unit
            control_EX2, control_Read2, control_Write2, control_WB2, -- TODO: Control unit

            Decode_RSrc1Val, Decode_RDst1Val,
            Decode_RSrc2Val, Decode_RDst2Val,

            Decode_RSrc1, Decode_RDst1,
            Decode_RSrc2, Decode_RDst2,

            fetchDecode_pc,
            inPort, inPort,

            control_WB1Selector, control_WB2Selector, -- TODO: from control 
            
            control_incSP1, control_incSP2,
            control_decSP1, control_decSP2,

            Decode_ImmVal,
            ----------------------------------------------
            decodeExecute_alu1Op, decodeExecute_alu2Op,

            decodeExecute_EX1, decodeExecute_Read1, decodeExecute_Write1, decodeExecute_WB1,
            decodeExecute_EX2, decodeExecute_Read2, decodeExecute_Write2, decodeExecute_WB2,

            decodeExecute_RSrc1Val, decodeExecute_RDst1Val,
            decodeExecute_RSrc2Val, decodeExecute_RDst2Val,


            decodeExecute_RSrc1, decodeExecute_RDst1,
            decodeExecute_RSrc2, decodeExecute_RDst2,

            decodeExecute_pc,
            decodeExecute_inPort1Val, decodeExecute_inPort2Val,

            decodeExecute_WB1Selector, decodeExecute_WB2Selector,

            decodeExecute_incSP1, decodeExecute_incSP2,
            decodeExecute_decSP1, decodeExecute_decSP2,

            decodeExecute_ImmVal
        );

    -- ###########################################################################################
    -- Execute Stage
        forwardUnitMap: ENTITY work.ForwardingUnit PORT MAP(
            MEM1 => executeMem_WB1, MEM2 => executeMem_WB2,

            WB1 => memWB_WB1, WB2 => memWB_WB2,
            
            Rdst1IEIM => executeMem_RDst1, Rdst2IEIM => executeMem_RDst2,
            Rdst1IMWB => memWB_RDst1, Rdst2IMWB => memWB_RDst2,
            
            Rdst1 => decodeExecute_RDst1, Rdst2 => decodeExecute_RDst2,
            Rsrc1 =>decodeExecute_RSrc1 , Rsrc2 => decodeExecute_RSrc2 ,--: in std_logic_vector(numRegister-1 downto 0) ;

            ---------------------------------
            out1 => execute_Mux1Selector,
            out2 => execute_Mux2Selector,
            out3 => execute_Mux3Selector,
            out4 => execute_Mux4Selector
        );


        ExecuteMap: ENTITY work.ExecuteStage GENERIC MAP(wordSize) PORT MAP(
            clk, reset,

            decodeExecute_RSrc1Val, decodeExecute_RDst1Val,
            decodeExecute_RSrc2Val, decodeExecute_RDst2Val,

            executeMem_alu1Out, executeMem_alu2Out, WB_WB1Val, WB_WB2Val, -- for forwarding

            execute_Mux1Selector, execute_Mux2Selector,
            execute_Mux3Selector, execute_Mux4Selector, -- TODO select mux inputs control unit

            decodeExecute_alu1Op, decodeExecute_alu2Op,

            decodeExecute_EX1, decodeExecute_EX2,

            --------------------------------------------

            execute_alu1Out, execute_alu2Out,

            flagOut,

            branch1, branch2,

            isBranch
        );


    -- ###########################################################################################
    -- Execute/Memory Buffer
        ExecuteMemoryBufferMap: ENTITY work.ExecuteMemoryBuffer GENERIC MAP (regNum, addressBits, wordSize) PORT MAP(
            clk => notClk, reset => reset,
            bufferEn1 => executeMem_En1, bufferEn2 =>executeMem_En2,

            -- inputs from Execute Stage
            Read1In => decodeExecute_Read1, Read2In => decodeExecute_Read2, Write1In => decodeExecute_Write1, Write2In =>  decodeExecute_Write2,--: IN STD_LOGIC;
            WB1In =>  decodeExecute_WB1, WB2In =>  decodeExecute_WB2,
            inPort1In => decodeExecute_inPort1Val,  inPort2In => decodeExecute_inPort2Val,

            pcIn => decodeExecute_pc, 
            alu1OutIn => execute_alu1Out, alu2OutIn => execute_alu2Out,
            
            Src1In => decodeExecute_RSrc1, Src2In => decodeExecute_RSrc2, Dst1In => decodeExecute_RDst1, Dst2In => decodeExecute_RDst2,
            Src1DataIn => decodeExecute_RSrc1Val, Src2DataIn => decodeExecute_RSrc2Val, Dst1DataIn => decodeExecute_RDst1Val, Dst2DataIn => decodeExecute_RDst2Val,
            mux1WBSelectorIn => decodeExecute_WB1Selector , mux2WBSelectorIn =>  decodeExecute_WB2Selector,

            incSP1In => decodeExecute_incSP1, incSP2In => decodeExecute_incSP2,
            decSP1In => decodeExecute_decSP1, decSP2In => decodeExecute_decSP2,

            immediateValueIn => decodeExecute_ImmVal,
            -------------------------------------------------------
            -- outputs to Memory Stage
            Read1 =>executeMem_Read1 , Read2 => executeMem_Read2 , Write1 =>executeMem_Write1 ,Write2 =>executeMem_Write2 ,
            WB1 => executeMem_WB1, WB2 =>  executeMem_WB2 ,
            inPort1 => executeMem_inPort1Val,  inPort2 => executeMem_inPort2Val,

            pc => executeMem_pc , alu1Out => executeMem_alu1Out , alu2Out => executeMem_alu2Out,

            Src1 => executeMem_RSrc1, Src2 => executeMem_RSrc2, Dst1 => executeMem_RDst1, Dst2 => executeMem_RDst2,

            Src1Data => executeMem_RSrc1Val, Src2Data => executeMem_RSrc2Val,
            Dst1Data => executeMem_RDst1Val, Dst2Data => executeMem_RDst2Val,

            mux1WBSelector =>  executeMem_WB1Selector, mux2WBSelector => executeMem_WB2Selector,

            MEM1 => executeMem_MEM1, MEM2 =>  executeMem_MEM2,

            incSP1 => executeMem_incSP1, incSP2 => executeMem_incSP2,
            decSP1 => executeMem_decSP1, decSP2 => executeMem_decSP2,


            immediateValue => executeMem_ImmVal
        );
    -- ###########################################################################################
    --Memory Stage
        MemoryMap: ENTITY work.Memory GENERIC MAP ( regNum, addressBits, wordSize  ) PORT MAP(
            clk => clk, reset => reset,

            Read1 => executeMem_Read1 , Read2 => executeMem_Read2 , Write1 => executeMem_Write1 ,Write2 => executeMem_Write2,
            pc => executeMem_pc , alu1Out => executeMem_alu1Out , alu2Out => executeMem_alu2Out, -- TODO: check if it's neccessary to pass alu1, alu2

            Src1Data => executeMem_RSrc1Val, Src2Data => executeMem_RSrc2Val,
            Dst1Data => executeMem_RDst1Val, Dst2Data => executeMem_RDst2Val,
            
            incSP1 => executeMem_incSP1, decSP1 => executeMem_decSP1 ,
            incSP2 => executeMem_incSP2 , decSP2 => executeMem_decSP2, 
            --------------------------------------
            M0 => M0, M1 => M1,
            
            memoryOut=> mem_memoryOut

        );
    
    -- ###########################################################################################
    --Memory/WriteBack Buffer

        MEMWBMap: ENTITY work.MemWBBuffer GENERIC MAP (regNum, wordSize) PORT MAP(
            clk, reset, memWB_En1, memWB_En2,

            executeMem_WB1, executeMem_WB2,

            executeMem_alu1Out, executeMem_alu2Out, mem_memoryOut,

            executeMem_inPort1Val, executeMem_inPort2Val,

            executeMem_WB1Selector, executeMem_WB2Selector,

            executeMem_RSrc1, executeMem_RDst1, executeMem_RSrc2, executeMem_RDst2,

            executeMem_ImmVal,

            ----------------------------------------

            memWB_WB1, memWB_WB2,

            memWB_alu1Out, memWB_alu2Out, memWB_MemoryOut,

            memWB_inPortVal1, memWB_inPortVal2,

            memWB_WB1Selector, memWB_WB2Selector,

            memWB_RSrc1, memWB_RDst1, memWB_RSrc2, memWB_RDst2,

            memWB_ImmVal

        );

    -- ###########################################################################################
    -- Write Back Stage

        WBStageMap: ENTITY work.WBStage Generic map (wordSize) PORT MAP (
                
                memWB_alu1Out, memWB_alu2Out, memWB_MemoryOut, 
                
                memWB_inPortVal1, memWB_inPortVal2, memWB_ImmVal,
                
                memWB_WB1Selector, memWB_WB2Selector,
    
                WB_WB1Val, WB_WB2Val --: std_logic_vector(wordSize downto 0)
            );


END ARCHITECTURE;