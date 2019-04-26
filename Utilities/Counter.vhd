LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

-- Counter entity

-- load ==> a parallel load to the counter
-- reset ==> 1 to reset the counter
-- isLoad ==> 1 to put the parallel load in the counter
-- count ==> output of the counter

ENTITY Counter IS

    GENERIC (n: integer :=2);

    PORT(
        en,reset, clk: in std_logic;
        count: out std_logic_vector(n-1 downto 0)
    );

END Counter;


ARCHITECTURE CounterArch OF Counter IS

    -- SIGNAL counterInput, countAdded, currentCount, resetOrCurrent,zerosSignal: std_logic_vector(n-1 DOWNTO 0);
    SIGNAL addedOne, oneSignal,currentCount : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    SIGNAL finalReset: STD_LOGIC;

    BEGIN
    
        oneSignal <= ( others => '0');
        finalReset <= clk AND reset;

        counterReg: ENTITY work.Reg GENERIC MAP(n) PORT MAP(addedOne, en, clk, finalReset, currentCount);
        nextCount: ENTITY work.NBitAdder GENERIC MAP(n) PORT MAP(currentCount, oneSignal, '1', addedOne);
        -- muxloadOrCurrent: ENTITY work.mux2 GENERIC MAP(n) PORT MAP(resetOrCurrent, load, isLoad, counterInput);
        -- muxInput: ENTITY work.mux2 GENERIC MAP(n) PORT MAP(countAdded, zerosSignal, reset, resetOrCurrent);
        count <= currentCount;

END ARCHITECTURE;