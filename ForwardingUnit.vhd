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


Entity ForwardingUnit is
    Port(
            Rdst1IEIM,Rdst2IEIM,Rdst1IMWB,Rdst2IMWB,Rdst1,Rdst2,Rsrc1,Rsrc2: in std_logic_vector(numRegister-1 downto 0) ;
            out1: OUT std_logic_vector(2 downto 0) ;
            out2: OUT std_logic_vector(2 downto 0) ;
            out3: OUT std_logic_vector(2 downto 0) ;
            out4: OUT std_logic_vector(2 downto 0) 

    );
END Entity ForwardingUnit;

architecture ForwardingUnitArch of ForwardingUnit is 
begin
    out1<="100" when Rsrc1=Rdst1IEIM
    else "101" when Rsrc1=Rdst2IEIM
    else "110" when Rsrc1=Rdst1IMWB
    else "111"when Rsrc1=Rdst2IMWB
    else "000";
 
    out2<="100" when Rdst1=Rdst1IEIM
    else "101" when Rdst1=Rdst2IEIM
    else "110" when Rdst1=Rdst1IMWB
    else "111"when Rdst1=Rdst2IMWB
    else "000";


    out3<="100" when Rsrc2=Rdst1IEIM
    else "101" when Rsrc2=Rdst2IEIM
    else "110" when Rsrc2=Rdst1IMWB
    else "111"when Rsrc2=Rdst2IMWB
    else "000";

    out4<="100" when Rdst2=Rdst1IEIM
    else "101" when Rdst2=Rdst2IEIM
    else "110" when Rdst2=Rdst1IMWB
    else "111"when Rdst2=Rdst2IMWB
    else "000";

end ForwardingUnitArch ; -- ForwardingUnitArch
