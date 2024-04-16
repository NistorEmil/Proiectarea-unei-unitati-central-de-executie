----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/19/2023 12:07:54 AM
-- Design Name: 
-- Module Name: UCE - Behavioral
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

entity UCE is
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
end entity;

architecture Behavioral of UCE is

component Main_Memory is
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
end component;

component Instruction_Fetch is
        Port (instruction : in STD_LOGIC_VECTOR (47 downto 0); 
           length: in integer;
           EIP: inout STD_LOGIC_VECTOR (31 downto 0);
           enable: in STD_LOGIC;
           ge: in STD_LOGIC;
           z: in STD_LOGIC);
end component;

component Instruction_Decode is
    Port(reset: in std_logic;
        instruction: in std_logic_vector(47 downto 0);
        length: in integer;
        operation: out std_logic_vector(2 downto 0);
        operand_1: out std_logic_vector(31 downto 0);
        operand_2: out std_logic_vector(31 downto 0);
        EAX, EBX, ECX, EDX: in std_logic_vector(31 downto 0); 
        ESP, EBP, ESI, EDI: in std_logic_vector(31 downto 0);
        operand_2_isMemory: out std_logic;
        enable: in std_logic 
    );
end component;

component ALU is
    Port ( operand1 : in STD_LOGIC_VECTOR (31 downto 0);
           operand2 : in STD_LOGIC_VECTOR (31 downto 0);
           operand2_aux: in STD_LOGIC_VECTOR (31 downto 0);
           operand2_isMemory: in STD_LOGIC;
           operation : in STD_LOGIC_VECTOR (2 downto 0);
           result : out STD_LOGIC_VECTOR (31 downto 0);
           EFLAGS: out STD_LOGIC_VECTOR(31 downto 0);
           enable: in STD_LOGIC);
end component;

component WriteBack is
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
end component;

component Unit_Control is
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
end component;

signal EAX, EBX, ECX, EDX, ESI, EDI, EBP, ESP: std_logic_vector(31 downto 0):=X"00000000";
signal EFLAGS: std_logic_vector(31 downto 0):=X"00000000";
signal CS: std_logic_vector(31 downto 0):=X"00000000";
signal DS: std_logic_vector(31 downto 0):=X"00000040"; -- adresa 64
signal ES, FS, GS, SS: std_logic_vector(31 downto 0):=X"00000000";
signal Instruction_Register: STD_LOGIC_VECTOR(47 downto 0);

-- Memory Signals

    signal mem_Write_signal: STD_LOGIC;
    signal mem_WriteData_signal : STD_LOGIC_VECTOR(31 downto 0);
    signal data_length: integer;
    signal memory_writeadress: STD_LOGIC_VECTOR(31 downto 0):=X"00000000";
    signal data: STD_LOGIC_VECTOR(31 downto 0);
    
--

-- Fetch Signals

    signal EIP: std_logic_vector(31 downto 0):=X"00000000";
    
--

-- Decode Signals

    signal operation: STD_LOGIC_VECTOR(2 downto 0);
    signal operand_1, operand_2: STD_LOGIC_VECTOR(31 downto 0);
    signal operand_2_isMemory: STD_LOGIC:='0';
    
--

-- ALU signals
    
    signal result: STD_LOGIC_VECTOR(31 downto 0);
    
--

-- WriteBack signals

    signal writeback_adress: STD_LOGIC_VECTOR(2 downto 0);
    signal writeback_register_length: integer;
    
--

-- UnitControl signals

    signal regWrite0, regWrite1, regWrite2, regWrite3, regWrite4, regWrite5, regWrite6, op2_isMemory, jump: STD_LOGIC:='0';
    signal wb: STD_LOGIC:='0';
    
--
    
begin
 
    registerWrite: process(wb, Instruction_Register, clk)
    begin
            if wb = '1' then
            if rising_edge(clk) then
        case writeback_register_length is
            when 32 =>
                case writeback_adress is
                    when "000" => EAX <= result; 
                    when "001" => ECX <= result; 
                    when "010" => EDX <= result; 
                    when "011" => EBX <= result; 
                    when "100" => ESP <= result; 
                    when "101" => EBP <= result; 
                    when "110" => ESI <= result; 
                    when others => EDI <= result; 
                end case;
           when others =>
                case writeback_adress is
                    when "000" => EAX(7 downto 0) <= result(7 downto 0); -- AL
                    when "001" => ECX(7 downto 0) <= result(7 downto 0); -- CL
                    when "010" => EDX(7 downto 0) <= result(7 downto 0); -- DL
                    when "011" => EBX(7 downto 0) <= result(7 downto 0); -- BL
                    when "100" => ESP(7 downto 0) <= result(7 downto 0); 
                    when "101" => EBP(7 downto 0) <= result(7 downto 0);  
                    when "110" => ESI(7 downto 0) <= result(7 downto 0); 
                    when others => EDI(7 downto 0) <= result(7 downto 0); 
                end case;
           end case;
           end if;
           end if;
    end process;
    
    instrRegister <= Instruction_Register;
    EIPP <= EIP;
    op1 <= operand_1;
    op2 <= operand_2;
    res <= result;
    ge <= EFLAGS(1);
    z <= EFLAGS(6);
    op2_aux <= data;
    EAX_out <= EAX;
    EBX_out <= EBX;
    ECX_out <= ECX;
    EDX_out <= EDX;
    ESI_out <= ESI;
       
    memory: Main_Memory port map(clk, enable, mem_Write_signal, EIP, result, memory_writeadress, mem_WriteData_signal, Instruction_Register, data, data_length);
    decode: Instruction_Decode port map(reset, Instruction_Register, data_length, operation, operand_1, operand_2, EAX, EBX, ECX, EDX, ESP, EBP, ESI, EDI, operand_2_isMemory, enable);
    ALU1: ALU port map(operand_1, operand_2, data, operand_2_isMemory, operation, result, EFLAGS, enable);
    write_back: WriteBack port map(Instruction_Register, data_length, regWrite0, regWrite1, regWrite2, regWrite3, regWrite4, regWrite5, regWrite6, writeback_adress, writeback_register_length, enable, wb);
    fetch: Instruction_Fetch port map(Instruction_Register, data_length, EIP, enable, EFLAGS(1), EFLAGS(6));
    UC: Unit_Control port map(Instruction_Register, data_length, regWrite0, regWrite1, regWrite2, regWrite3, regWrite4, regWrite5, regWrite6, operand_2_isMemory, jump);

end Behavioral;
