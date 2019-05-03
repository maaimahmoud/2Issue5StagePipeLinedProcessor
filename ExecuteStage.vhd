Library IEEE;
use ieee.std_logic_1164.all;
use work.Constants.all;

-- Execute Stage Entity

ENTITY ExecuteStage IS

	Generic(wordSize:integer :=16 ; addressSize: integer:=20);
	PORT(
            clk, reset: STD_LOGIC;

            RSrcV1, RDstV1,
            RSrcV2, RDstV2,

            MEM1In, MEM2In,
            WB1In, WB2In: in std_logic_vector(wordSize-1 downto 0);
            
            MemWB1Selector, MemWB2Selector: in STD_LOGIC_VECTOR(1 DOWNTO 0);

            meminPort1Val, meminPort2Val, MemImmediateValue:in STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);


            mux1Selector, mux2Selector,
            mux3Selector, mux4Selector: in std_logic_vector(2 downto 0);

            opCode1, opCode2: in std_logic_vector(operationSize-1 downto 0);

            EX1, EX2: in std_logic;
            
            
            ------------------------------------------------------

            ALU1Out, ALU2Out: out std_logic_vector(wordSize-1 downto 0);

            flagRegOut: out std_logic_vector(flagSize-1 downto 0);

            RSrc1Val, RDst1Val, RSrc2Val, RDst2Val: out STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);

            ---------------------------------------------------------
            Branch1,Branch2: in std_logic;
            
            isBranch:out std_logic;

            BranchAddress:out std_logic_vector(addressSize-1 downto 0) 
		);
END ENTITY ExecuteStage;

----------------------------------------------------------------------
-- ExecuteStage Architecture

ARCHITECTURE ExecuteStageArch of ExecuteStage is

    SIGNAL alu1Op1, alu1Op2, alu2Op1, alu2Op2: std_logic_vector(wordSize-1 downto 0);
    
    SIGNAL flagInput, flagOut, flag1Out, flag2Out: std_logic_vector(flagSize-1 downto 0);
    SIGNAL flagEn: STD_LOGIC;
    Signal isBranch1,isBranch2:STD_logic;

    SIGNAL Mem1Input, Mem2Input:STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);

    BEGIN

        Mem1Input <= MemImmediateValue WHEN MemWB1Selector = "11"
        else meminPort1Val WHEN MemWB1Selector = "10"
        else MEM1In;    

        Mem2Input <= meminPort2Val WHEN MemWB2Selector = "10"
        else MEM2In;

        mux1Map: ENTITY work.Mux5 GENERIC MAP(wordSize) PORT MAP (
            RSrcV1, MEM1Input, Mem2Input, WB1In, WB2In, mux1Selector, alu1Op1
        );

        mux2Map: ENTITY work.Mux5 GENERIC MAP(wordSize) PORT MAP (
            RDstV1, MEM1Input, Mem2Input, WB1In, WB2In, mux2Selector, alu1Op2
        );

        mux3Map: ENTITY work.Mux5 GENERIC MAP(wordSize) PORT MAP (
            RSrcV2, MEM1Input, Mem2Input, WB1In, WB2In, mux3Selector, alu2Op1
        );

        mux4Map: ENTITY work.Mux5 GENERIC MAP(wordSize) PORT MAP (
            RDstV2, MEM1Input, Mem2Input, WB1In, WB2In, mux4Selector, alu2Op2
        ); 

        RSrc1Val <= alu1Op1;
        RDst1Val <= alu1Op2;
        RSrc2Val <= alu2Op1;
        RDst2Val <= alu2Op2;

        -----------------------------------------------------------------------------

        alu1Map: ENTITY work.ALU GENERIC MAP(wordSize) PORT MAP(
            alu1Op1, alu1Op2, 
            opCode1, flagOut,
            EX1, 
            ALU1Out,
            flag1Out
        );


        alu2Map: ENTITY work.ALU GENERIC MAP(wordSize) PORT MAP(
            alu2Op1, alu2Op2, 
            opCode2, flag1Out,
            EX2, 
            ALU2Out,
            flag2Out
        );

        -----------------------------------------------------------------------------


        flagInput <= flag2Out when EX1 = '1' and EX2 = '1'
        else flag2Out when EX1 = '0' and EX2 = '1'
        else flag1Out;

        flagEn <= EX1 OR EX2;

        flagRegMap: ENTITY work.Reg GENERIC MAP(flagSize) PORT MAP(
            D =>  flagInput,
            en => flagEn, clk => clk , rst => reset ,
            Q => flagOut
        );

        flagRegOut <= flagOut;

        -----------------------------------------------------------------------------------------
        -----check if branch is taken
        isBranch1<='1' when (Branch1 = '1' and (
                    opCode1=opJmp or opCode1=opCall 
                    or (opCode1=opJZ and flagOut(ZFLAG)='1') 
                    or (opCode1=opJN and flagOut(NFLAG)='1') 
                    or (opCode1=opJC and flagOut(CFLAG)='1')
            ) )
        else '0';    
        isBranch2<= '1' when ( Branch2 = '1' and (
                    opCode2 = opJmp  or opCode2=opCall 
                    or (opCode2=opJZ and flagOut(ZFLAG)='1') 
                    or (opCode2=opJN and flagOut(NFLAG)='1') 
                    or (opCode2=opJC and flagOut(CFLAG)='1')   
            )
        )
        else '0';
    ---------------calculate the branch address
    BranchAddress(wordSize-1 downto 0) <=(RDstV1) when isBranch1='1'
    else RDstV2 when isBranch2='1';

    BranchAddress(addressSize-1 downto wordSize) <= (others => '0');
    isBranch<= isBranch1 or isBranch2;
 
END ARCHITECTURE;