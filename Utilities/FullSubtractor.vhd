library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity FullSubtractor is 
Port (  
    x : in STD_LOGIC;
    y : in STD_LOGIC;
    bin : in STD_LOGIC;
    difference : out STD_LOGIC;
    bout : out STD_LOGIC);
    end FullSubtractor;
architecture Behavioral of FullSubtractor is
begin
    difference<=x xor y xor bin;
    bout<=((not x)and y)or((not x)and bin)or(y and bin);
end Behavioral;