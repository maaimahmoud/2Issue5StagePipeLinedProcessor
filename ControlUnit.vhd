LIBRARY work;
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

USE work.Constants.all;

entity ControlUnit is 
port(
    opCode1,opCode2:IN std_logic_vector(operationSize-1 downto 0) ;
    clk:IN std_logic;
    interrupt:IN std_logic;
    reset:IN std_logic;
    insertNOP:IN std_logic;
    isBranch: IN std_logic;
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
    pcSelector:OUT std_logic_vector(2 downto 0) ;
    stopFetch: OUT STD_LOGIC;
    pushPC,popPC:OUT std_logic_vector(1 downto 0) ;
    pushFlags,popFlags:out std_logic 
);
End Entity ControlUnit;

architecture ControlUnitArch of ControlUnit is

    --signal loadImmediate1,loadImmediate2:STD_LOGIC;
    --signal wbMuxSelctorSignal:std_logic_vector(1 downto 0) ;
    
    signal stallInterrupt,stallRTI,stallCALL,stallRET,stall:std_logic;
    signal rtiSignal,callSignal,retSignal:std_logic;
    signal pushOnInterrupt: std_logic_vector(1 downto 0);
    signal popOnRti: std_logic_vector(1 downto 0) ;
    signal pushOnCall: std_logic_vector(1 downto 0) ;
    signal popOnRet: std_logic_vector(1 downto 0);
    signal incSP1Temp,incSP2Temp,decSP1Temp,decSP2Temp:std_logic;
     
    signal Execute2Out,readFromMemory2Out,wrtieToMemory2Out,WB2Out,Branch2Out,incSP2TempOut,decSP2TempOut:STD_LOGIC;

begin
    stall<= stallInterrupt or stallRTI or stallCALL or stallRET;
    
    rtiSignal<='1' when opCode1=opRTI
    else '0';
    
    callSignal<='1' when opCode1=opCall
    else '0';
    
    retSignal<='1' when opCode1=opRET
    else '0';
    
    firstPipe:Entity work.OnePipeControlUnit PORT MAP(
        opCode1,stall,Execute1,readFromMemory1,wrtieToMemory1,WB1,Branch1,incSP1Temp,decSP1Temp,wbMuxSelector1
    );
    seconedPipe:Entity work.OnePipeControlUnit PORT MAP(
        opCode2,stall,Execute2Out,readFromMemory2Out,wrtieToMemory2Out,WB2Out,Branch2Out,incSP2TempOut,decSP2TempOut,wbMuxSelector2
    );

    incSP1 <='1' when incSP1Temp='1' or popFlags='1'
    else '0';
    incSP2<='1' when incSP2Temp='1' or popFlags='1'
    else '0';
    decSP1<='1' when decSP1Temp='1' or pushFlags='1'
    else '0';
    decSP2<='1' when decSP2Temp='1' or pushFlags='1'
    else '0';

    Execute2 <=  Execute2Out AND (NOT insertNOP);
    readFromMemory2 <=  readFromMemory2Out AND (NOT insertNOP);
    wrtieToMemory2 <=  wrtieToMemory2Out AND (NOT insertNOP);
    WB2 <=  WB2Out AND (NOT insertNOP);
    Branch2 <=  Branch2Out AND (NOT insertNOP);
    incSP2Temp <= incSP2TempOut  AND (NOT insertNOP);
    decSP2Temp <= decSP2TempOut  AND (NOT insertNOP);


    inerruptHandler:Entity work.InterruptHandler port map(
        interrupt =>interrupt,
        clk =>clk,
        reset =>reset,
        push=>pushOnInterrupt,
        interruptToControlUnit=>stallInterrupt
    );
    rtiHandler:Entity work.rtiHandler port map(
        RTI=>rtiSignal,
        clk=>clk,
        reset=>reset,
        pop=>popOnRti,
        RtiToControlUnit=>stallRTI
    );
    callHandler:Entity work.callHandler port map(
        call=>callSignal,
        clk=>clk,
        reset=>reset,
        push=>pushOnCall,
        callToControlUnit=>stallCALL
    );
    retHandler:Entity work.retHandler port map(
        ret=>retSignal,
        clk=>clk,
        reset=>reset,
        pop=>popOnRet,
        retToControlUnit =>stallRET
    );
    pushFlags<='1' when (stallInterrupt='1' and pushOnInterrupt="11" ) 
    else '0';

    popFlags<='1' when (stallRTI='1' and popOnRti="11" )
    else '0';

    pushPC<= "01" when (pushOnCall="00" or pushOnInterrupt="01")
    else "10" when (pushOnCall="01" or pushOnInterrupt="10")
    else "00";
    
    popPC<="01" when (popOnRet="00" or popOnRti="01")
    else "10"when (popOnRet="01"or popOnRti="10")
    else "00";
    
    stopFetch <= '1' WHEN interrupt = '1' OR pushPC = "01" OR pushPC = "10" OR popPC = "01" OR popPC = "10"  
    ELSE '0';

    --firstPipeWBMuxSelector:Entity work.mux2 Generic map(2) port map(wbMuxSelctorSignal,"11",loadImmediate1,wbMuxSelector1);
    --PC selector is an input to The Mux that selects the pc 
    pcSelector<="100" when FALLING_EDGE(reset)
    else "101" when interrupt='1'
    else "000" when insertNOP='1'
    else "011" when isBranch = '1'
    else "010" when ( opCode1=opRET or opCode1=opRTI)
    else "001";
    
    enableOut<='1' when (opCode1=opOUT or opCode2=opOut)
    else '0';
     
    outPortPipe<='0' when opCode1=opOut
    else '1';

    end ControlUnitArch ; -- ControlUnitArch
