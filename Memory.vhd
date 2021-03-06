LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
USE work.Constants.all;

ENTITY Memory IS

	Generic(regNum: integer := 3; addressBits: integer := 10; wordSize: integer :=16);

	PORT(
			clk, reset : IN STD_LOGIC;
            Read1, Read2, Write1,Write2: IN STD_LOGIC;
            flagValue: IN STD_LOGIC_VECTOR(flagSize-1 DOWNTO 0);
            pc, pcPlusOne : IN STD_LOGIC_VECTOR((2*wordSize)-1 DOWNTO 0);
            alu1Op,  alu2Op: STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0);
            alu1Out, alu2Out : IN  STD_LOGIC_VECTOR(wordSize - 1 DOWNTO 0);
            Src1Data, Src2Data: IN STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
            Dst1Data, Dst2Data : IN STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);

            incSP1, decSP1, incSP2, decSP2: IN STD_LOGIC;
            ----------------------------------------------------------------------
            -- M0, M1,
            finishPopping: OUT STD_LOGIC;
            memoryOut : OUT STD_LOGIC_VECTOR(wordSize - 1 DOWNTO 0);
            
            pushPC,popPc:IN std_logic_vector(1 downto 0) ;
            pushFlags,popFlags:IN std_logic
		);

END ENTITY Memory;

------------------------------------------------------------

ARCHITECTURE MemoryArch OF Memory IS

    SIGNAL we, addressSelection: STD_LOGIC;

    SIGNAL address, operationAddress: STD_LOGIC_VECTOR(addressBits-1 DOWNTO 0);
    SIGNAL data: STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);

    -- Stack pointer
    SIGNAL spEn, spMuxSel, spPlusOneCarry, spMinusOneCarry: STD_LOGIC;
    SIGNAL sp, spIn, spPlusOne, spMinusOne,spToBeUsed, pushedPC: STD_LOGIC_VECTOR((2*wordSize)-1 DOWNTO 0);

    SIGNAL memoryOutTemp: std_logic_vector(wordSize-1 downto 0);

    SIGNAL completeflag: STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
	
	BEGIN
        -- address(addressBits-1 DOWNTO wordSize) <= (OTHERS => '0');

        -- address(wordSize-1 DOWNTO 0) <= Src1Data WHEN Read1 = '1'
        -- ELSE Src2Data WHEN Read2 = '1'
        -- ELSE Dst1Data WHEN Write1 = '1'
        -- ELSE Dst2Data;

        completeflag(flagSize-1 DOWNTO 0) <= flagValue;
        completeflag(wordSize-1 DOWNTO flagSize) <= (OTHERS => '0');

        pushedPC <= pcPlusOne WHEN alu1Op = opCall
        ELSE pc;

        data <= Dst1Data when decSP1 = '1'
        ELSE Dst2Data when decSP2 = '1'
        ELSE Src1Data WHEN Write1 = '1'
        ELSE Src2Data when Write2='1'
        ELSE completeflag when pushFlags = '1'
        ELSE pushedPC(2*wordSize-1 downto wordSize) when pushPC="10"
        ELSE pushedPC(wordSize-1 downto 0) when pushPC="01";

        we <= '1' WHEN Write1 ='1' OR Write2 = '1' OR decSP1 ='1' or decSP2='1' OR pushPc = "01" OR pushPC = "10" OR pushFlags = '1' --decSP is added as it will be used when pushing the data to the stack
        ELSE '0';

        addressSelection <= '1' WHEN incSP1 = '1' OR incSP2 = '1' OR decSP1= '1' OR decSP2= '1' OR pushPc = "01" OR pushPC = "10" OR pushFlags = '1' OR popPC = "01" OR popPC = "10" OR popFlags = '1'
        ELSE '0';

        operationAddress(wordSize-1 DOWNTO 0) <= Src1Data WHEN Read1 = '1'
        ELSE Src2Data WHEN Read2 = '1'
        ELSE Dst1Data WHEN Write1 = '1'
        ELSE Dst2Data;

        operationAddress(addressBits-1 DOWNTO wordSize) <= (OTHERS => '0');

        memoryInputMuxMap: ENTITY work.Mux2 GENERIC MAP(addressBits) PORT MAP(
            A => operationAddress, B => spToBeUsed(addressBits-1 DOWNTO 0) ,
			S => addressSelection,
			C => address
        );

        dataMemoryMap: ENTITY work.DataMemory GENERIC MAP(addressBits, wordSize) PORT MAP(
                clk => clk ,
                we  => we ,
                address => address,
                datain => data,
                -- M0 =>  M0,
                -- M1 =>  M1,
                dataout => memoryOutTemp
            );


        memoryOutRegMap: ENTITY work.Reg GENERIC MAP(wordSize) PORT MAP(
            D =>  memoryOutTemp,
            en => '1', clk => clk , rst => reset ,
            Q => memoryOut
        );

        --when using the sp whether to read from memory or write to it if incSP1 or incSP2 is high this means
        --we have to use SP+1 value  if the decSP1 or decSP2 is high this means we have to use the original SP value
        --and since SP is the output of the register that is enabled by inc SP and dec SP signals 
        --so spPlusOne will be sp+2 as the output of the register is input to adder ,also when
        --we want to use sp at decSP1 or decSP2 sp will be equal to sp-1 so we need to choose spPlusOne 
        spToBeUsed<=sp when (incSP1='1' or incSP2='1' or popPC = "01" or popPC = "10" or popFlags='1' )
        else spMinusOne;
        -- TODO: organize plus before execute or execute before minus
        adderOneMap: ENTITY work.NBitAdder GENERIC MAP( (2*wordSize) ) PORT MAP (
            a => sp,
            b => ( 0=>'1', OTHERS=>'0'),
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


        spMuxSel <= '1' WHEN decSP1='1' OR decSP2='1' OR pushPc = "01" OR pushPC = "10" OR pushFlags = '1' 
        ELSE '0';
        
        spInputMuxMap: ENTITY work.Mux2 GENERIC MAP((2*wordSize)) PORT MAP(
            A => spPlusOne, B => spMinusOne ,
			S => spMuxSel,
			C =>spIn
        );

        spEn <= '1' WHEN incSP1= '1' OR decSP1= '1' OR incSP2= '1' OR decSP2 = '1' OR pushPc = "01" OR pushPC = "10" OR pushFlags = '1'OR popPC = "01" OR popPC = "10" OR popFlags = '1'
        ELSE '0';
           

        spMap: ENTITY work.Reg GENERIC MAP((2*wordSize)) PORT MAP(
            D =>  spIn,
            en => spEn, clk => clk , rst => reset,
            Q => sp
        );

        finishPopping <= '1' WHEN popFlags = '0' AND popPC = "00"
        ELSE '0';

END ARCHITECTURE;