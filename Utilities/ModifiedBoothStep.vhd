LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY ModifiedBoothStep IS
    GENERIC (n:INTEGER := 8);
    PORT (
        p :IN STD_LOGIC_VECTOR(2*n DOWNTO 0);
        x :IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
        f :OUT STD_LOGIC_VECTOR(2*n DOWNTO 0)
    );
END ModifiedBoothStep;

ARCHITECTURE ModifiedBoothStepArch OF ModifiedBoothStep IS
    SIGNAL op2,res,xTwosComp : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
BEGIN
    TwosCompCmp : ENTITY work.TwosComplement GENERIC MAP(n) PORT MAP(x,xTwosComp);
    AdderCmp : ENTITY work.NBitAdder GENERIC MAP(n) PORT MAP(p(2*n DOWNTO n+1),op2,'0',res);

    op2 <= (n-1 DOWNTO 0 => '0') WHEN p(2 DOWNTO 0) = "000" or p(2 DOWNTO 0) = "111"
    ELSE x WHEN p(2 DOWNTO 0) = "001" or p(2 DOWNTO 0) = "010"
    Else x(n-2 DOWNTO 0) &'0' WHEN p(2 DOWNTO 0) = "011"
    Else xTwosComp(n-2 DOWNTO 0) &'0' WHEN p(2 DOWNTO 0) = "100"
    ELSE xTwosComp;

    f <= res(n-1) & res(n-1) & res & p(n DOWNTO 2) ;
END ModifiedBoothStepArch; 