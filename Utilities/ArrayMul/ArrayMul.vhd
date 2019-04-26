library IEEE;
USE IEEE.std_logic_1164.all;


-- * Parameter 
--  N = Numbers Size
-- a,b = numbers to multiply 
-- sOut = output of multiplier with Size (2*N)

-- ************** important note *******************
-- do not forget to modify these lines with "*********" before it

Entity ArrayMul is
	generic ( N :Integer :=8) ;
	port (
	a,b: in std_logic_vector(N-1 downto 0);
	sOut: out std_logic_vector (2*N-1 downto 0)
	);

end ArrayMul ;

Architecture ArrayMulArch of ArrayMul is

component WhiteCell
	port (
	a,b,cIn,sIn: in std_logic;
	sOut,cOut: out std_logic
	);

end component;

component GrayCell
	port (
	a,b,cIn,sIn: in std_logic;
	sOut,cOut: out std_logic
	);

end component;

component FullAdder
	PORT( 
    a,b,cin : IN STD_LOGIC;
    s,cout : OUT STD_LOGIC
    );

end component;

--************
type ArrayVector1 is array (N downto 0) of std_logic_vector(8 downto 0);  -- change 4 with N
-- ************
type ArrayVector2 is array (N downto 0) of std_logic_vector(7 downto 0);  -- change 3 with N-1


signal c : ArrayVector2;
signal s : ArrayVector1;

-- ****************
signal carry : std_logic_vector(8 downto 0);                             -- change 4 with N

begin 
  

c(0) <= (others => '0');
s(0) <= (others => '0');
s(N)(N) <= '1';
carry(0)<='1';


  	GENROW: for I in 0 to N-1 generate
	begin
		s(I)(N) <= '0';
		GENCOL: for J in 0 to N-1 generate
		begin

			WHITE: if (    ((I /= N-1) and (J /= N-1))  or ((I = N-1) and (J = N-1))  ) generate
				begin
      				U0: WhiteCell  port map (a(J),b(I),c(I)(J),s(I)(J+1),s(I+1)(J),c(I+1)(J)) ;
				end generate WHITE;
			

			GRAY: if (  ((I = N-1) xor (J = N-1))  ) generate
				begin
      				U1: GrayCell port map(a(J),b(I),c(I)(J),s(I)(J+1),s(I+1)(J),c(I+1)(J)) ;
				end generate GRAY;

			OUTT: if (J = 0) generate
				begin
      				sOut(I)<=s(I+1)(0);
				end generate OUTT;
  		end generate GENCOL;
  	end generate GENROW;


	GEN_LAST: for I in 0 to N-1 generate
	begin
		U2: FullAdder port map( c(N)(I),s(N)(I+1),carry(I),sOut(N+I) , carry(I+1));
	end generate GEN_LAST;




end  ArrayMulArch; 
