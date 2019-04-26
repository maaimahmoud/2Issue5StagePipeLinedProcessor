LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.numeric_std.all; 
Entity TestBenchArrayMul is
	generic ( N :Integer :=8) ; 

end TestBenchArrayMul ;

Architecture TestBenchArrayMulArch of TestBenchArrayMul is


component ArrayMul

	generic ( N :Integer :=8) ;
	port (
	a,b: in std_logic_vector(N-1 downto 0);
	sOut: out std_logic_vector (2*N-1 downto 0)
	);


end component;

signal a,b:  std_logic_vector(N-1 downto 0);
signal output:  std_logic_vector(2*N-1 downto 0);

begin 

	
uuu : ArrayMul generic map (N) port map(a,b,output);


STIM : process 
	variable k,j : integer ;
	variable result:  std_logic_vector(2*N-1 downto 0);
begin
	  k := -(2**(N-1));
	  NUM1_LOOP : while k <= (2**(N-1))-1 loop
	  j := -(2**(N-1));
      	  a <= std_logic_vector(to_signed(k, a'length));
		NUM2_LOOP : while j <= (2**(N-1))-1 loop
      	  	b <= std_logic_vector(to_signed(j, a'length));               
		wait for 5 ns ;
		result :=  std_logic_vector(to_signed(k*j, result'length));
		assert (output = result) report "output =   " & to_string(output) &"  not equal to expected  "& to_string(result)  severity error;
                j:=j+1;
          	end loop NUM2_LOOP;
	  k:=k+1;	
          end loop NUM1_LOOP;

wait;	
end process STIM;

end TestBenchArrayMulArch; 