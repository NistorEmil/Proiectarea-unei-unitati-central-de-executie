----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/13/2023 03:54:39 PM
-- Design Name: 
-- Module Name: WriteBack - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity WriteBack is
    Port (instruction : in STD_LOGIC_VECTOR (47 downto 0);
          length: in integer;
           regWrite0: in STD_LOGIC;
           regWrite1: in STD_LOGIC;
           regWrite2: in STD_LOGIC;
           regWrite3: in STD_LOGIC;
           regWrite4: in STD_LOGIC;
           regWrite5: in STD_LOGIC;
           regWrite6: in STD_LOGIC;
          adress: out STD_LOGIC_VECTOR(2 downto 0);
          data_length: out integer;
          enable: in STD_LOGIC;
          wb:out STD_LOGIC);
end WriteBack;

architecture Behavioral of WriteBack is

signal instruction_length: integer:=2;

begin

    Adress_Process:process(regWrite0, regWrite1, regWrite2, regWrite3, regWrite4, regWrite5, regWrite6, instruction)
    begin
    if enable = '1' then
        if regWrite0 = '1' or regWrite1 = '1' or  regWrite2 = '1' or  regWrite3 = '1' or  regWrite4 = '1' or  regWrite5 = '1' or  regWrite6 = '1' then
            if (length > 0) then
                case (instruction((length*8)-1 downto (length-1)*8)) is
                    when X"33" => adress <= "001";   -- XOR ECX, ECX
                                data_length <= 32;
                    when X"81" => adress <= "010";   -- ADD EDX, 0
                                data_length <= 32;
                    when X"B8" => adress <= instruction(((length-1)*8)-3 downto (length-2)*8+3);   -- MOV ESI, array
                                data_length <= 32;           
                    when X"01" => adress <= "110"; -- ADD ESI, ECX   
                                data_length <= 32;      
                    when X"8A" => adress <= "000"; -- MOV AL, [ESI]
                                data_length <= 8;
                    when X"40" => adress <= "001";  -- INC ECX
                                data_length <= 32;
                    when X"00" => adress <= "010";  -- ADD DL, AL
                                data_length <= 8;
                    when others => adress <= "111";
                                data_length <= 32;
                end case;
            else
                case (instruction((instruction_length*8)-1 downto (instruction_length-1)*8)) is
                    when X"33" => adress <= "001";   -- XOR ECX, ECX
                                data_length <= 32;
                    when X"81" => adress <= "010";   -- ADD EDX, 0
                                data_length <= 32;
                    when X"B8" => adress <= "110";   -- MOV ESI, array
                                data_length <= 32;            
                    when X"01" => adress <= "110"; -- ADD ESI, ECX   
                                data_length <= 32;      
                    when X"8A" => adress <= "000"; -- MOV AL, [ESI]
                                data_length <= 8;
                    when X"40" => adress <= "001";  -- INC ECX
                                data_length <= 32;
                    when X"00" => adress <= "010";  -- ADD DL, AL
                                data_length <= 8;
                    when others => adress <= "000";
                                data_length <= 32;
                end case;
            end if;
            wb <= '1';
        end if;
    end if;
    end process;
    
end Behavioral;
