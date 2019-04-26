library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Entity DownCounter is
    Generic (n:INTEGER:=3);
    port(
        load:IN std_logic_vector(n-1 downto 0) ;
        enable,clk,isLoad:in std_logic;
        currentCount:inout std_logic_vector(n-1 downto 0) 
    );
    end DownCounter;
    ARCHITECTURE DownCounterArch of DownCounter is 
    SIGNAL counterInput, subtractorOutput,zerosSignal: std_logic_vector(n-1 DOWNTO 0);
    begin
    zerosSignal <= (others => '0'); 
        counterReg: ENTITY work.Reg GENERIC MAP(n) PORT MAP(counterInput, enable, clk, '0', currentCount);
        nextCount: ENTITY work.NBitSubtractor GENERIC MAP(n) PORT MAP(currentCount, zerosSignal, '1', subtractorOutput);
        muxloadOrCurrent: ENTITY work.mux2 GENERIC MAP(n) PORT MAP(subtractorOutput, load, isLoad, counterInput);
        
    end  ARCHITECTURE   ;
     