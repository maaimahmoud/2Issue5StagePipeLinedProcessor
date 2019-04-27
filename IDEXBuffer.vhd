LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

-- ID/EX buffer Entity

ENTITY IDEXBuffer IS
    GENERIC (regNum : integer := 3 ;wordSize : integer := 16);
    PORT(
            clk, rst, enableRead1, enableRead2: in std_logic;

            ------------------------------------------------
            EX1In, Read1In, Write1In, WB1In,
            EX2In, Read2In, Write2In, WB2In: in std_logic;

            RSrcValue1In, RdstValue1In,
            RSrcValue2In, RdstValue2In: in std_logic_vector(wordSize-1 downto 0);

            RSrc1In, RDst1In,
            RSrc2In, RDst2In: in std_logic_vector(regNum-1 downto 0);

            ------------------------------------------------

            pcIn: in std_logic_vector((2*wordSize)-1 downto 0);

            inPortIn1, inPortIn2: in std_logic_vector(wordSize-1 downto 0);

            mux1WBSelectorIn, mux2WBSelectorIn: in std_logic_vector(1 downto 0);

            -------------------------------------------------------
            EX1Out, Read1Out, Write1Out, WB1Out,
            EX2Out, Read2Out, Write2Out, WB2Out: out std_logic;

            RSrcValue1Out, RdstValue1Out,
            RSrcValue2Out, RdstValue2Out: out std_logic_vector(wordSize-1 downto 0);

            RSrc1Out, RDst1Out,
            RSrc2Out, RDst2Out: out std_logic_vector(regNum-1 downto 0);

            ----------------------------------------------------------------

            pcOut: out std_logic_vector((2*wordSize)-1 downto 0);

            inPortOut1, inPortOut2: out std_logic_vector(wordSize-1 downto 0);

            mux1WBSelectorOut, mux2WBSelectorOut: out std_logic_vector(1 downto 0)
        );

END IDEXBuffer;

----------------------------------------------------------------------
-- ID/EX buffer Architecture

ARCHITECTURE IDEXBufferArch OF IDEXBuffer IS

    SIGNAL control1In, control2In, control1Out, control2Out: std_logic_vector(3 downto 0);
    SIGNAL notClk: std_logic;

    BEGIN


        notClk <= not clk;

        control1In <= WB1In & Write1In & Read1In & EX1In;
        control2In <= WB2In & Write2In & Read2In & EX2In;

        -------------------------------------------------------------------

        control1Map: ENTITY work.Reg GENERIC MAP(4) PORT MAP
        (
            control1In, enableRead1, notClk, rst, control1Out
        );

        control2Map: ENTITY work.Reg GENERIC MAP(4) PORT MAP
        (
            control2In, enableRead2, notClk, rst, control2Out
        );

        ------------------------------------------------------------------------

        srcV1Map: ENTITY work.Reg GENERIC MAP(wordSize) PORT MAP
        (
            RSrcValue1In, enableRead1, notClk, rst, RSrcValue1Out
        );


        dstV1Map: ENTITY work.Reg GENERIC MAP(wordSize) PORT MAP
        (
            RDstValue1In, enableRead1, notClk, rst, RDstValue1Out
        );


        srcV2Map: ENTITY work.Reg GENERIC MAP(wordSize) PORT MAP
        (
            RSrcValue2In, enableRead2, notClk, rst, RSrcValue2Out
        );


        dstV2Map: ENTITY work.Reg GENERIC MAP(wordSize) PORT MAP
        (
            RDstValue2In, enableRead2, notClk, rst, RDstValue2Out
        );

        ---------------------------------------------------------------------------

        src1Map: ENTITY work.Reg GENERIC MAP(regNum) PORT MAP
        (
            RSrc1In, enableRead1, notClk, rst, RSrc1Out
        );


        dst1Map: ENTITY work.Reg GENERIC MAP(regNum) PORT MAP
        (
            RDst1In, enableRead1, notClk, rst, RDst1Out
        );


        src2Map: ENTITY work.Reg GENERIC MAP(regNum) PORT MAP
        (
            RSrc2In, enableRead2, notClk, rst, RSrc2Out
        );


        dst2Map: ENTITY work.Reg GENERIC MAP(regNum) PORT MAP
        (
            RDst2In, enableRead2, notClk, rst, RDst2Out
        );

        ----------------------------------------------------------------------------

        -- TODO : enable pc 
        pcMap: ENTITY work.Reg GENERIC MAP(2*wordSize) PORT MAP
        (
            pcIn, enableRead2, notClk, rst, pcOut
        );

        inport1Map: ENTITY work.Reg GENERIC MAP(wordSize) PORT MAP
        (
            inPortIn1, enableRead1, notClk, rst, inPortOut1
        );


        inPort2Map: ENTITY work.Reg GENERIC MAP(wordSize) PORT MAP
        (
            inPortIn2, enableRead2, notClk, rst, inPortOut2
        );

        --------------------------------------------------------------------------

        wbMuxSelector1Map: ENTITY work.Reg GENERIC MAP(2) PORT MAP
        (
            mux1WBSelectorIn, enableRead1, notClk, rst, mux1WBSelectorOut
        );


        wbMuxSelector2Map: ENTITY work.Reg GENERIC MAP(2) PORT MAP
        (
            mux2WBSelectorIn, enableRead2, notClk, rst, mux1WBSelectorOut
        );


        -----------------------------------------------------------------------------

        EX1Out <= control1Out(0);
        Read1Out <= control1Out(1);
        Write1Out <= control1Out(2);
        WB1Out <= control1Out(3);

        EX2Out <= control2Out(0);
        Read2Out <= control2Out(1);
        Write2Out <= control2Out(2);
        WB2Out <= control2Out(3);
        
        -----------------------------------------------------------------------------

END ARCHITECTURE;