LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY Memory IS

	Generic(regNum: integer := 3; addressBits: integer := 10; wordSize: integer :=16);

	PORT(
			clk, reset : IN STD_LOGIC;
            Read1, Read2, Write1,Write2: IN STD_LOGIC;
            pc : IN STD_LOGIC_VECTOR((2*wordSize)-1 DOWNTO 0);
            alu1Out, alu2Out : IN  STD_LOGIC_VECTOR(wordSize - 1 DOWNTO 0);
            Src1Data, Src2Data: IN STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
            Dst1Data, Dst2Data : IN STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);

            incSP1, decSP1, incSP2, decSP2: IN STD_LOGIC;
            ----------------------------------------------------------------------
			M0, M1, memoryOut : OUT STD_LOGIC_VECTOR(wordSize - 1 DOWNTO 0)
		);

END ENTITY Memory;

------------------------------------------------------------

ARCHITECTURE MemoryArch OF Memory IS

    SIGNAL we, addressSelection: STD_LOGIC;

    SIGNAL address, operationAddress: STD_LOGIC_VECTOR(addressBits-1 DOWNTO 0);
    SIGNAL data: STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);

    -- Stack pointer
    SIGNAL spEn, spPlusOneCarry, spMinusOneCarry: STD_LOGIC;
    SIGNAL sp, spIn, spPlusOne, spMinusOne: STD_LOGIC_VECTOR((2*wordSize)-1 DOWNTO 0);
	
	BEGIN
        address(addressBits-1 DOWNTO wordSize) <= (OTHERS => '0');

        address(wordSize-1 DOWNTO 0) <= Src1Data WHEN Read1 = '1'
        ELSE Src2Data WHEN Read2 = '1'
        ELSE Dst1Data WHEN Write1 = '1'
        ELSE Dst2Data;


        data <= Src1Data WHEN Read1 = '1'
        ELSE Src2Data;

        we <= Write1 OR Write2;

        addressSelection <= incSP1 OR incSP2 OR decSP1 OR decSP2;

        memoryInputMuxMap: ENTITY work.Mux2 GENERIC MAP(addressBits) PORT MAP(
            A => operationAddress, B => sp(addressBits-1 DOWNTO 0) ,
			S => addressSelection,
			C => address
        );

        dataMemoryMap: ENTITY work.DataMemory GENERIC MAP(addressBits, wordSize) PORT MAP(
                clk => clk ,
                we  => we ,
                address => address,
                datain => data,
                M0 =>  M0,
                M1 =>  M1,
                dataout => memoryOut
            );

        -- TODO: organize plus before execute or execute before minus
        adderOneMap: ENTITY work.NBitAdder GENERIC MAP( (2*wordSize) ) PORT MAP (
            a => sp,
            b => ( 1=>'1', OTHERS=>'0'),
            carryIn=> '0',
            sum => spPlusOne,
            carryOut =>spPlusOneCarry
        );


        minusOneMap: ENTITY work.NBitAdder GENERIC MAP( (2*wordSize) ) PORT MAP (
            a => sp,
            b => ( OTHERS=>'1'),
            carryIn=> '0',
            sum => spMinusOne,
            carryOut =>spMinusOneCarry
        );


        spInputMuxMap: ENTITY work.Mux2 GENERIC MAP((2*wordSize)) PORT MAP(
            A => spPlusOne, B => spMinusOne ,
			S => decSP1 OR decSP2,
			C =>spIn
        );

        spEn <= incSP1 OR decSP1 OR incSP2 OR decSP2;
           

        spMap: ENTITY work.Reg GENERIC MAP((2*wordSize)) PORT MAP(
            D =>  spIn,
            en => spEn, clk => clk , rst => reset ,
            Q => sp
        );

END ARCHITECTURE;