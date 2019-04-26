library ieee ;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
Entity NBitSubtractor is
    Generic (wordSize:Integer:=16);
    port(
        x,y:IN std_logic_vector(wordSize-1 downto 0) ;
        bin:In std_logic;
        difference:OUT std_logic_vector(wordSize-1 downto 0) ;
        borrowOut:OUT STD_LOGIC

    )  ;
    END NBitSubtractor;
    ------------------------------------------

    --Arch
    ARCHITECTURE NBitSubtractorArch of NbitSubtractor is
        Signal temp : STD_LOGIC_VECTOR (wordSize-1 DOWNTO 0);
        begin
            f0:entity work.FullSubtractor PORT MAP(x(0),y(0),bin,difference(0),temp(0));
            loop1:for i in 1 to  wordSize-1
               generate 
                fx:Entity work.fullSubtractor  port map(x(i),y(i),temp(i-1),difference(i),temp(i));
                end generate;
                borrowOut<=temp(wordSize-1);
                end NBitSubtractorArch;