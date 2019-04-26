LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
--USE IEEE.math_real.all;
USE work.Types.ARRAYOFREGS16;

-- Mux Entity

ENTITY Mux IS

    GENERIC (
        inputNum : integer := 512
        );
    PORT(
            inputs : IN ARRAYOFREGS16(0 to inputNum-1);
            selectionLines : IN std_logic_vector (8 downto 0);
            output : OUT std_logic_vector(15 DOWNTO 0)
        );

END ENTITY Mux;

------------------------------------------------------------

-- MUX Architecture

ARCHITECTURE MuxArch OF Mux IS

    BEGIN

        output <=  inputs(to_integer(unsigned(selectionLines)));

END MuxArch;