--this unit is responsible for sending the signals to memory stage to pop the PC into the stack 
--and also for sending interrupt signal to the control unit to make it out NOP instructions
--it's also responsible for enabling the register where the flags will be preserved 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
USE IEEE.math_real.all;
USE work.Constants.all;



entity retHandler is 
port(
    ret,clk,reset:IN std_logic;
    pop:OUT std_logic_vector(1 downto 0);
    retToControlUnit:OUT std_logic
);
end entity retHandler;

architecture retHandlerArch of retHandler is

signal currentCount:std_logic_vector(1 downto 0) ;
signal enableretRegister:std_logic;
signal enableCounter:std_logic;
signal retOut:std_logic;
signal resetCounter:std_logic;
begin
    --enableCounter<= '1' when interrupt='1' or currentCount="00" or currentCount="01" 
    --else '0';
    enableretRegister<='1' when ret='1' or currentCount="11"
    else '0';
    enableCounter<='1' when retOut='1' and currentCount/="11"
    else '0';
    resetCounter<=reset or ret;
    retCounter: Entity work.counter generic map(2) port map(
        en=>enableCounter,
        reset=>resetCounter,
        clk=>clk,
        count=>currentCount
    );
    retLatch:Entity work.OneBitReg port map(
        D=>ret,
        en =>enableretRegister,
        clk =>clk,
        rst =>reset,
        Q=>retOut
    );
    pop <= "00" when currentCount="00" and retOut='1' 
    else "01" when currentCount="01"
    else "11";

    retToControlUnit<='1' when (currentCount="00" or currentCount="01")and retOut='1'
    else '0';

end retHandlerArch ; -- retHandlerArch