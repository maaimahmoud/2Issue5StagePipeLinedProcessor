LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY BoothMul IS
    GENERIC (n :INTEGER := 16);
    PORT (
        m,r :IN STD_LOGIC_VECTOR(n-1 DOWNTO 0); -- operads to be multiplied
        f :OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0); -- result
        clk,start :IN STD_LOGIC; -- clk and signal start to start NOTe start should be 0 THEN goes TO 1
        done : INOUT STD_LOGIC -- done indicates finish of multiplication and f is ready
    );
END BoothMul;

ARCHITECTURE BoothMulArch OF BoothMul IS
    SIGNAL s,a,pIntial,pBoothStep,pMux,pReg : STD_LOGIC_VECTOR(2*n DOWNTO 0);
    SIGNAL mTwosComplement : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    SIGNAL counter : STD_LOGIC_VECTOR(n DOWNTO 0);
    SIGNAL counterRst,startAndPause :STD_LOGIC;
BEGIN
    -- algo paramters intialaization
    a <= m & (m'length DOWNTO 0 => '0');
    s <= mTwosComplement & (mTwosComplement'length DOWNTO 0 => '0');
    pIntial <= (pIntial'length DOWNTO r'length+2 => '0') & r & '0';

    -- wrinting and controling of circuit
    done <= counter(n-1);
    startAndPause <= start AND NOT done;
    counterRst <= NOT start;

    -- create and wire circuit main compenet
    --BS_comp2 : ENTITY work.BoothStep GENERIC MAP(n) PORT MAP(pBoothStep,s,a,p_booth2);
    RegCmp : ENTITY work.Reg GENERIC MAP(2*n+1) PORT MAP(pBoothStep,startAndPause,clk,'0',pReg);
    MuxCmp :  ENTITY work.BinaryMux GENERIC MAP(2*n+1) PORT MAP(pReg,pIntial,counter(0),pMux);
    BSCmp : ENTITY work.BoothStep GENERIC MAP(n) PORT MAP(pMux,s,a,pBoothStep);
    CounterCmp : ENTITY work.ShIFtReg GENERIC MAP(n) PORT MAP(counter,clk,startAndPause,counterRst,'0');
    TwosComplementCmp: ENTITY work.TwosComplement GENERIC MAP(n) PORT MAP(m,mTwosComplement);

    -- output only valid if done is one
    f <= pBoothStep(n-1 DOWNTO 1);

END BoothMulArch; 
