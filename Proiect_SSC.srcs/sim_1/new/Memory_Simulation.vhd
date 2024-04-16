----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/01/2023 02:40:40 AM
-- Design Name: 
-- Module Name: Memory_Simulation - Behavioral
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

entity Memory_Simulation is
--  Port ( );
end Memory_Simulation;

architecture Behavioral of Memory_Simulation is

component Main_Memory is
    Port (clk : in STD_LOGIC;
           enable : in STD_LOGIC;
           Write : in STD_LOGIC;
           Adress : in STD_LOGIC_VECTOR (31 downto 0);
           WriteData : in STD_LOGIC_VECTOR (31 downto 0);
           Data : out STD_LOGIC_VECTOR (47 downto 0);
           Data_length: out integer);
end component;

signal clk_signal, enable_signal, Write_signal: STD_LOGIC;
signal Adress_signal, WriteData_signal: STD_LOGIC_VECTOR(31 downto 0);
signal Data_signal: STD_LOGIC_VECTOR(47 downto 0);
signal Data_length_signal: integer;

begin

    memory: Main_Memory port map(clk => clk_signal, enable => enable_signal, Write => Write_signal, Adress => Adress_signal, WriteData => WriteData_signal, Data => Data_signal, Data_length => Data_length_signal);

    process
    begin
        clk_signal <= '0';
        wait for 5 ns;
        clk_signal <= '1';
        wait for 5 ns;        
    end process;
    

    process
    begin
        enable_signal <= '1';
        Write_signal <= '0';
        Adress_signal <= X"00000000";
        wait for 10 ns;
        Adress_signal <= X"00000002";
        wait for 10 ns;
        Adress_signal <= X"00000008";
        wait for 10 ns;
        Adress_signal <= X"0000000E";
        wait for 10 ns;
         Adress_signal <= X"00000014";
        wait for 10 ns;
    end process;

end Behavioral;
