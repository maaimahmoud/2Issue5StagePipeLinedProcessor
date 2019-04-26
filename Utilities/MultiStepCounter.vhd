LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

-- Counter entity

-- load ==> a parallel load to the counter
-- reset ==> 1 to reset the counter
-- isLoad ==> 1 to put the parallel load in the counter
-- count ==> output of the counter

ENTITY MultiStepCounter IS

    GENERIC (n: integer :=2);

    PORT(
        load,toBeAdded: in std_logic_vector(n-1 downto 0);
        reset, clk, isLoad,MFC: in std_logic;
        count: out std_logic_vector(n-1 downto 0)
    );

END MultiStepCounter;


ARCHITECTURE MultiStepCounterArch OF MultiStepCounter    IS

    SIGNAL loadOrCurrent,counterInput, countAdded, currentCount: std_logic_vector(n-1 DOWNTO 0);

    BEGIN

        counterReg: ENTITY work.Reg GENERIC MAP(n) PORT MAP(counterInput, '1', clk, reset, currentCount);
        nextCount: ENTITY work.NBitAdder GENERIC MAP(n) PORT MAP(currentCount, toBeAdded, '0', countAdded);
        muxloadOrCurrent: ENTITY work.mux2 GENERIC MAP(n) PORT MAP(currentCount, load, isLoad, loadOrCurrent);
        muxInput: ENTITY work.mux2 GENERIC MAP(n) PORT MAP(loadOrCurrent, countAdded, MFC, counterInput);
        count <= currentCount;
END ARCHITECTURE;