LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
USE work.constants.ALL;
--------------------------------------------------------------------------------
--Forwarding unit takes as input the The Rdst1 and Rdst2 from IE/IM,Rdst1 and Rdst2 from IM/WB and Rdst1,Rsrc1,Rdst2,Rsrc2 from IF/IE
--Output 4 signals for the four operands of the two ALUs,each signal is three bits 
--for every output signal the bit(2) indicates whether we need forwarding or not
--bit(1)&bit(0) indicates which input to the MUX to take  
-----------------------------------------------------------------------------------


ENTITY ForwardingUnit IS
    Port(
            MEM1, MEM2,
            WB1, WB2: STD_LOGIC;

            Rdst1IEIM,Rdst2IEIM,
            
            Rdst1IMWB,Rdst2IMWB,
            
            Rdst1,Rdst2,
            Rsrc1,Rsrc2: IN STD_LOGIC_VECTOR(numRegister-1 downto 0) ;

            opCode1, opCode2: in std_logic_vector(operationSize-1 downto 0) ;
            ---------------------------------------------
            out1: OUT STD_LOGIC_VECTOR(2 downto 0) ;
            out2: OUT STD_LOGIC_VECTOR(2 downto 0) ;
            out3: OUT STD_LOGIC_VECTOR(2 downto 0) ;
            out4: OUT STD_LOGIC_VECTOR(2 downto 0) 

    );
END ENTITY ForwardingUnit;

ARCHITECTURE ForwardingUnitArch of ForwardingUnit is 

BEGIN

    out1<="010" when (Rsrc1=Rdst2IEIM AND MEM2 = '1')
    else "001" when (Rsrc1=Rdst1IEIM AND MEM1 = '1')
    else "100"when (Rsrc1=Rdst2IMWB AND WB2 = '1')
    else "011" when (Rsrc1=Rdst1IMWB AND WB1 = '1')
    else "000";
 
    out2<="010" when ( Rdst1=Rdst2IEIM AND MEM2='1' and opCode1 /= opSHL and opCode1 /= opSHR)
    else "001" when ( Rdst1=Rdst1IEIM AND MEM1='1' and opCode1 /= opSHL and opCode1 /= opSHR )
    else "100"when ( Rdst1=Rdst2IMWB AND WB2='1' and opCode1 /= opSHL and opCode1 /= opSHR )
    else "011" when ( Rdst1=Rdst1IMWB AND WB1='1' and opCode1 /= opSHL and opCode1 /= opSHR )
    else "000";


    out3<="001" when ( Rsrc2=Rdst1IEIM AND MEM1='1' )
    else "010" when ( Rsrc2=Rdst2IEIM AND MEM2='1' )
    else "100"when ( Rsrc2=Rdst2IMWB AND WB2='1' )
    else "011" when ( Rsrc2=Rdst1IMWB AND WB1='1' )
    else "000";

    out4<="010" when ( Rdst2=Rdst2IEIM AND MEM2='1' and opCode2 /= opSHL and opCode2 /= opSHR )
    else "001" when ( Rdst2=Rdst1IEIM AND MEM1='1' and opCode2 /= opSHL and opCode2 /= opSHR )
    else "100"when ( Rdst2=Rdst2IMWB AND WB2='1'  and opCode2 /= opSHL and opCode2 /= opSHR)
    else "011" when ( Rdst2=Rdst1IMWB AND WB1='1' and opCode2 /= opSHL and opCode2 /= opSHR )
    else "000";

END ForwardingUnitArch ; -- ForwardingUnitArch
