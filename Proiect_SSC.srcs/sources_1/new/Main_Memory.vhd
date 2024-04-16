----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/18/2023 11:58:43 PM
-- Design Name: 
-- Module Name: Main_Memory - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Main_Memory is
    Port (clk : in STD_LOGIC;
           enable : in STD_LOGIC;
           Write : in STD_LOGIC;
           Adress1 : in STD_LOGIC_VECTOR (31 downto 0);
           Adress2: in STD_LOGIC_VECTOR (31 downto 0);
           WriteAdress: in STD_LOGIC_VECTOR (31 downto 0);
           WriteData : in STD_LOGIC_VECTOR (31 downto 0);
           Data1 : out STD_LOGIC_VECTOR (47 downto 0);
           Data2 : out STD_LOGIC_VECTOR (31 downto 0);
           Data_length: out integer);
end Main_Memory;

architecture Behavioral of Main_Memory is

type mem is array(0 to 127) of std_logic_vector(7 downto 0);
signal RAM: mem:=(
                    -- code
                  B"00110011", B"11_001_001", -- 0 -- (0)
                  B"10000001", B"11_010_000", B"00000000", B"00000000", B"00000000", B"00000000", -- 1 -- (2)
                  B"10111000", B"11_110_000", B"00000000", B"00000000", B"00000000", B"01001000", -- 2 -- (8)
                  B"10111000", B"11_011_000", B"00000000", B"00000000", B"00000000", B"01000000", -- 3 -- (14)
                  B"00111011", B"00_001_011", -- 4 -- (20)
                  B"01111101", B"00110000", -- 5 -- (22)
                  B"00000001", B"11_110_001", -- 6 -- (24)
                  B"10001010", B"00_000_110", -- 7 -- (26)
                  B"10101000", B"11_000_000", B"00000001", -- 9 -- (28)
                  B"01110101", B"00100110", -- 10 -- (31)
                  B"10101000", B"11_000_000", B"00000001", -- 11 -- (33)
                  B"01110100", B"00101010", -- 12 -- (36)
                  B"01000000", B"11_001_000", -- 13 -- (38)
                  B"11101011", B"00001000", -- 14 -- (40)
                  B"00000000", B"11_010_000", -- 15 -- (42)
                  B"01000000", B"11_001_000", -- 16 -- (44)
                  B"11101011", B"00001000", -- 17 -- (46)
                  
                  X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",X"00", X"00", X"00", X"00", X"00", X"00",  --(48)
                    -- data
                  X"00", X"00", X"00", X"28", -- N = 4 (bytes) * 10 (numere) -- (64)
                  X"00", X"00", X"00", X"00", -- SUMA = 0 --(68)
                  X"00", X"00", X"00", X"01",  --(72)
                  X"00", X"00", X"00", X"02",
                  X"00", X"00", X"00", X"03",
                  X"00", X"00", X"00", X"04",
                  X"00", X"00", X"00", X"05",
                  X"00", X"00", X"00", X"06",
                  X"00", X"00", X"00", X"07",
                  X"00", X"00", X"00", X"08",
                  X"00", X"00", X"00", X"09",
                  X"00", X"00", X"00", X"0A",
                  others => X"00"
                  );

begin
 
    instruction:process(Adress1, enable, clk)
    begin
    if enable = '1' then
        if rising_edge(clk) then
            case RAM(conv_integer(Adress1(6 downto 0))) is
                when X"33" => Data1 <= X"00000000" & RAM(conv_integer(Adress1(6 downto 0))) & RAM(conv_integer(Adress1(6 downto 0)) + 1);   -- XOR ECX, ECX
                            Data_length <= 2;
                when X"81" => Data1 <= RAM(conv_integer(Adress1(6 downto 0))) & RAM(conv_integer(Adress1(6 downto 0)) + 1) & RAM(conv_integer(Adress1(6 downto 0)) + 2) & RAM(conv_integer(Adress1(6 downto 0)) + 3) & RAM(conv_integer(Adress1(6 downto 0)) + 4) & RAM(conv_integer(Adress1(6 downto 0)) + 5);   -- ADD EDX, 0
                            Data_length <= 6;
                when X"B8" => Data1 <= RAM(conv_integer(Adress1(6 downto 0))) & RAM(conv_integer(Adress1(6 downto 0)) + 1) & RAM(conv_integer(Adress1(6 downto 0)) + 2) & RAM(conv_integer(Adress1(6 downto 0)) + 3) & RAM(conv_integer(Adress1(6 downto 0)) + 4) & RAM(conv_integer(Adress1(6 downto 0)) + 5);   -- MOV ESI, array
                            Data_length <= 6;
                when X"3B" => Data1 <= X"00000000" & RAM(conv_integer(Adress1(6 downto 0))) & RAM(conv_integer(Adress1(6 downto 0)) + 1);   -- CMP ECX, n
                            Data_length <= 2;
                when X"7D" => Data1 <= X"00000000" & RAM(conv_integer(Adress1(6 downto 0))) & RAM(conv_integer(Adress1(6 downto 0)) + 1);  -- JGE done
                            Data_length <= 2;
                when X"01" => Data1 <= X"00000000" & RAM(conv_integer(Adress1(6 downto 0))) & RAM(conv_integer(Adress1(6 downto 0)) + 1); -- ADD ESI, ECX
                            Data_length <= 2;
                when X"8A" => Data1 <= X"00000000" & RAM(conv_integer(Adress1(6 downto 0))) & RAM(conv_integer(Adress1(6 downto 0)) + 1); -- MOV AL, [ESI]
                            Data_length <= 2;
                when X"A8" => Data1 <= X"000000" & RAM(conv_integer(Adress1(6 downto 0))) & RAM(conv_integer(Adress1(6 downto 0)) + 1) & RAM(conv_integer(Adress1(6 downto 0)) + 2);   -- TEST AL, 1
                            Data_length <= 3;
                when X"75" => Data1 <= X"00000000" & RAM(conv_integer(Adress1(6 downto 0))) & RAM(conv_integer(Adress1(6 downto 0)) + 1);  -- JNZ next_number
                            Data_length <= 2;
                when X"74" => Data1 <= X"00000000" & RAM(conv_integer(Adress1(6 downto 0))) & RAM(conv_integer(Adress1(6 downto 0)) + 1);   -- JZ add_to_sum
                            Data_length <= 2;
                when X"40" => Data1 <= X"00000000" & RAM(conv_integer(Adress1(6 downto 0))) & RAM(conv_integer(Adress1(6 downto 0)) + 1);  -- INC ECX
                            Data_length <= 2;
                when X"EB" => Data1 <= X"00000000" & RAM(conv_integer(Adress1(6 downto 0))) & RAM(conv_integer(Adress1(6 downto 0)) + 1);  -- JMP calculate_sum
                            Data_length <= 2;
                when X"00" => Data1 <= X"00000000" & RAM(conv_integer(Adress1(6 downto 0))) & RAM(conv_integer(Adress1(6 downto 0)) + 1);  -- ADD DL, AL
                             Data_length <= 2;
                when others => Data1 <= X"000000000000";
            end case;
        end if;
    end if;
    end process;
    
    op2:process(clk, Adress2)
    begin
        if enable = '1' then
            if rising_edge(clk) then
                if RAM(conv_integer(Adress1(6 downto 0))) = X"3B" or RAM(conv_integer(Adress1(6 downto 0))) = X"8A" then
                    Data2 <= RAM(conv_integer(Adress2(6 downto 0))) & RAM(conv_integer(Adress2(6 downto 0)) + 1) & RAM(conv_integer(Adress2(6 downto 0)) + 2) & RAM(conv_integer(Adress2(6 downto 0)) + 3);
                end if;
            end if;
        end if;
    end process;
    
    process(clk, Write)
    begin
        if enable = '1' and Write = '1'  then
            if rising_edge(clk) then
                RAM(conv_integer(WriteAdress(4 downto 0))) <= WriteData(31 downto 24);
                RAM(conv_integer(WriteAdress(4 downto 0)) + 1) <= WriteData(23 downto 16);
                RAM(conv_integer(WriteAdress(4 downto 0)) + 2) <= WriteData(15 downto 8);
                RAM(conv_integer(WriteAdress(4 downto 0)) + 3) <= WriteData(7 downto 0);
            end if;
        end if;
    end process;

end Behavioral;
