LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

-- Tristate buffer Entity

ENTITY Tristate IS
        GENERIC (wordSize : integer := 32);
    PORT(
            input : IN STD_LOGIC_VECTOR(wordSize-1  DOWNTO 0);
            en:IN STD_LOGIC;
            output : OUT STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0)
        );

END Tristate;

----------------------------------------------------------------------
-- Tristate buffer Architecture

ARCHITECTURE TriStateArch OF Tristate IS

BEGIN

    output <= input WHEN en='1'
    else (others=>'Z');


END TriStateArch;