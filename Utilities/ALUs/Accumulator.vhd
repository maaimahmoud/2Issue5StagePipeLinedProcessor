LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.Utiles.ALL;

ENTITY Accumulator IS
    GENERIC (n :INTEGER := 1);
    PORT (
        a :IN genericArrayofVector16bit(n-1 downto 0); 
        f :INOUT genericArrayofVector16bit(n-1 downto 0);
        save,rst,en :IN STD_LOGIC
    );
END Accumulator;

ARCHITECTURE AccumulatorArch OF Accumulator IS
    SIGNAL outReg : genericArrayofVector16bit(n-1 downto 0);
BEGIN
    gen: FOR i IN n-1 DOWNTO 0  GENERATE
    BEGIN
        cmp1: ENTITY work.NBitAdder GENERIC MAP (16) PORT MAP (a(i),outReg(i),'0',f(i));
        cmp2: ENTITY work.Reg GENERIC MAP (16) PORT MAP (f(i),'1',save,rst,outReg(i));
    END GENERATE;
END AccumulatorArch; 
