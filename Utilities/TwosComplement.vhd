LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

-- TwosComplement Entity

ENTITY TwosComplement is

        GENERIC (wordSize : INTEGER := 16);
    PORT(
        input:in STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
        output:out STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0)
    );

END ENTITY TwosComplement;

----------------------------------------------------------------------
-- Two's Complement Architecture

ARCHITECTURE TwosComplementArch of TwosComplement is

    SIGNAL inA:STD_LOGIC_VECTOR( wordSize-1 DOWNTO 0) ;
    SIGNAL inB:STD_LOGIC_VECTOR( wordSize-1 DOWNTO 0) ;
    SIGNAL inC:STD_LOGIC ;
    SIGNAL outC:STD_LOGIC ;

  BEGIN

    inA <= NOT input;
    inB <= ( OTHERS=>'0'); 
    inC <= '1';
    fx: ENTITY work.NBitAdder GENERIC MAP(wordSize) PORT MAP(inA,inB,inC,output,outC);

  END ARCHITECTURE;
