LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY BoothStep IS
    GENERIC (n:INTEGER := 16);
    PORT (
        p,s,a :IN STD_LOGIC_VECTOR(2*n DOWNTO 0);
        f :OUT STD_LOGIC_VECTOR(2*n DOWNTO 0)
    );
END BoothStep;

ARCHITECTURE BoothStepArch OF BoothStep IS
    SIGNAL op2,res : STD_LOGIC_VECTOR(2*n DOWNTO 0);
BEGIN
    AdderComp : ENTITY work.NBitAdder GENERIC MAP(2*n+1) PORT MAP(p,op2,'0',res);
    op2 <= a WHEN p(1 DOWNTO 0) = "01" 
    ELSE s WHEN p(1 DOWNTO 0) = "10"
    ELSE (OTHERS=>'0');
    f <= res(2*n) & res(2*n DOWNTO 1);
END BoothStepArch; 