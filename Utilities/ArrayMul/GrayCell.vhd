library IEEE;
USE IEEE.std_logic_1164.all;
Entity GrayCell is
	port (
	a,b,cIn,sIn: in std_logic;
	sOut,cOut: out std_logic
	);

end GrayCell ;

Architecture GrayCellArch of GrayCell is

component FullAdder
   PORT( 
    a,b,cin : IN STD_LOGIC;
    s,cout : OUT STD_LOGIC
    );
end component;

signal temp :std_logic ;

begin
U0: FullAdder port map (temp,cIn,sIn,sOut,cOut);
 temp <= not (a and b);



end GrayCellArch; 