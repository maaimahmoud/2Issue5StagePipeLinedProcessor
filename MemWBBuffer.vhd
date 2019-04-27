LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

-- Mem/WB buffer Entity

ENTITY MemWBBuffer IS
    GENERIC (regNum: integer :=3 ; wordSize : integer := 16);
    PORT(
            clk, rst, enableRead1, enableRead2: in std_logic;

            ----------------------------------------------------------
            WB1In, WB2In: in std_logic;

            ALU1In, ALU2In, MemIn: in std_logic_vector(wordSize-1 downto 0);
            inPortIn1, inPortIn2: in std_logic_vector(wordSize-1 downto 0);

            mux1WBSelectorIn, mux2WBSelectorIn: in std_logic_vector(1 downto 0);

            RSrc1In, RDst1In,
            RSrc2In, RDst2In: in std_logic_vector(2 downto 0);

            ----------------------------------------------------------
            WB1Out, WB2Out: out std_logic;

            ALU1Out, ALU2Out, MemOut: out std_logic_vector(wordSize-1 downto 0);
            inPortOut1, inPortOut2: out std_logic_vector(wordSize-1 downto 0);

            mux1WBSelectorOut, mux2WBSelectorOut: out std_logic_vector(1 downto 0);

            RSrc1Out, RDst1Out,
            RSrc2Out, RDst2Out: out std_logic_vector(2 downto 0)
        );

END MemWBBuffer;

----------------------------------------------------------------------
-- Mem/WB buffer Architecture

ARCHITECTURE MemWBBufferArch OF MemWBBuffer IS

    SIGNAL notClk: std_logic;

    BEGIN


        notClk <= not clk;

        -------------------------------------------------------------------

        control1Map: ENTITY work.DFlipFlop PORT MAP
        (
            WB1In, enableRead1, notClk, rst, WB1Out
        );

        control2Map: ENTITY work.DFlipFlop PORT MAP
        (
            WB2In, enableRead2, notClk, rst, WB2Out
        );

        ------------------------------------------------------------------------

        alu1Map: ENTITY work.Reg GENERIC MAP(wordSize) PORT MAP
        (
            ALU1In, enableRead1, notClk, rst, ALU1Out
        );


        alu2Map: ENTITY work.Reg GENERIC MAP(wordSize) PORT MAP
        (
            ALU2In, enableRead1, notClk, rst, ALU2Out
        );

        -- look here for enable read Omar
        memMap: ENTITY work.Reg GENERIC MAP(wordSize) PORT MAP
        (
            MemIn, enableRead2, notClk, rst, MemOut
        );


        ---------------------------------------------------------------------------

        mux1Map: ENTITY work.Reg GENERIC MAP(2) PORT MAP
        (
            mux1WBSelectorIn, enableRead2, notClk, rst, mux1WBSelectorOut
        );

        mux2Map: ENTITY work.Reg GENERIC MAP(2) PORT MAP
        (
            mux2WBSelectorIn, enableRead2, notClk, rst, mux2WBSelectorOut
        );

        -------------------------------------------------------------------------------

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

        -----------------------------------------------------------------------------

        inport1Map: ENTITY work.Reg GENERIC MAP(wordSize) PORT MAP
        (
            inPortIn1, enableRead1, notClk, rst, inPortOut1
        );


        inPort2Map: ENTITY work.Reg GENERIC MAP(wordSize) PORT MAP
        (
            inPortIn2, enableRead2, notClk, rst, inPortOut2
        );

        ------------------------------------------------------------------------------


END ARCHITECTURE;