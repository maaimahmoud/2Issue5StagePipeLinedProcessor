--this unit is responsible for sending the signals to memory stage to push the PC into the stack 
--and also for sending interrupt signal to the control unit to make it out NOP instructions
--it's also responsible for enabling the register where the flags will be preserved 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
USE IEEE.math_real.all;
USE work.Constants.all;



entity InterruptHandler is 
port(
    interrupt,clk,reset:IN std_logic;
    push:OUT std_logic_vector(1 downto 0);
    interruptToControlUnit:OUT std_logic
);
end entity InterruptHandler;

architecture InterruptHandlerArch of InterruptHandler is

signal currentCount:std_logic_vector(2 downto 0) ;
signal enableInterruptRegister:std_logic;
signal enableCounter:std_logic;
signal interruptOut:std_logic;
signal resetCounter:std_logic;
begin
    --enableCounter<= '1' when interrupt='1' or currentCount="00" or currentCount="01" 
    --else '0';

    -- enableInterruptRegister<='1' when interrupt='1' or currentCount="11"
    -- else '0';

    enableCounter<='1' when (interrupt = '1' or reset = '1')
    else '0' when currentCount="100" or falling_edge(reset);

    resetCounter<='1' WHEN (currentCount = "100" or reset ='1')
    ELSE '0';

    interruptCounter: Entity work.counter generic map(3) port map(
        en=>enableCounter,
        reset=>resetCounter,
        clk=>clk,
        count=>currentCount
    );
    -- interruptLatch:Entity work.OneBitReg port map(
    --     D=>interrupt,
    --     en =>enableInterruptRegister,
    --     clk =>clk,
    --     rst =>reset,
    --     Q=>interruptOut
    -- );

    push <= currentCount(1 downto 0);
    -- push <= "00" when currentCount(1 downto 0)="00" and interruptOut='1' 
    -- else "01" when currentCount(1 downto 0)="01"
    -- else "10" when currentCount(1 downto 0)="10"
    -- else "11";

    interruptToControlUnit<='1' when (push="01" or push="10" or push="11")--and interruptOut='1' 
    else '0';

end InterruptHandlerArch ; -- InterruptHandlerArch