LIBRARY work;
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

USE work.Constants.all;

entity ControlUnit is 
port(
    opCode1,opCode2:IN std_logic_vector(operationSize-1 downto 0) ;
    interrupt:IN std_logic;
    reset:IN std_logic;
    insertNOP:IN std_logic;
    Execute1,Execute2:OUT std_logic;
    readFromMemory1,readFromMemory2:OUT std_logic;
    wrtieToMemory1,wrtieToMemory2:OUT std_logic;
    WB1,WB2:OUT std_logic;
    Branch1,Branch2:OUT std_logic;
    enableOut:OUT std_logic;
    incSP1,incSP2:OUT std_logic;
    decSP1,decSP2:OUT std_logic;
    wbMuxSelector1,wbMuxSelector2:OUT std_logic_vector(1 downto 0) ;
    outPortPipe:OUT std_logic; --0:take the data from 1st pipe ,1:take the data from 2nd pipe
    pcSelector:OUT std_logic_vector(2 downto 0) 
);
End Entity ControlUnit;

architecture ControlUnitArch of ControlUnit is

    --signal loadImmediate1,loadImmediate2:STD_LOGIC;
    --signal wbMuxSelctorSignal:std_logic_vector(1 downto 0) ;
     
begin
    firstPipe:Entity work.OnePipeControlUnit PORT MAP(
        opCode1,Execute1,readFromMemory1,wrtieToMemory1,WB1,Branch1,incSP1,decSP1,wbMuxSelector1
    );
    seconedPipe:Entity work.OnePipeControlUnit PORT MAP(
        opCode2,Execute2,readFromMemory2,wrtieToMemory2,WB2,Branch2,incSP2,decSP2,wbMuxSelector2
    );

    --firstPipeWBMuxSelector:Entity work.mux2 Generic map(2) port map(wbMuxSelctorSignal,"11",loadImmediate1,wbMuxSelector1);
     --PC selector is an input to The Mux that selects the pc 
     pcSelector<="100" when reset='1'
     else "101" when interrupt='1'
     else "000" when insertNOP='1'
     else "010" when ( opCode1=opRET or opCode1=opRTI)
     else "001";
    enableOut<='1' when (opCode1=opOUT or opCode2=opOut)
    else '0';
    outPortPipe<='1' when opCode1=opOut
    else '0';
end ControlUnitArch ; -- ControlUnitArch
