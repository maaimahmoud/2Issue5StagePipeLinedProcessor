LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
USE IEEE.math_real.all;
USE work.Types.ARRAYOFREGS;

-- Mux Entity

ENTITY Mux IS

    GENERIC (
        inputNum : integer := 2; 
        wordSize : integer := 16
        );
    PORT(
            inputs : IN ARRAYOFREGS(0 to inputNum-1)(wordSize-1 DOWNTO 0);
            selectionLines : IN std_logic_vector (integer(ceil(log2(real(inputNum))))-1 downto 0);
            output : OUT std_logic_vector(wordSize-1 DOWNTO 0)
        );

END ENTITY Mux;

------------------------------------------------------------

-- MUX Architecture

ARCHITECTURE MuxArch OF Mux IS

    BEGIN

        output <=  inputs(to_integer(unsigned(selectionLines)));

END MuxArch;