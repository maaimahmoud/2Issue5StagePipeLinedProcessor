LIBRARY work;
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

USE work.Constants.all;

entity ControlUnit is 
port(
    opCode1,opCode2:IN std_logic_vector(operationSize-1 downto 0) ;
    popStageInMem: IN std_logic_vector(1 downto 0);
    startProccessor: IN std_logic;
    clk:IN std_logic;
    interrupt:IN std_logic;
    reset:IN std_logic;
    insertNOP:IN std_logic;
    isBranch: IN std_logic;
    loadUse: IN std_logic;
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
    signal loadM0: std_logic:='1';
    signal stallInterrupt,stallRTI,stallCALL,stallRET,stall:std_logic;
    signal rtiSignal, RTIFinish,callSignal, aluCallSignal,retSignal, RETFinish:std_logic;
    signal pushOnInterrupt: std_logic_vector(1 downto 0);
    signal popOnRti: std_logic_vector(1 downto 0) ;
    signal pushOnCall: std_logic_vector(1 downto 0) ;
    signal popOnRet: std_logic_vector(1 downto 0);
    signal incSP1Temp,incSP2Temp,decSP1Temp,decSP2Temp:std_logic;
     
    signal Execute1Out,readFromMemory1Out,wrtieToMemory1Out,WB1Out,Branch1Out,incSP1TempOut,decSP1TempOut: STD_LOGIC;
    signal Execute2Out,readFromMemory2Out,wrtieToMemory2Out,WB2Out,Branch2Out,incSP2TempOut,decSP2TempOut: STD_LOGIC;

begin
    stall<= stallInterrupt or stallRTI or stallCALL or stallRET;
    
    rtiSignal<='1' when opCode1=opRTI
    else '0';
    
    aluCallSignal<='1' when opCode1=opCall
    else '0';

    callSignal <= '1' WHEN rising_edge(aluCallSignal)
    ELSE '0' WHEN pushOnCall /= "00";
    
    retSignal<='1' when opCode1=opRET
    else '0';
    
    firstPipe:Entity work.OnePipeControlUnit PORT MAP(
        opCode1,stall,Execute1Out,readFromMemory1Out,wrtieToMemory1Out,WB1Out,Branch1Out,incSP1TempOut,decSP1TempOut,wbMuxSelector1
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

    Execute1 <=  Execute1Out AND (NOT loadUse) AND (NOT stall);
    readFromMemory1 <=  readFromMemory1Out AND (NOT loadUse) AND (NOT stall);
    wrtieToMemory1 <=  wrtieToMemory1Out AND (NOT loadUse) AND (NOT stall);
    WB1 <=  WB1Out AND (NOT loadUse) AND (NOT stall);
    Branch1 <=  Branch1Out AND (NOT loadUse) AND (NOT stall);
    incSP1Temp <= incSP1TempOut  AND (NOT loadUse) AND (NOT stall);
    decSP1Temp <= decSP1TempOut  AND (NOT loadUse) AND (NOT stall);
    
    
    Execute2 <=  Execute2Out AND (NOT insertNOP) AND (NOT loadUse) AND (NOT stall);
    readFromMemory2 <=  readFromMemory2Out AND (NOT insertNOP) AND (NOT loadUse) AND (NOT stall);
    wrtieToMemory2 <=  wrtieToMemory2Out AND (NOT insertNOP) AND (NOT loadUse) AND (NOT stall);
    WB2 <=  WB2Out AND (NOT insertNOP) AND (NOT loadUse) AND (NOT stall);
    Branch2 <=  Branch2Out AND (NOT insertNOP) AND (NOT loadUse) AND (NOT stall);
    incSP2Temp <= incSP2TempOut  AND (NOT insertNOP) AND (NOT loadUse) AND (NOT stall);
    decSP2Temp <= decSP2TempOut  AND (NOT insertNOP) AND (NOT loadUse) AND (NOT stall);


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
    
    -- PUSH

    pushPC<= "01" when ( pushOnInterrupt="01" OR  pushOnCall="01")
    else "10" when ( pushOnInterrupt="10" OR pushOnCall="10" )
    else "00";

    pushFlags<='1' when ( pushOnInterrupt="11" )  --stallInterrupt='1' and
    else '0';

    -- POP
    popFlags<='1' when ( popOnRti="01" ) -- stallRTI='1' and
    else '0';

    popPC<="10" when ( popOnRti="10" OR popOnRet="01")
    else "01"when (popOnRti="11" OR popOnRet="10")
    else "00";
    
    RTIFinish <= '0' WHEN rising_edge(rtiSignal)
    ELSE '1' WHEN popStageInMem = "01" or reset = '1';

    RETFinish <= '0' WHEN rising_edge(retSignal)
    ELSE '1' WHEN popStageInMem = "01" or reset = '1';



    stopFetch <= '1' WHEN interrupt = '1' OR (callSignal='1' AND pushOnCall /= "01") OR RTIFinish = '0' OR RETFinish = '0' OR pushOnInterrupt = "01" OR pushOnInterrupt = "10" OR popOnRti = "01" OR popOnRti="10" OR pushOnCall = "01" OR popOnRet = "01"  --OR pushPC = "01" OR pushPC = "10" OR popPC = "10" OR popFlags = '1' 
    ELSE '0';

    

    rtiFinishMap: ENTITY work.DFlipFlop PORT MAP
    (
        '0', startProccessor, clk, '0', loadM0
    );

    --firstPipeWBMuxSelector:Entity work.mux2 Generic map(2) port map(wbMuxSelctorSignal,"11",loadImmediate1,wbMuxSelector1);
    --PC selector is an input to The Mux that selects the pc 
    pcSelector<="100" when loadM0 /= '0' --rising_edge(startProccessor)
    else "010" when rtiSignal = '1' or retSignal = '1' --( opCode1=opRET or opCode1=opRTI)
    else "101" when pushOnInterrupt = "11"
    else "110" when pushOnCall = "10" 
    else "000" when insertNOP='1'
    else "011" when isBranch = '1'
    else "001";
    
    enableOut<='1' when (opCode1=opOUT or opCode2=opOut)
    else '0';
     
    outPortPipe<='0' when opCode1=opOut
    else '1';

    end ControlUnitArch ; -- ControlUnitArch
