----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/01/2023 09:06:07 PM
-- Design Name: 
-- Module Name: ALU_Simulation - Behavioral
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

entity ALU_Simulation is
--  Port ( );
end ALU_Simulation;

architecture Behavioral of ALU_Simulation is

component ALU is
    Port (operand1 : in STD_LOGIC_VECTOR (31 downto 0);
           operand2 : in STD_LOGIC_VECTOR (31 downto 0);
           operation : in STD_LOGIC_VECTOR (1 downto 0);
           result : out STD_LOGIC_VECTOR (31 downto 0);
           cout : out STD_LOGIC;
           instruction_type : in STD_LOGIC_VECTOR (1 downto 0);
           EFLAGS: out STD_LOGIC_VECTOR(31 downto 0));
end component;

signal operand1_signal, operand2_signal, result_signal, EFLAGS_signal: STD_LOGIC_VECTOR (31 downto 0);
signal operation_signal, instruction_type_signal: STD_LOGIC_VECTOR (1 downto 0);
signal cout_signal: STD_LOGIC;

begin

    process
    begin
        instruction_type_signal <= "00";
        
        operand1_signal <= X"00000001";
        operand2_signal <= X"00000001";
        operation_signal <= "10";
        wait for 10 ns;
        operand1_signal <= X"00000011";
        operand2_signal <= X"00000000";
        operation_signal <= "00";
        wait for 10 ns;
        operand1_signal <= X"00000011";
        operand2_signal <= X"00000011";
        operation_signal <= "01";
        wait for 10 ns;
    end process;

    ALUU:ALU port map(operand1 => operand1_signal, operand2 => operand2_signal, operation => operation_signal, result => result_signal, cout => cout_signal, instruction_type => instruction_type_signal, EFLAGS => EFLAGS_signal);

end Behavioral;
