LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.math_real.all;
USE IEEE.numeric_std.all;

-- Decoder Entity

ENTITY Decoder IS
        GENERIC (wordSize : integer := 3); --wordSize : Number of selection Lines
    PORT(
            T : IN STD_LOGIC_VECTOR(wordSize-1  DOWNTO 0); 
            en:IN STD_LOGIC;
            decoded : OUT STD_LOGIC_VECTOR((2**wordSize)-1 DOWNTO 0)
        );

END Decoder;

----------------------------------------------------------------------
-- Decoder Architecture

ARCHITECTURE DecoderArch OF Decoder IS

    BEGIN
     

        loop1: FOR i IN 0 TO (2**wordSize -1)
            GENERATE
                
                decoded(i) <= '1' when i = to_integer(unsigned(T)) and en = '1'
                else '0';

            END GENERATE;


    END DecoderArch;