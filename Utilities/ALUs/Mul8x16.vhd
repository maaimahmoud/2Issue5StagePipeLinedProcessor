LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;


ENTITY Mul8x16 IS
    PORT (
        q :IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        m :IN STD_LOGIC_VECTOR(15 DOWNTO 0); -- operads to be multiplied
        f :OUT STD_LOGIC_VECTOR(15 DOWNTO 0); -- result
        clk,start,rst :IN STD_LOGIC; -- clk and signal start to start NOTe start should be 0 THEN goes TO 1
        sel,startAndPause : IN STD_LOGIC
    );
END Mul8x16;

ARCHITECTURE Mul8x16Arch OF Mul8x16 IS
    SIGNAL pInit,pBs,pMux,pReg : STD_LOGIC_VECTOR(2*16 DOWNTO 0);
    SIGNAL mReg : STD_LOGIC_VECTOR(15 DOWNTO 0); 
    SIGNAL mExtended : STD_LOGIC_VECTOR(23 DOWNTO 0); 
BEGIN
    pInit <=  ( 7+16 DOWNTO 0 =>'0') & q &'0';
    mExtended <= (7 downto 0 => mReg(15))&mReg;

    pRegCmp : ENTITY work.Reg GENERIC MAP(2*16+1) PORT MAP(pBs,startAndPause,clk,rst,pReg);
    mRegCmp : ENTITY work.Reg GENERIC MAP(16) PORT MAP(m,'1',start,rst,mReg);
    MuxCmp :  ENTITY work.BinaryMux GENERIC MAP(2*16+1) PORT MAP(pReg,pInit,sel,pMux);
    BSCmp : ENTITY work.BoothStep PORT MAP(pMux,mExtended,pBs);
    -- output only valid if done is one
    
    --f <= pBs(2*16-8 DOWNTO 9); -- without floating point
    f <= pBs(15+7 DOWNTO 7); --with floating point

END Mul8x16Arch; 
