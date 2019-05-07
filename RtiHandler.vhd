--this unit is responsible for sending the signals to memory stage to push the PC into the stack 
--and also for sending interrupt signal to the control unit to make it out NOP instructions
--it's also responsible for enabling the register where the flags will be preserved 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
USE IEEE.math_real.all;
USE work.Constants.all;



entity RtiHandler is 
port(
    RTI,clk,reset:IN std_logic;
    pop:OUT std_logic_vector(1 downto 0);
    RtiToControlUnit:OUT std_logic
);
end entity RtiHandler;

architecture RtiHandlerArch of RtiHandler is

signal currentCount:std_logic_vector(2 downto 0) ;
signal enableRtiRegister:std_logic;
signal enableCounter:std_logic;
signal rtiOut:std_logic;
signal resetCounter:std_logic;
begin
    --enableCounter<= '1' when interrupt='1' or currentCount="00" or currentCount="01" 
    --else '0';
    enableCounter<='1' when (rising_edge(RTI) or reset = '1')
    else '0' when currentCount="100" or falling_edge(reset);

    resetCounter<='1' WHEN (currentCount = "100" or reset ='1')
    ELSE '0';

    rtiCounter: Entity work.counter generic map(3) port map(
        en=>enableCounter,
        reset=>resetCounter,
        clk=>clk,
        count=>currentCount
    );


    -- rtiLatch:Entity work.OneBitReg port map(
    --     D=>RTI,
    --     en =>enableRtiRegister,
    --     clk =>clk,
    --     rst =>reset,
    --     Q=>rtiOut
    -- );

    pop <= currentCount(1 downto 0);

    -- pop <= "00" when currentCount="00" and rtiOut='1' 
    -- else "01" when currentCount="01"
    -- else "10" when currentCount="10"
    -- else "11";

    RtiToControlUnit<= '1' when (pop="01" or pop="10" or pop="11")--and rtiOut='1'
    else '0';

end RtiHandlerArch ; -- RtiHandlerArch