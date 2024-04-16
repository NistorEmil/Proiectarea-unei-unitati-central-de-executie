----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/01/2023 06:39:21 PM
-- Design Name: 
-- Module Name: Decode_Simulation - Behavioral
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

entity Decode_Simulation is
--  Port ( );
end Decode_Simulation;

architecture Behavioral of Decode_Simulation is

component Instruction_Decode is
    Port(clk: in std_logic;
        reset: in std_logic;
        instruction: in std_logic_vector(47 downto 0);
        length: in integer;
        operation: out std_logic_vector(1 downto 0);
        operand_1: out std_logic_vector(31 downto 0);
        operand_2: out std_logic_vector(31 downto 0);
        EAX, EBX, ECX, EDX: in std_logic_vector(31 downto 0); 
        ESP, EBP, ESI, EDI: in std_logic_vector(31 downto 0);
        operand_2_isMemory: out std_logic;
        instruction_type: out std_logic_vector(1 downto 0)
    );
end component;

signal instruction_signal: std_logic_vector(47 downto 0);
signal operand_1_signal, operand_2_signal, EAX_signal, EBX_signal, ECX_signal, EDX_signal:std_logic_vector(31 downto 0);
signal ESP_signal, EBP_signal, ESI_signal, EDI_signal:std_logic_vector(31 downto 0);
signal length_signal: integer:=2;
signal operation_signal, instruction_type_signal: std_logic_vector(1 downto 0);
signal operand_2_isMemory_signal, clk_signal, reset_signal: std_logic;

begin

    process
    begin
        clk_signal <= '0';
        wait for 5 ns;
        clk_signal <= '1';
        wait for 5 ns;        
    end process;

    process
    begin
        ECX_signal <= X"00000001";
        EDX_signal <= X"00000011";
        ESI_signal <= X"00000100";
        EBX_signal <= X"00001001";
        EAX_signal <= X"00000000";
        ESP_signal <= X"00000000";
        EBP_signal <= X"00000000";
        EDI_signal <= X"00000000";
        reset_signal <= '0';
        
        instruction_signal <= X"00000000" & B"00110011_11_001_001";
        length_signal <= 2;
        wait for 10 ns;
        instruction_signal <= B"10000001" & B"11_010_000" & B"00000000" & B"00000000" & B"00000000" & B"00000000";
        length_signal <= 6;
        wait for 10 ns;
        instruction_signal <= B"10111000" & B"11_110_000" & B"00000000" & B"00000000" & B"00000000" & B"01110010";
        length_signal <= 6;
        wait for 10 ns;
        instruction_signal <= B"10111000"& B"11_011_000" & B"00000000" & B"00000000" & B"00000000" & B"01100100";
        length_signal <= 6;
        wait for 10 ns;
        instruction_signal <= X"00000000" & B"00111011" & B"00_001_011";
        length_signal <= 2;
        wait for 10 ns;
    end process;
    
    dcd: Instruction_Decode port map(clk => clk_signal, reset => reset_signal, instruction => instruction_signal, length => length_signal, operation => operation_signal, operand_1 => operand_1_signal, operand_2 => operand_2_signal, EAX => EAX_signal, EBX => EBX_signal, ECX => ECX_signal, EDX => EDX_signal,  ESP => ESP_signal,  EBP => EBP_signal, ESI => ESI_signal, EDI => EDI_signal, operand_2_isMemory => operand_2_isMemory_signal, instruction_type => instruction_type_signal);

end Behavioral;
