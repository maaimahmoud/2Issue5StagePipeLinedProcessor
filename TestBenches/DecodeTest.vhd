LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.math_real.all;
USE IEEE.numeric_std.all;
use work.Constants.all;

ENTITY DecodeTest IS
    GENERIC(wordSize : INTEGER := 16);
END DecodeTest;


ARCHITECTURE DecodeTestArch OF DecodeTest IS 
    

    CONSTANT CLK_period : time := 100 ps;


    signal instruction1, instruction2 : STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
    signal wb1, wb2: STD_LOGIC;
    signal writeReg1, writeReg2 : STD_LOGIC_VECTOR(3-1 DOWNTO 0);
    signal writeData1, writeData2 : STD_LOGIC_VECTOR(wordSize-1  DOWNTO 0);
     ---------------------------------------------

    signal alu1Operation, alu2Operation, alu1OperationExpected, alu2OperationExpected:  STD_LOGIC_VECTOR(operationSize-1 DOWNTO 0);
    signal inOperation, inOperationExpected:  STD_LOGIC;
    signal outPort, outPortExpected:  STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
    signal Src1, Src2, Dst1, Dst2, Src1Expected, Src2Expected, Dst1Expected, Dst2Expected:  STD_LOGIC_VECTOR(3-1 DOWNTO 0);
    signal src1Data, dst1Data, src2Data, dst2Data, src1DataExpected, dst1DataExpected, src2DataExpected, dst2DataExpected:  STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);

       

    signal clk, notClk, reset: std_logic;

   
    BEGIN

        decodeMap: ENTITY work.Decode GENERIC MAP (3, wordSize) PORT MAP (
            clk, reset,

            instruction1, instruction2 ,

            wb1, wb2,
            
            writeReg1, writeReg2 ,

            writeData1, writeData2 ,

            ---------------------------------------------

            alu1Operation, alu2Operation ,

            inOperation,
            
            outPort ,

            Src1, Src2, Dst1, Dst2 ,

            src1Data, dst1Data, src2Data, dst2Data
        );


        CLKprocess : PROCESS
        BEGIN
            clk <= '0';
            wait for CLK_PERIOD/2;
            clk <= '1';
            wait for CLK_PERIOD/2;
        END PROCESS;


        testProcess : PROCESS
        BEGIN

            reset <= '1';
            instruction1 <= "1001000101000010";
            instruction2 <= "1010111111001010";
            wb1 <= '0';
            wb2 <= '0';
            writeReg1 <= "011";
            writeReg2 <= "101"; 
            writeData1 <= x"1234";
            writeData2 <= x"5678"; 

            alu1OperationExpected <= "10010";
            alu2OperationExpected <= "10101";

            inOperationExpected <= '0';

            outPortExpected <= (others => '0');

            Src1Expected <= "001";
            Src2Expected <= "111";
            Dst1Expected <= "010";
            Dst2Expected <= "110";

            src1DataExpected <= (others => '0');
            dst1DataExpected <= (others => '0');
            src2DataExpected <= (others => '0');
            dst2DataExpected <= (others => '0');


            WAIT FOR CLK_period;  
            
            ASSERT(alu1OperationExpected = alu1Operation)        
            REPORT "reset Error"
            SEVERITY ERROR;

            ASSERT(inOperationExpected = inOperation)        
            REPORT "reset Error"
            SEVERITY ERROR;


            ASSERT(outPortExpected = outPort)        
            REPORT "reset Error"
            SEVERITY ERROR;

            ASSERT(Src1Expected = Src1)        
            REPORT "reset Error"
            SEVERITY ERROR;

            ASSERT(Src2Expected = Src2)        
            REPORT "reset Error"
            SEVERITY ERROR;

            ASSERT(Dst1Expected = Dst1)        
            REPORT "reset Error"
            SEVERITY ERROR;

            ASSERT(Dst2Expected = Dst2)        
            REPORT "reset Error"
            SEVERITY ERROR;

            ASSERT(src1DataExpected = src1Data)        
            REPORT "reset Error"
            SEVERITY ERROR;

            ASSERT(dst1DataExpected = dst1Data)        
            REPORT "reset Error"
            SEVERITY ERROR;

            ASSERT(src2DataExpected = src2Data)        
            REPORT "reset Error"
            SEVERITY ERROR;

            ASSERT(dst2DataExpected = dst2Data)        
            REPORT "reset Error"
            SEVERITY ERROR;

            -------------------------------------------------------------------------


            reset <= '0';
            instruction1 <= "1001001101000010";
            instruction2 <= "1010111111001010";
            wb1 <= '1';
            wb2 <= '0';
            writeReg1 <= "011";
            writeReg2 <= "101"; 
            writeData1 <= x"1234";
            writeData2 <= x"5678"; 

            alu1OperationExpected <= "10010";
            alu2OperationExpected <= "10101";

            inOperationExpected <= '0';

            outPortExpected <= (others => '0');

            Src1Expected <= "011";
            Src2Expected <= "111";
            Dst1Expected <= "010";
            Dst2Expected <= "110";

            src1DataExpected <= x"1234";
            dst1DataExpected <= (others => '0');
            src2DataExpected <= (others => '0');
            dst2DataExpected <= (others => '0');


            WAIT FOR CLK_period;  
            
            ASSERT(alu1OperationExpected = alu1Operation)        
            REPORT "WB1 Error"
            SEVERITY ERROR;

            ASSERT(inOperationExpected = inOperation)        
            REPORT "WB1 Error"
            SEVERITY ERROR;


            ASSERT(outPortExpected = outPort)        
            REPORT "WB1 Error"
            SEVERITY ERROR;

            ASSERT(Src1Expected = Src1)        
            REPORT "WB1 Error"
            SEVERITY ERROR;

            ASSERT(Src2Expected = Src2)        
            REPORT "WB1 Error"
            SEVERITY ERROR;

            ASSERT(Dst1Expected = Dst1)        
            REPORT "WB1 Error"
            SEVERITY ERROR;

            ASSERT(Dst2Expected = Dst2)        
            REPORT "WB1 Error"
            SEVERITY ERROR;

            ASSERT(src1DataExpected = src1Data)        
            REPORT "WB1 Error"
            SEVERITY ERROR;

            ASSERT(dst1DataExpected = dst1Data)        
            REPORT "WB1 Error"
            SEVERITY ERROR;

            ASSERT(src2DataExpected = src2Data)        
            REPORT "WB1 Error"
            SEVERITY ERROR;

            ASSERT(dst2DataExpected = dst2Data)        
            REPORT "WB1 Error"
            SEVERITY ERROR;

            -------------------------------------------------------------------------


            reset <= '0';
            instruction1 <= "1001001101000010";
            instruction2 <= "1010111110101010";
            wb1 <= '0';
            wb2 <= '1';
            writeReg1 <= "011";
            writeReg2 <= "101"; 
            writeData1 <= x"1234";
            writeData2 <= x"5678"; 

            alu1OperationExpected <= "10010";
            alu2OperationExpected <= "10101";

            inOperationExpected <= '0';

            outPortExpected <= (others => '0');

            Src1Expected <= "011";
            Src2Expected <= "111";
            Dst1Expected <= "010";
            Dst2Expected <= "101";

            src1DataExpected <= x"1234";
            dst1DataExpected <= (others => '0');
            src2DataExpected <= (others => '0');
            dst2DataExpected <= x"5678";


            WAIT FOR CLK_period;  
            
            ASSERT(alu1OperationExpected = alu1Operation)        
            REPORT "WB2 Error"
            SEVERITY ERROR;

            ASSERT(inOperationExpected = inOperation)        
            REPORT "WB2 Error"
            SEVERITY ERROR;


            ASSERT(outPortExpected = outPort)        
            REPORT "WB2 Error"
            SEVERITY ERROR;

            ASSERT(Src1Expected = Src1)        
            REPORT "WB2 Error"
            SEVERITY ERROR;

            ASSERT(Src2Expected = Src2)        
            REPORT "WB2 Error"
            SEVERITY ERROR;

            ASSERT(Dst1Expected = Dst1)        
            REPORT "WB2 Error"
            SEVERITY ERROR;

            ASSERT(Dst2Expected = Dst2)        
            REPORT "WB2 Error"
            SEVERITY ERROR;

            ASSERT(src1DataExpected = src1Data)        
            REPORT "WB2 Error"
            SEVERITY ERROR;

            ASSERT(dst1DataExpected = dst1Data)        
            REPORT "WB2 Error"
            SEVERITY ERROR;

            ASSERT(src2DataExpected = src2Data)        
            REPORT "WB2 Error"
            SEVERITY ERROR;

            ASSERT(dst2DataExpected = dst2Data)        
            REPORT "WB2 Error"
            SEVERITY ERROR;

            -------------------------------------------------------------------------


            reset <= '0';
            instruction1 <= "1001001101000010";
            instruction2 <= "1010111110101010";
            wb1 <= '1';
            wb2 <= '1';
            writeReg1 <= "011";
            writeReg2 <= "111"; 
            writeData1 <= x"1334";
            writeData2 <= x"5678"; 

            alu1OperationExpected <= "10010";
            alu2OperationExpected <= "10101";

            inOperationExpected <= '0';

            outPortExpected <= (others => '0');

            Src1Expected <= "011";
            Src2Expected <= "111";
            Dst1Expected <= "010";
            Dst2Expected <= "101";

            src1DataExpected <= x"1334";
            dst1DataExpected <= (others => '0');
            src2DataExpected <= x"5678";
            dst2DataExpected <= x"5678";


            WAIT FOR CLK_period;  
            
            ASSERT(alu1OperationExpected = alu1Operation)        
            REPORT "WB2 with WB1 Error"
            SEVERITY ERROR;

            ASSERT(inOperationExpected = inOperation)        
            REPORT "WB2 with WB1 Error"
            SEVERITY ERROR;


            ASSERT(outPortExpected = outPort)        
            REPORT "WB2 with WB1 Error"
            SEVERITY ERROR;

            ASSERT(Src1Expected = Src1)        
            REPORT "WB2 with WB1 Error"
            SEVERITY ERROR;

            ASSERT(Src2Expected = Src2)        
            REPORT "WB2 with WB1 Error"
            SEVERITY ERROR;

            ASSERT(Dst1Expected = Dst1)        
            REPORT "WB2 with WB1 Error"
            SEVERITY ERROR;

            ASSERT(Dst2Expected = Dst2)        
            REPORT "WB2 with WB1 Error"
            SEVERITY ERROR;

            ASSERT(src1DataExpected = src1Data)        
            REPORT "WB2 with WB1 Error"
            SEVERITY ERROR;

            ASSERT(dst1DataExpected = dst1Data)        
            REPORT "WB2 with WB1 Error"
            SEVERITY ERROR;

            ASSERT(src2DataExpected = src2Data)        
            REPORT "WB2 with WB1 Error"
            SEVERITY ERROR;

            ASSERT(dst2DataExpected = dst2Data)        
            REPORT "WB2 with WB1 Error"
            SEVERITY ERROR;

            -------------------------------------------------------------------------

            reset <= '0';
            instruction1 <= "1001001101000010";
            instruction2 <= "1010111110101010";
            wb1 <= '1';
            wb2 <= '1';
            writeReg1 <= "111";
            writeReg2 <= "111"; 
            writeData1 <= x"1334";
            writeData2 <= x"5778"; 

            alu1OperationExpected <= "10010";
            alu2OperationExpected <= "10101";

            inOperationExpected <= '0';

            outPortExpected <= (others => '0');

            Src1Expected <= "011";
            Src2Expected <= "111";
            Dst1Expected <= "010";
            Dst2Expected <= "101";

            src1DataExpected <= x"1334";
            dst1DataExpected <= (others => '0');
            src2DataExpected <= x"5778";
            dst2DataExpected <= x"5678";


            WAIT FOR CLK_period;  
            
            ASSERT(alu1OperationExpected = alu1Operation)        
            REPORT "WB2 with WB1 on same register Error"
            SEVERITY ERROR;

            ASSERT(inOperationExpected = inOperation)        
            REPORT "WB2 with WB1 on same register Error"
            SEVERITY ERROR;


            ASSERT(outPortExpected = outPort)        
            REPORT "WB2 with WB1 on same register Error"
            SEVERITY ERROR;

            ASSERT(Src1Expected = Src1)        
            REPORT "WB2 with WB1 on same register Error"
            SEVERITY ERROR;

            ASSERT(Src2Expected = Src2)        
            REPORT "WB2 with WB1 on same register Error"
            SEVERITY ERROR;

            ASSERT(Dst1Expected = Dst1)        
            REPORT "WB2 with WB1 on same register Error"
            SEVERITY ERROR;

            ASSERT(Dst2Expected = Dst2)        
            REPORT "WB2 with WB1 on same register Error"
            SEVERITY ERROR;

            ASSERT(src1DataExpected = src1Data)        
            REPORT "WB2 with WB1 on same register Error"
            SEVERITY ERROR;

            ASSERT(dst1DataExpected = dst1Data)        
            REPORT "WB2 with WB1 on same register Error"
            SEVERITY ERROR;

            ASSERT(src2DataExpected = src2Data)        
            REPORT "WB2 with WB1 on same register Error"
            SEVERITY ERROR;

            ASSERT(dst2DataExpected = dst2Data)        
            REPORT "WB2 with WB1 on same register Error"
            SEVERITY ERROR;

            -------------------------------------------------------------------------


            reset <= '0';
            instruction1 <= "0011101101000010";
            instruction2 <= "0011011110101010";
            wb1 <= '0';
            wb2 <= '0';
            writeReg1 <= "011";
            writeReg2 <= "111"; 
            writeData1 <= x"1234";
            writeData2 <= x"5678"; 

            alu1OperationExpected <= "00111";
            alu2OperationExpected <= "00110";

            inOperationExpected <= '1';

            outPortExpected <= x"5678";

            Src1Expected <= "011";
            Src2Expected <= "111";
            Dst1Expected <= "010";
            Dst2Expected <= "101";

            src1DataExpected <= x"1334";
            dst1DataExpected <= (others => '0');
            src2DataExpected <= x"5778";
            dst2DataExpected <= x"5678";


            WAIT FOR CLK_period;  
            
            ASSERT(alu1OperationExpected = alu1Operation)        
            REPORT "in out Error"
            SEVERITY ERROR;

            ASSERT(inOperationExpected = inOperation)        
            REPORT "in out Error"
            SEVERITY ERROR;


            ASSERT(outPortExpected = outPort)        
            REPORT "in out Error"
            SEVERITY ERROR;

            ASSERT(Src1Expected = Src1)        
            REPORT "in out Error"
            SEVERITY ERROR;

            ASSERT(Src2Expected = Src2)        
            REPORT "in out Error"
            SEVERITY ERROR;

            ASSERT(Dst1Expected = Dst1)        
            REPORT "in out Error"
            SEVERITY ERROR;

            ASSERT(Dst2Expected = Dst2)        
            REPORT "in out Error"
            SEVERITY ERROR;

            ASSERT(src1DataExpected = src1Data)        
            REPORT "in out Error"
            SEVERITY ERROR;

            ASSERT(dst1DataExpected = dst1Data)        
            REPORT "in out Error"
            SEVERITY ERROR;

            ASSERT(src2DataExpected = src2Data)        
            REPORT "in out Error"
            SEVERITY ERROR;

            ASSERT(dst2DataExpected = dst2Data)        
            REPORT "in out Error"
            SEVERITY ERROR;

            -------------------------------------------------------------------------


            reset <= '0';
            instruction1 <= "0110101101000010";
            instruction2 <= "0111011110101010";
            wb1 <= '0';
            wb2 <= '0';
            writeReg1 <= "011";
            writeReg2 <= "111"; 
            writeData1 <= x"1234";
            writeData2 <= x"5678"; 

            alu1OperationExpected <= "01101";
            alu2OperationExpected <= "01110";

            inOperationExpected <= '0';

            outPortExpected <= x"5678";

            Src1Expected <= "011";
            Src2Expected <= "111";
            Dst1Expected <= "010";
            Dst2Expected <= "101";

            src1DataExpected <= x"1334";
            dst1DataExpected <= x"0002";
            src2DataExpected <= x"5778";
            dst2DataExpected <= x"000A";


            WAIT FOR CLK_period;  
            
            ASSERT(alu1OperationExpected = alu1Operation)        
            REPORT "shift amount alu1 Error"
            SEVERITY ERROR;

            ASSERT(inOperationExpected = inOperation)        
            REPORT "shift amount in Error"
            SEVERITY ERROR;


            ASSERT(outPortExpected = outPort)        
            REPORT "shift amount out port Error"
            SEVERITY ERROR;

            ASSERT(Src1Expected = Src1)        
            REPORT "shift amount src1 Error"
            SEVERITY ERROR;

            ASSERT(Src2Expected = Src2)        
            REPORT "shift amount src2 Error"
            SEVERITY ERROR;

            ASSERT(Dst1Expected = Dst1)        
            REPORT "shift amount dst1 Error"
            SEVERITY ERROR;

            ASSERT(Dst2Expected = Dst2)        
            REPORT "shift amount dst2 Error"
            SEVERITY ERROR;

            ASSERT(src1DataExpected = src1Data)        
            REPORT "shift amount src1 data Error"
            SEVERITY ERROR;

            ASSERT(dst1DataExpected = dst1Data)        
            REPORT "shift amount dst1 data Error"
            SEVERITY ERROR;

            ASSERT(src2DataExpected = src2Data)        
            REPORT "shift amount src2 Error"
            SEVERITY ERROR;

            ASSERT(dst2DataExpected = dst2Data)        
            REPORT "shift amount dst2 Error"
            SEVERITY ERROR;

            -------------------------------------------------------------------------

        

               
            WAIT;
        END PROCESS;	
        
END ARCHITECTURE;