LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.Utiles.ALL;

ENTITY Alus8x16 IS
    GENERIC (n :INTEGER := 1);
    PORT (
        q :IN genericArrayofVector8bit(n-1 downto 0);
        m :IN genericArrayofVector16bit(n-1 downto 0); 
        f :INOUT genericArrayofVector16bit(n-1 downto 0);
        clk,start,rst :IN STD_LOGIC;
        done :INOUT STD_LOGIC; 
        working :INOUT STD_LOGIC
    );
END Alus8x16;

ARCHITECTURE Alus8x16Arch OF Alus8x16 IS
SIGNAL mulOut: genericArrayofVector16bit(n-1 downto 0);
BEGIN
    cmp1: ENTITY work.nMul8x16 GENERIC MAP(n) PORT MAP (q,m,mulOut,clk,start,rst,done,working);
    cmp2: ENTITY work.Accumulator GENERIC MAP(n) PORT MAP (mulOut,f,working,rst,'1');
END Alus8x16Arch; 
