----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/23/2023 11:24:31 AM
-- Design Name: 
-- Module Name: Phase_Generator - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Unit_Control is
    Port ( instruction : in STD_LOGIC_VECTOR (47 downto 0);
           length: in integer;
           regWrite0: out STD_LOGIC;
           regWrite1: out STD_LOGIC;
           regWrite2: out STD_LOGIC;
           regWrite3: out STD_LOGIC;
           regWrite4: out STD_LOGIC;
           regWrite5: out STD_LOGIC;
           regWrite6: out STD_LOGIC;
           op2_isMemory: out STD_LOGIC;
           jump: out STD_LOGIC
           );
end Unit_Control;

architecture Behavioral of Unit_Control is

signal instruction_length: integer:=2;

begin

    process(instruction)
    begin
    if (length > 0) then
        case instruction((length*8)-1 downto (length-1)*8) is
            when X"33" => regWrite0 <= '1';
                          op2_isMemory <= '0';
            when X"81" => regWrite1 <= '1';
                          op2_isMemory <= '0';
            when X"01" => regWrite2 <= '1';
                          op2_isMemory <= '0';
            when X"00" => regWrite3 <= '1';
                          op2_isMemory <= '0';
            when X"40" => regWrite4 <= '1';
                          op2_isMemory <= '0';
            when X"B8" => op2_isMemory <= '0';
                          regWrite5 <= '1';
                          
            when X"8A" => op2_isMemory <= '1'; 
                        regWrite6 <= '1';
            when X"3B" => op2_isMemory <= '1';
                          regWrite0 <= '0';
                          regWrite1 <= '0';
                          regWrite2 <= '0';
                          regWrite3 <= '0';
                          regWrite4 <= '0';
                          regWrite5 <= '0';
                          regWrite6 <= '0';
            when X"7D" | X"74" | X"75" | X"EB" => 
                          regWrite0 <= '0';
                          regWrite1 <= '0';
                          regWrite2 <= '0';
                          regWrite3 <= '0';
                          regWrite4 <= '0';
                          regWrite5 <= '0';
                          regWrite6 <= '0';
                           op2_isMemory <= '0';
                            jump <= '1';
            when others => 
                           op2_isMemory <= '0';
                           jump <= '0';
        end case;
    else
        case instruction((instruction_length*8)-1 downto (instruction_length-1)*8) is
            when X"33" => regWrite0 <= '1';
                          op2_isMemory <= '0';
            when X"81" => regWrite1 <= '1';
                          op2_isMemory <= '0';
            when X"01" => regWrite2 <= '1';
                          op2_isMemory <= '0';
            when X"00" => regWrite3 <= '1';
                          op2_isMemory <= '0';
            when X"40" => regWrite4 <= '1';
                          op2_isMemory <= '0';
            when X"B8" => op2_isMemory <= '0';
                          regWrite5 <= '1';
                          
            when X"8A" => op2_isMemory <= '1'; 
                        regWrite6 <= '1';
            when X"3B" => op2_isMemory <= '1';
                          regWrite0 <= '0';
                          regWrite1 <= '0';
                          regWrite2 <= '0';
                          regWrite3 <= '0';
                          regWrite4 <= '0';
                          regWrite5 <= '0';
                          regWrite6 <= '0';
            when X"7D" | X"74" | X"75" | X"EB" => 
                          regWrite0 <= '0';
                          regWrite1 <= '0';
                          regWrite2 <= '0';
                          regWrite3 <= '0';
                          regWrite4 <= '0';
                          regWrite5 <= '0';
                          regWrite6 <= '0';
                           op2_isMemory <= '0';
                            jump <= '1';
            when others => 
                           op2_isMemory <= '0';
                           jump <= '0';
        end case;
    end if;
    end process;

end Behavioral;
