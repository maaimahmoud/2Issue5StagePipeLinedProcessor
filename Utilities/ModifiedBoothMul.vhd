LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ModifiedBoothMul IS
    GENERIC (n :INTEGER := 8);
    PORT (
        m,q :IN STD_LOGIC_VECTOR(n-1 DOWNTO 0); -- operads to be multiplied
        f :OUT STD_LOGIC_VECTOR(2*n-1 DOWNTO 0); -- result
        clk,start :IN STD_LOGIC; -- clk and signal start to start NOTe start should be 0 THEN goes TO 1
        done : INOUT STD_LOGIC; -- done indicates finish of multiplication and f is ready
		c :IN STD_LOGIC_VECTOR(n-1 DOWNTO 0) := (n-1 DOWNTO 0 => '0') -- operand to be add on result of multiplication 
    );
END ModifiedBoothMul;

ARCHITECTURE ModifiedBoothMulArch OF ModifiedBoothMul IS
    SIGNAL pInit,pBs,pMux,pReg : STD_LOGIC_VECTOR(2*n DOWNTO 0);
    SIGNAL counter : STD_LOGIC_VECTOR(n/2 DOWNTO 0);
    SIGNAL counterRst,startAndPause :STD_LOGIC;
BEGIN
    -- algo paramters intialaization
    pInit <= c & q &'0';

    -- wrinting and controling of circuit
    done <= counter(n/2-1);
    startAndPause <= NOT done;
    counterRst <= start;

    -- create and wire circuit main compenet
    RegCmp : ENTITY work.Reg GENERIC MAP(2*n+1) PORT MAP(pBs,startAndPause,clk,'0',pReg);
    MuxCmp :  ENTITY work.BinaryMux GENERIC MAP(2*n+1) PORT MAP(pReg,pInit,counter(0),pMux);
    BSCmp : ENTITY work.ModifiedBoothStep GENERIC MAP(n) PORT MAP(pMux,m,pBs);
    CounterCmp : ENTITY work.ShIFtReg GENERIC MAP(n/2) PORT MAP(counter,clk,startAndPause,'0',counterRst); -- to be put with system rst

    -- output only valid if done is one
    f <= pBs(2*n DOWNTO 1);

END ModifiedBoothMulArch; 
