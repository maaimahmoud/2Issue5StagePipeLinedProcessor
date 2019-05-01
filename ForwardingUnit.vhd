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
            Rdst1IEIM,Rdst2IEIM,
            
            WB1, WB2,
            Rdst1IMWB,Rdst2IMWB,
            
            Rdst1,Rdst2,
            Rsrc1,Rsrc2: IN STD_LOGIC_VECTOR(numRegister-1 downto 0) ;
            ---------------------------------------------
            out1: OUT STD_LOGIC_VECTOR(2 downto 0) ;
            out2: OUT STD_LOGIC_VECTOR(2 downto 0) ;
            out3: OUT STD_LOGIC_VECTOR(2 downto 0) ;
            out4: OUT STD_LOGIC_VECTOR(2 downto 0) 

    );
END ENTITY ForwardingUnit;

ARCHITECTURE ForwardingUnitArch of ForwardingUnit is 

BEGIN

    out1<="100" when (Rsrc1=Rdst1IEIM AND MEM1 = '1')
    else "101" when (Rsrc1=Rdst2IEIM AND MEM2 = '1')
    else "110" when (Rsrc1=Rdst1IMWB AND WB1 = '1')
    else "111"when (Rsrc1=Rdst2IMWB AND WB2 = '1')
    else "000";
 
    out2<="100" when ( Rdst1=Rdst1IEIM AND MEM1='1' )
    else "101" when ( Rdst1=Rdst2IEIM AND MEM2='1' )
    else "110" when ( Rdst1=Rdst1IMWB AND WB1='1' )
    else "111"when ( Rdst1=Rdst2IMWB AND WB2='1' )
    else "000";


    out3<="100" when ( Rsrc2=Rdst1IEIM AND MEM1='1' )
    else "101" when ( Rsrc2=Rdst2IEIM AND MEM2='1' )
    else "110" when ( Rsrc2=Rdst1IMWB AND WB1='1' )
    else "111"when ( Rsrc2=Rdst2IMWB AND WB2='1' )
    else "000";

    out4<="100" when ( Rdst2=Rdst1IEIM AND MEM1='1' )
    else "101" when ( Rdst2=Rdst2IEIM AND MEM2='1' )
    else "110" when ( Rdst2=Rdst1IMWB AND WB1='1' )
    else "111"when ( Rdst2=Rdst2IMWB AND WB2='1' )
    else "000";

END ForwardingUnitArch ; -- ForwardingUnitArch
