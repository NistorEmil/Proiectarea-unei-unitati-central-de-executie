----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/01/2023 08:49:16 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
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

entity ALU is
    Port ( operand1 : in STD_LOGIC_VECTOR (31 downto 0);
           operand2 : in STD_LOGIC_VECTOR (31 downto 0);
           operand2_aux: in STD_LOGIC_VECTOR (31 downto 0);
           operand2_isMemory: in STD_LOGIC;
           operation : in STD_LOGIC_VECTOR (2 downto 0);
           result : out STD_LOGIC_VECTOR (31 downto 0);
           EFLAGS: out STD_LOGIC_VECTOR(31 downto 0);
           enable: in STD_LOGIC);
end ALU;

architecture Behavioral of ALU is

signal result_signal: STD_LOGIC_VECTOR (31 downto 0);

begin

    process(operand1, operand2, operation)  
    begin
    if enable = '1' then
        case operation is
            when "000" =>
                if operand2_isMemory = '1' then
                    result <= operand1 + operand2_aux;
                    result_signal <= operand1 + operand2_aux; -- adunare
                else
                    result <= operand1 + operand2;
                    result_signal <= operand1 + operand2; -- adunare
                end if;
            when "001" =>
                if operand2_isMemory = '1' then
                    result <= operand1 - operand2_aux;
                    result_signal <= operand1 - operand2_aux; -- scadere
                else
                    result <= operand1 - operand2;
                    result_signal <= operand1 - operand2; -- scadere
                end if;
            when "010" =>
                result <= operand1 xor operand2;
                result_signal <= operand1 xor operand2; -- xor
            when "011" =>
                result <= operand1 and operand2;
                result_signal <= operand1 and operand2; -- xor
            when others =>
                if operand2_isMemory = '1' then
                    result <= operand2_aux;
                    result_signal <= operand2_aux;
                else
                    result <= operand2;
                    result_signal <= operand2;
                end if;
        end case;
    end if;
    end process;

    process(result_signal)
    begin
    if enable = '1' then
      -- Actualizare EFLAGS
        if operand2_isMemory = '1' then
            if operand1 >= operand2_aux then
                EFLAGS(1) <= '1'; -- GE
            else
                EFLAGS(1) <= '0';
            end if;
            if result_signal = X"00000000" then
                EFLAGS(6) <= '1'; -- ZF
            else 
                EFLAGS(6) <= '0'; 
            end if;
        else
            if result_signal = X"00000000" then
                EFLAGS(6) <= '1'; -- ZF
            else 
                EFLAGS(6) <= '0'; 
            end if;
            if result_signal(31) = '1' then
                EFLAGS(7) <= '1'; -- SF
            else 
                EFLAGS(7) <= '0'; 
            end if;
            if operand1 >= operand2 then
                EFLAGS(1) <= '1'; -- GE
            else
                EFLAGS(1) <= '0';
            end if;
        end if;
    end if;
    end process;

end Behavioral;

