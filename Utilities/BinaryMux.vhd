LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-- this mux select only between two values with n bits in length
ENTITY BinaryMux IS
    GENERIC (n :INteger := 16);
    PORT (
        a,b :IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
        sel : IN STD_LOGIC;
        f :OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
    );
END BinaryMux;


ARCHITECTURE BinaryMuxArch OF BinaryMux IS
BEGIN
    f <= a WHEN sel ='0' ELSE b;
END BinaryMuxArch; 