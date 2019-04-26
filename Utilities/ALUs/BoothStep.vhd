LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY BoothStep IS
    PORT (
        p :IN STD_LOGIC_VECTOR(32 DOWNTO 0);
        x :IN STD_LOGIC_VECTOR(23 DOWNTO 0);
        f :OUT STD_LOGIC_VECTOR(32 DOWNTO 0)
    );
END BoothStep;

ARCHITECTURE BoothStepArch OF BoothStep IS
    SIGNAL op2,res : STD_LOGIC_VECTOR(23 DOWNTO 0);
    SIGNAL carryIn : STD_LOGIC;
BEGIN
    AdderCmp : ENTITY work.NBitAdder GENERIC MAP(24) PORT MAP(p(32 DOWNTO 9),op2,carryIn,res);
    carryIn <= p(2) AND (p(1) NAND p(0) ); -- this for twos complenet
    
    op2 <= (23 DOWNTO 0 => '0') WHEN p(2 DOWNTO 0) = "000" or p(2 DOWNTO 0) = "111"
    ELSE x WHEN p(2 DOWNTO 0) = "001" or p(2 DOWNTO 0) = "010"
    Else x(23-1 DOWNTO 0) &'0' WHEN p(2 DOWNTO 0) = "011"
    Else NOT (x(23-1 DOWNTO 0)) &'1'  WHEN p(2 DOWNTO 0) = "100"
    ELSE NOT x;

    f <= "00" & res & p(8 DOWNTO 2);
END BoothStepArch; 