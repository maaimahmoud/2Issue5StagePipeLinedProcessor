--this unit is responsible for sending the signals to memory stage to push the PC into the stack 
--and also for sending interrupt signal to the control unit to make it out NOP instructions
--it's also responsible for enabling the register where the flags will be preserved 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
USE IEEE.math_real.all;
USE work.Constants.all;



entity callHandler is 
port(
    call,clk,reset:IN std_logic;
    push:OUT std_logic_vector(1 downto 0);
    callToControlUnit:OUT std_logic
);
end entity callHandler;

architecture callHandlerArch of callHandler is

signal currentCount:std_logic_vector(1 downto 0) ;
signal enableCallRegister:std_logic;
signal enableCounter:std_logic;
signal callOut:std_logic;
signal resetCounter:std_logic;
begin
    --enableCounter<= '1' when interrupt='1' or currentCount="00" or currentCount="01" 
    --else '0';
    enableCounter<='1' when (call='1' or reset = '1')
    else '0' when currentCount="11" or falling_edge(reset);

    resetCounter<='1' WHEN (currentCount = "11" or reset ='1')
    ELSE '0';
    -- resetCounter<=reset or call;
    callCounter: Entity work.counter generic map(2) port map(
        en=>enableCounter,
        reset=>resetCounter,
        clk=>clk,
        count=>currentCount
    );
    -- callLatch:Entity work.OneBitReg port map(
    --     D=>call,
    --     en =>enableCallRegister,
    --     clk =>clk,
    --     rst =>reset,
    --     Q=>callOut
    -- );
    -- push <= "00" when currentCount="00" and callOut='1' 
    -- else "01" when currentCount="01"
    -- else "11";

    push <= currentCount;
    -- push <= "00" when currentCount(1 downto 0)="00" and interruptOut='1' 
    -- else "01" when currentCount(1 downto 0)="01"
    -- else "10" when currentCount(1 downto 0)="10"
    -- else "11";

    callToControlUnit<='1' when (push="01" or push="10") -- or push="11")--and interruptOut='1' 
    else '0';

end callHandlerArch ; -- callHandlerArch
