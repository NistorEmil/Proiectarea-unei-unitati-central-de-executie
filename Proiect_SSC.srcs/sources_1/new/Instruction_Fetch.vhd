----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/19/2023 11:04:03 PM
-- Design Name: 
-- Module Name: Instruction_Fetch - Behavioral
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

entity Instruction_Fetch is
        Port (instruction : in STD_LOGIC_VECTOR (47 downto 0); 
           length: in integer;
           EIP: inout STD_LOGIC_VECTOR (31 downto 0);
           enable: in STD_LOGIC;
           ge: in STD_LOGIC;
           z: in STD_LOGIC
           );
end Instruction_Fetch;

architecture Behavioral of Instruction_Fetch is

begin
    
    EIP_Process:process(instruction, enable)
    begin
    if enable = '1' then
        if (length > 0) then
            case (instruction((length*8)-1 downto (length-1)*8)) is
                when X"33" => EIP <= EIP + 2;   -- XOR ECX, ECX
                when X"81" => EIP <= EIP + 6;   -- ADD EDX, 0
                when X"B8" => EIP <= EIP + 6;   -- MOV ESI, ebx      
                when X"3B" => EIP <= EIP + 2;   -- CMP ECX, [ebx]
                when X"7D" => if ge = '1' then 
                                    EIP <= X"000000" & instruction(7 downto 0);  -- JGE done 
                              else
                                    EIP <= EIP +2;
                              end if;       
                when X"01" => EIP <= EIP + 2; -- ADD ESI, ECX         
                when X"8A" => EIP <= EIP + 2; -- MOV AL, [ESI]
                when X"A8" => EIP <= EIP + 3;   -- TEST AL, 1
                when X"75" => if z = '0' then 
                                    EIP <= X"000000" & instruction(7 downto 0);  -- JNZ next_number
                              else
                                    EIP <= EIP +2;
                              end if; 
                when X"74" =>  if z = '1' then 
                                    EIP <= X"000000" & instruction(7 downto 0);   -- JZ add_to_sum
                               else
                                    EIP <= EIP +2;
                               end if;   
                when X"40" =>  EIP <= EIP + 2;  -- INC ECX
                when X"EB" => EIP <= X"000000" & instruction(7 downto 0);  -- JMP calculate_sum
                when X"00" =>  EIP <= EIP + 2;  -- ADD DL, AL
                when others => EIP <= X"00000000";
            end case;
        else
            EIP <= X"00000000";
        end if;
    end if;
    end process;
    
end Behavioral;