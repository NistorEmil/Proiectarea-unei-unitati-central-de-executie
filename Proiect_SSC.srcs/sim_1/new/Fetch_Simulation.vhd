----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/30/2023 11:16:44 PM
-- Design Name: 
-- Module Name: Fetch_Simulation - Behavioral
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

entity Fetch_Simulation is
--  Port ( );
end Fetch_Simulation;

architecture Behavioral of Fetch_Simulation is

component Instruction_Fetch is
        Port (instruction : in STD_LOGIC_VECTOR (47 downto 0);
           length: in integer;
           EIP : out STD_LOGIC_VECTOR (31 downto 0));
end component;

signal  EIP_signal : STD_LOGIC_VECTOR(31 downto 0):=X"00000000";
signal instruction_signal:STD_LOGIC_VECTOR(47 downto 0);
signal length_signal: integer:=2;

begin
    
    process
    begin
        length_signal <= 2;
        instruction_signal <= X"00000000" & B"00110011_11_001_001";
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
        instruction_signal <= X"00000000" & B"01111101" & B"00010010";
        length_signal <= 2;
        wait for 10 ns;
    end process;

    fetch1: Instruction_Fetch port map(instruction => instruction_signal, length => length_signal, EIP => EIP_signal);

end Behavioral;
