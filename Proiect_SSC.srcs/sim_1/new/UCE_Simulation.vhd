----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/14/2023 08:01:41 AM
-- Design Name: 
-- Module Name: UCE_Simulation - Behavioral
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

entity UCE_Simulation is
--  Port ( );
end UCE_Simulation;

architecture Behavioral of UCE_Simulation is

component UCE is
    Port (clk : in STD_LOGIC;
          enable: in STD_LOGIC;
          reset: in STD_LOGIC;
          instrRegister: out STD_LOGIC_VECTOR(47 downto 0);
          EIPP: out STD_LOGIC_VECTOR(31 downto 0);
          op1: out STD_LOGIC_VECTOR(31 downto 0);
          op2: out STD_LOGIC_VECTOR(31 downto 0);
          res: out STD_LOGIC_VECTOR(31 downto 0);
          z: out STD_LOGIC;
          ge: out STD_LOGIC;
          op2_aux: out STD_LOGIC_VECTOR(31 downto 0);
          EAX_out: out STD_LOGIC_VECTOR(31 downto 0);
          EBX_out: out STD_LOGIC_VECTOR(31 downto 0);
          ECX_out: out STD_LOGIC_VECTOR(31 downto 0);
          EDX_out: out STD_LOGIC_VECTOR(31 downto 0);
          ESI_out: out STD_LOGIC_VECTOR(31 downto 0)
          );
end component;

    signal clk_signal, enable_signal, reset_signal, Z_signal, ge_signal: STD_LOGIC;
    signal instrRegister_signal: STD_LOGIC_VECTOR(47 downto 0);
    signal EIPP_signal, op1_signal, op2_signal, res_signal, op2_aux_signal: STD_LOGIC_VECTOR(31 downto 0); 
    signal EAX, EBX, ECX, EDX, ESI: STD_LOGIC_VECTOR(31 downto 0);

begin

    enable_signal <= '1';
    reset_signal <='0';

    process
    begin
        clk_signal <= '0';
        wait for 5 ns;
        clk_signal <= '1';
        wait for 5 ns;        
    end process;
    
    UCE1: UCE port map(clk => clk_signal, enable => enable_signal, reset => reset_signal, instrRegister => instrRegister_signal, EIPP => EIPP_signal, op1 => op1_signal, op2 => op2_signal, res => res_signal, z => z_signal, ge => ge_signal, op2_aux => op2_aux_signal, EAX_out => EAX, EBX_out => EBX, ECX_out => ECX, EDX_out => EDX, ESI_out => ESI);

end Behavioral;
