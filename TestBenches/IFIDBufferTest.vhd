LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.math_real.all;
USE IEEE.numeric_std.all;

ENTITY IFIDBufferTest IS
    GENERIC(wordSize : INTEGER := 16);
END IFIDBufferTest;


ARCHITECTURE IFIDBufferTestArch OF IFIDBufferTest IS 
    

    CONSTANT CLK_period : time := 100 ps;

    SIGNAL enable: STD_LOGIC;
    signal pcIn, pc, pcExpected: std_logic_vector((2*wordSize)-1 downto 0) ;
    signal instruction1In, instruction2In, instruction1Out, instruction2Out, instruction1OutExpected, instruction2OutExpected: std_logic_vector(wordSize-1 downto 0) ;
    

    signal clk, notClk, reset: std_logic;

   
    BEGIN

        notClk <= not clk;

        FetchDecodeBufferMap: ENTITY work.FetchDecodeBuffer GENERIC MAP (wordSize) PORT MAP (
            clk => notClk, reset => reset,
            bufferEn  => enable,
            pcIn =>pcIn,
            instruction1In =>instruction1In , instruction2In =>instruction2In,
            pc =>pc,
            instruction1Out =>instruction1Out ,instruction2Out =>instruction2Out
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
            enable <= '0';
            pcIn <= x"12345678";
            instruction1In <= x"1234";
            instruction2In <= x"5678";
            pcExpected <= (others => '0');
            instruction1OutExpected <= (others => '0');
            instruction2OutExpected <= (others => '0');


            WAIT FOR CLK_period;  
            
            ASSERT(pc = pcExpected)        
            REPORT "reset Error"
            SEVERITY ERROR;

            ASSERT(instruction1Out = instruction1OutExpected)        
            REPORT "reset Error"
            SEVERITY ERROR;

            ASSERT(instruction2Out = instruction2OutExpected)        
            REPORT "reset Error"
            SEVERITY ERROR;

            -------------------------------------------------------------------------


            reset <= '0';
            enable <= '1';
            pcIn <= x"12345678";
            instruction1In <= x"1234";
            instruction2In <= x"5678";
            pcExpected <= x"12345678";
            instruction1OutExpected <= x"1234";
            instruction2OutExpected <= x"5678";


            WAIT FOR CLK_period;  
            
            ASSERT(pc = pcExpected)        
            REPORT "buffer Error"
            SEVERITY ERROR;

            ASSERT(instruction1Out = instruction1OutExpected)        
            REPORT "buffer Error"
            SEVERITY ERROR;

            ASSERT(instruction2Out = instruction2OutExpected)        
            REPORT "buffer Error"
            SEVERITY ERROR;

            -------------------------------------------------------------------------


            reset <= '0';
            enable <= '0';
            pcIn <= x"56785678";
            instruction1In <= x"5678";
            instruction2In <= x"1234";
            pcExpected <= x"12345678";
            instruction1OutExpected <= x"1234";
            instruction2OutExpected <= x"5678";


            WAIT FOR CLK_period;  
            
            ASSERT(pc = pcExpected)        
            REPORT "enable zero Error"
            SEVERITY ERROR;

            ASSERT(instruction1Out = instruction1OutExpected)        
            REPORT "enable zero Error"
            SEVERITY ERROR;

            ASSERT(instruction2Out = instruction2OutExpected)        
            REPORT "enable zero Error"
            SEVERITY ERROR;

            -------------------------------------------------------------------------


            reset <= '0';
            enable <= '1';
            pcIn <= x"56785678";
            instruction1In <= x"5678";
            instruction2In <= x"1234";
            pcExpected <= x"56785678";
            instruction1OutExpected <= x"5678";
            instruction2OutExpected <= x"1234";


            WAIT FOR CLK_period;  
            
            ASSERT(pc = pcExpected)        
            REPORT "buffer Error"
            SEVERITY ERROR;

            ASSERT(instruction1Out = instruction1OutExpected)        
            REPORT "buffer Error"
            SEVERITY ERROR;

            ASSERT(instruction2Out = instruction2OutExpected)        
            REPORT "buffer Error"
            SEVERITY ERROR;

            -------------------------------------------------------------------------


            
            reset <= '0';
            enable <= '1';
            pcIn <= x"56785688";
            instruction1In <= x"5978";
            instruction2In <= x"1334";
            pcExpected <= x"56785688";
            instruction1OutExpected <= x"5978";
            instruction2OutExpected <= x"1334";


            WAIT FOR CLK_period;  
            
            ASSERT(pc = pcExpected)        
            REPORT "buffer Error"
            SEVERITY ERROR;

            ASSERT(instruction1Out = instruction1OutExpected)        
            REPORT "buffer Error"
            SEVERITY ERROR;

            ASSERT(instruction2Out = instruction2OutExpected)        
            REPORT "buffer Error"
            SEVERITY ERROR;

            -------------------------------------------------------------------------

               
            WAIT;
        END PROCESS;	
        
END ARCHITECTURE;