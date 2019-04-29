LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.math_real.all;
USE IEEE.numeric_std.all;
use work.Constants.all;

ENTITY ExecuteTest IS
    GENERIC(wordSize : INTEGER := 16);
END ExecuteTest;


ARCHITECTURE ExecuteTestArch OF ExecuteTest IS 
    

    CONSTANT CLK_period : time := 100 ps;

    signal RSrcV1, RDstV1, RSrcV2, RDstV2, MEM1In, MEM2In, WB1In, WB2In: std_logic_vector(wordSize-1 downto 0);

    signal mux1Selector, mux2Selector, mux3Selector, mux4Selector: std_logic_vector(2 downto 0);

    signal alu1Operation, alu2Operation: std_logic_vector(operationSize-1 downto 0);

    signal flagIn: std_logic_vector(flagSize-1 downto 0);

    signal EX1, EX2: std_logic;

    signal ALU1Out, ALU2Out, ALU1OutExpected, ALU2OutExpected: std_logic_vector(wordSize-1 downto 0);

    signal flagOut, flagOutExpected: std_logic_vector(flagSize-1 downto 0);

 

    signal clk, notClk, reset: std_logic;

   
    BEGIN

        executeMap: ENTITY work.ExecuteStage GENERIC MAP (wordSize) PORT MAP (
            RSrcV1, RDstV1,
            RSrcV2, RDstV2,

            MEM1In, MEM2In,
            WB1In, WB2In,

            mux1Selector, mux2Selector,
            mux3Selector, mux4Selector,

            alu1Operation, alu2Operation,

            flagIn,

            EX1, EX2,

            ALU1Out, ALU2Out,

            flagOut
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

            RSrcV1 <= x"0005";
            RDstV1 <= x"000A";
            RSrcV2 <= x"0003";
            RDstV2 <= x"0007";         
            MEM1In <= x"0010";
            MEM2In <= x"0011";
            WB1In <= x"0100";
            WB2In <= x"0105";   
            mux1Selector <= "000";
            mux2Selector <= "000";
            mux3Selector <= "000";
            mux4Selector <= "000";
            alu1Operation <= opNOT;
            alu2Operation <= opINC;
            flagIn <= "000";
            EX1 <= '0';
            EX2 <= '0';
            ALU1OutExpected <= x"FFF5";
            ALU2OutExpected <= x"0008";
            flagOutExpected <= "000";


            WAIT FOR CLK_period;  
            
            ASSERT(ALU1OutExpected = ALU1Out)        
            REPORT "ex1 and ex2 = 0 Error"
            SEVERITY ERROR;

            ASSERT(ALU2OutExpected = ALU2Out)        
            REPORT "ex1 and ex2 = 0 Error"
            SEVERITY ERROR;


            ASSERT(flagOutExpected = flagOut)        
            REPORT "ex1 and ex2 = 0 Error"
            SEVERITY ERROR;

            -------------------------------------------------------------------------


            RSrcV1 <= x"0005";
            RDstV1 <= x"000A";
            RSrcV2 <= x"0003";
            RDstV2 <= x"0007";         
            MEM1In <= x"0010";
            MEM2In <= x"0011";
            WB1In <= x"0100";
            WB2In <= x"0105";   
            mux1Selector <= "000";
            mux2Selector <= "000";
            mux3Selector <= "000";
            mux4Selector <= "000";
            alu1Operation <= opNOT;
            alu2Operation <= opDEC;
            flagIn <= "000";
            EX1 <= '1';
            EX2 <= '0';
            ALU1OutExpected <= x"FFF5";
            ALU2OutExpected <= x"0006";
            flagOutExpected <= "100";


            WAIT FOR CLK_period;  
            
            ASSERT(ALU1OutExpected = ALU1Out)        
            REPORT "flag ex1 Error"
            SEVERITY ERROR;

            ASSERT(ALU2OutExpected = ALU2Out)        
            REPORT "flag ex1 Error"
            SEVERITY ERROR;


            ASSERT(flagOutExpected = flagOut)        
            REPORT "flag ex1 Error"
            SEVERITY ERROR;

            -------------------------------------------------------------------------

            RSrcV1 <= x"0005";
            RDstV1 <= x"000A";
            RSrcV2 <= x"0003";
            RDstV2 <= x"0007";         
            MEM1In <= x"0010";
            MEM2In <= x"0011";
            WB1In <= x"0100";
            WB2In <= x"0105";   
            mux1Selector <= "000";
            mux2Selector <= "000";
            mux3Selector <= "000";
            mux4Selector <= "000";
            alu1Operation <= opMOV;
            alu2Operation <= opADD;
            flagIn <= "000";
            EX1 <= '0';
            EX2 <= '0';
            ALU1OutExpected <= x"0005";
            ALU2OutExpected <= x"000A";
            flagOutExpected <= "000";


            WAIT FOR CLK_period;  
            
            ASSERT(ALU1OutExpected = ALU1Out)        
            REPORT "mov add Error"
            SEVERITY ERROR;

            ASSERT(ALU2OutExpected = ALU2Out)        
            REPORT "mov add Error"
            SEVERITY ERROR;


            ASSERT(flagOutExpected = flagOut)        
            REPORT "mov add Error"
            SEVERITY ERROR;

            -------------------------------------------------------------------------

            RSrcV1 <= x"0005";
            RDstV1 <= x"000A";
            RSrcV2 <= x"0003";
            RDstV2 <= x"0007";         
            MEM1In <= x"0010";
            MEM2In <= x"0011";
            WB1In <= x"0100";
            WB2In <= x"0105";   
            mux1Selector <= "000";
            mux2Selector <= "000";
            mux3Selector <= "001";
            mux4Selector <= "010";
            alu1Operation <= opSUB;
            alu2Operation <= opAND;
            flagIn <= "000";
            EX1 <= '0';
            EX2 <= '0';
            ALU1OutExpected <= x"0005";
            ALU2OutExpected <= x"0010";
            flagOutExpected <= "000";


            WAIT FOR CLK_period;  
            
            ASSERT(ALU1OutExpected = ALU1Out)        
            REPORT "sub and Error"
            SEVERITY ERROR;

            ASSERT(ALU2OutExpected = ALU2Out)        
            REPORT "sub and Error"
            SEVERITY ERROR;


            ASSERT(flagOutExpected = flagOut)        
            REPORT "sub and Error"
            SEVERITY ERROR;

            -------------------------------------------------------------------------

            RSrcV1 <= x"0005";
            RDstV1 <= x"000A";
            RSrcV2 <= x"0003";
            RDstV2 <= x"0007";         
            MEM1In <= x"0010";
            MEM2In <= x"0011";
            WB1In <= x"0100";
            WB2In <= x"0105";   
            mux1Selector <= "100";
            mux2Selector <= "010";
            mux3Selector <= "011";
            mux4Selector <= "000";
            alu1Operation <= opOR;
            alu2Operation <= opSHL;
            flagIn <= "000";
            EX1 <= '0';
            EX2 <= '1';
            ALU1OutExpected <= x"0115";
            ALU2OutExpected <= x"8000";
            flagOutExpected <= "100";


            WAIT FOR CLK_period;  
            
            ASSERT(ALU1OutExpected = ALU1Out)        
            REPORT "or SHL Error"
            SEVERITY ERROR;

            ASSERT(ALU2OutExpected = ALU2Out)        
            REPORT "or SHL Error"
            SEVERITY ERROR;


            ASSERT(flagOutExpected = flagOut)        
            REPORT "or SHL Error"
            SEVERITY ERROR;

            -------------------------------------------------------------------------

            RSrcV1 <= x"0005";
            RDstV1 <= x"0002";
            RSrcV2 <= x"0003";
            RDstV2 <= x"0007";         
            MEM1In <= x"0010";
            MEM2In <= x"0011";
            WB1In <= x"0100";
            WB2In <= x"0105";   
            mux1Selector <= "100";
            mux2Selector <= "000";
            mux3Selector <= "011";
            mux4Selector <= "000";
            alu1Operation <= opSHR;
            alu2Operation <= opSETC;
            flagIn <= "000";
            EX1 <= '0';
            EX2 <= '1';
            ALU1OutExpected <= x"0041";
            ALU2OutExpected <= x"0000";
            flagOutExpected <= "010";


            WAIT FOR CLK_period;  
            
            ASSERT(ALU1OutExpected = ALU1Out)        
            REPORT "SHR setC Error"
            SEVERITY ERROR;

            ASSERT(ALU2OutExpected = ALU2Out)        
            REPORT "SHR setC Error"
            SEVERITY ERROR;


            ASSERT(flagOutExpected = flagOut)        
            REPORT "SHR setC Error"
            SEVERITY ERROR;

            -------------------------------------------------------------------------


            
               
            WAIT;
        END PROCESS;	
        
END ARCHITECTURE;