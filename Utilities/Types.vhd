LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;


package Types is
    -- type ARRAYOFREGS is array(natural range <>) of std_logic_vector;
    type ARRAYOFREGS8 is array(natural range <>) of std_logic_vector(7 DOWNTO 0);
    type ARRAYOFREGS16 is array(natural range <>) of std_logic_vector(15 DOWNTO 0);
end package;