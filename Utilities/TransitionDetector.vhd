LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-- this circuit detect transition of an input and output one till next rising edge if clk is inverted or till next falling edge if clk isn't
-- and it detect transition but there should be speration betweem tranisions of input with one clkcylcle
ENTITY TransitionDetector IS
    PORT (
        edge,clk,rst : IN STD_LOGIC;
        f : INOUT STD_LOGIC
    );
END TransitionDetector;


ARCHITECTURE TransitionDetectorArch OF TransitionDetector IS
    signal d : STD_LOGIC;
BEGIN
    process(clk)
    begin
        IF clk'EVENT AND clk ='0' THEN
            d <= f;
        END IF;
    end process;

    process(edge,rst,d)
    begin
        IF rst = '1' OR d = '1' THEN
            f <= '0';
        ELSIF edge'EVENT AND edge ='1' THEN
            f <= '1' ;
        END IF;
    end process;
END TransitionDetectorArch; 