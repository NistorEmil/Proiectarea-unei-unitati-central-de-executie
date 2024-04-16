----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/19/2023 09:27:13 PM
-- Design Name: 
-- Module Name: Instruction_Decode - Behavioral
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

entity Instruction_Decode is
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
end Instruction_Decode;

architecture Behavioral of Instruction_Decode is

signal length_operand_1: std_logic_vector(1 downto 0):="11";
signal length_operand_2: std_logic_vector(1 downto 0):="11";
signal immediate: std_logic_vector(31 downto 0);
signal instruction_length: integer:=2;


begin

    operation_process:process (instruction) 
    begin
    if enable = '1' then
        if (length > 0) then
            case instruction((length*8)-1 downto (length-1)*8) is -- opcode
                when X"81" => operation <= "000"; -- + -- (adunare) // ADD
                          length_operand_1 <= "11"; -- 32 bits
                          length_operand_2 <= "11"; -- 32 bits
                when X"3B" => operation <= "001"; -- - -- (scadere) // CMP
                          length_operand_1 <= "11"; -- 32 bits
                          length_operand_2 <= "11"; -- 32 bits
                when X"33" => operation <= "010"; -- xor -- (xor) // XOR
                          length_operand_1 <= "11"; -- 32 bits
                          length_operand_2 <= "11"; -- 32 bits
                when X"7D" | X"75" | X"74" | X"EB" => immediate <= X"000000" & instruction(((instruction_length-1)*8)-1 downto (instruction_length-2)*8); -- JGE, JZ, JNZ, JMP
                when X"01" => operation <= "000"; -- + -- (adunare) // ADD
                          length_operand_1 <= "11"; -- 32 bits
                          length_operand_2 <= "11"; -- 32 bits    
                when X"A8" => operation <= "011"; -- - -- (scadere) // TEST
                          length_operand_1 <= "00"; -- 8 bits
                          length_operand_2 <= "00"; -- 8 bits
                when X"40" => operation <= "000"; -- + -- (adunare) // INC
                          length_operand_1 <= "11"; -- 32 bits
                          length_operand_2 <= "11"; -- 32 bits 
                when X"00" => operation <= "000"; -- + -- (adunare) // ADD
                          length_operand_1 <= "00"; -- 8 bits
                          length_operand_2 <= "00"; -- 8 bits
                when X"B8" => operation <= "100"; -- no operation
                          length_operand_1 <= "11"; -- 32 bits
                          length_operand_2 <= "11"; -- 32 bits 
                when X"8A" => operation <= "100";
                          length_operand_1 <= "00";
                          length_operand_2 <= "00";
                when others => 
            end case;    
        else
            case instruction((instruction_length*8)-1 downto (instruction_length-1)*8) is
                when X"81" => operation <= "000"; -- + -- (adunare) // ADD
                          length_operand_1 <= "11"; -- 32 bits
                          length_operand_2 <= "11"; -- 32 bits
                when X"3B" => operation <= "001"; -- - -- (scadere) // CMP
                          length_operand_1 <= "11"; -- 32 bits
                          length_operand_2 <= "11"; -- 32 bits
                when X"33" => operation <= "010"; -- xor -- (xor) // XOR
                          length_operand_1 <= "11"; -- 32 bits
                          length_operand_2 <= "11"; -- 32 bits
                when X"7D" | X"75" | X"74" | X"EB" => immediate <= X"000000" & instruction(((instruction_length-1)*8)-1 downto (instruction_length-2)*8); -- JGE, JZ, JNZ, JMP
                when X"01" => operation <= "000"; -- + -- (adunare) // ADD
                          length_operand_1 <= "11"; -- 32 bits
                          length_operand_2 <= "11"; -- 32 bits    
                when X"A8" => operation <= "011"; -- - -- (scadere) // TEST
                          length_operand_1 <= "00"; -- 8 bits
                          length_operand_2 <= "00"; -- 8 bits
                when X"40" => operation <= "000"; -- + -- (adunare) // INC
                          length_operand_1 <= "11"; -- 32 bits
                          length_operand_2 <= "11"; -- 32 bits 
                when X"00" => operation <= "000"; -- + -- (adunare) // ADD
                          length_operand_1 <= "00"; -- 8 bits
                          length_operand_2 <= "00"; -- 8 bits
                when X"B8" => operation <= "100"; -- no operation
                          length_operand_1 <= "11"; -- 32 bits
                          length_operand_2 <= "11"; -- 32 bits 
                when X"8A" => operation <= "100";
                          length_operand_1 <= "00";
                          length_operand_2 <= "00";
                when others => 
            end case;
        end if;
    end if;
    end process;
    
    operand1:process(instruction)
    begin
    if enable = '1' then
        if (length > 0) then
            case instruction((length*8)-1 downto (length-1)*8) is
                when X"8A" | X"A8" =>
                    case instruction(((length-1)*8)-3 downto ((length-2)*8)+3) is
                        when "000" => operand_1 <= X"000000" & EAX(7 downto 0); -- AL
                        when "001" => operand_1 <= X"000000" & ECX(7 downto 0); -- CL
                        when "010" => operand_1 <= X"000000" & EDX(7 downto 0); -- DL
                        when "011" => operand_1 <= X"000000" & EBX(7 downto 0); -- BL
                        when "100" => operand_1 <= X"000000" & EAX(15 downto 8); -- AH
                        when "101" => operand_1 <= X"000000" & ECX(15 downto 8); -- CH
                        when "110" => operand_1 <= X"000000" & EDX(15 downto 8); -- DH
                        when others => operand_1 <= X"000000" & EBX(15 downto 8); -- BH
                    end case;
                when X"FF" =>
                    case instruction(((length-1)*8)-3 downto ((length-2)*8)+3) is
                        when "000" => operand_1 <= X"0000" & EAX(15 downto 0); -- AX
                        when "001" => operand_1 <= X"0000" & ECX(15 downto 0); -- CX
                        when "010" => operand_1 <= X"0000" & EDX(15 downto 0); -- DX
                        when "011" => operand_1 <= X"0000" & EBX(15 downto 0); -- BX
                        when "100" => operand_1 <= X"0000" & ESP(15 downto 0); -- SP
                        when "101" => operand_1 <= X"0000" & EBP(15 downto 0); -- BP
                        when "110" => operand_1 <= X"0000" & ESI(15 downto 0); -- SI
                        when others => operand_1 <= X"0000" & EDI(15 downto 0); -- DI
                    end case;     
                when others =>
                    case instruction(((length-1)*8)-3 downto ((length-2)*8)+3) is
                        when "000" => operand_1 <= EAX;
                        when "001" => operand_1 <= ECX;
                        when "010" => operand_1 <= EDX;
                        when "011" => operand_1 <= EBX;
                        when "100" => operand_1 <= ESP;
                        when "101" => operand_1 <= EBP;
                        when "110" => operand_1 <= ESI;
                        when others => operand_1 <= EDI; 
                    end case;
            end case;
        end if;
    else
        case instruction((instruction_length*8)-1 downto (instruction_length-1)*8) is
            when X"8A" | X"A8" =>
                case instruction(((instruction_length-1)*8)-3 downto ((instruction_length-2)*8)+3) is
                    when "000" => operand_1 <= X"000000" & EAX(7 downto 0); -- AL
                    when "001" => operand_1 <= X"000000" & ECX(7 downto 0); -- CL
                    when "010" => operand_1 <= X"000000" & EDX(7 downto 0); -- DL
                    when "011" => operand_1 <= X"000000" & EBX(7 downto 0); -- BL
                    when "100" => operand_1 <= X"000000" & EAX(15 downto 8); -- AH
                    when "101" => operand_1 <= X"000000" & ECX(15 downto 8); -- CH
                    when "110" => operand_1 <= X"000000" & EDX(15 downto 8); -- DH
                    when others => operand_1 <= X"000000" & EBX(15 downto 8); -- BH
                end case;
            when X"FF" =>
                case instruction(((instruction_length-1)*8)-3 downto ((instruction_length-2)*8)+3) is
                    when "000" => operand_1 <= X"0000" & EAX(15 downto 0); -- AX
                    when "001" => operand_1 <= X"0000" & ECX(15 downto 0); -- CX
                    when "010" => operand_1 <= X"0000" & EDX(15 downto 0); -- DX
                    when "011" => operand_1 <= X"0000" & EBX(15 downto 0); -- BX
                    when "100" => operand_1 <= X"0000" & ESP(15 downto 0); -- SP
                    when "101" => operand_1 <= X"0000" & EBP(15 downto 0); -- BP
                    when "110" => operand_1 <= X"0000" & ESI(15 downto 0); -- SI
                    when others => operand_1 <= X"0000" & EDI(15 downto 0); -- DI
                end case;     
            when others =>
                case instruction(((instruction_length-1)*8)-3 downto ((instruction_length-2)*8)+3) is
                    when "000" => operand_1 <= EAX;
                    when "001" => operand_1 <= ECX;
                    when "010" => operand_1 <= EDX;
                    when "011" => operand_1 <= EBX;
                    when "100" => operand_1 <= ESP;
                    when "101" => operand_1 <= EBP;
                    when "110" => operand_1 <= ESI;
                    when others => operand_1 <= EDI; 
                end case;
        end case;
    end if;
    end process;
    
    operand2:process(instruction)
    begin
        if (length > 0) then
            if instruction((length*8)-1 downto (length-1)*8) = X"81" or 
                 instruction((length*8)-1 downto (length-1)*8) = X"A8" or
                 instruction((length*8)-1 downto (length-1)*8) = X"40" or
                 instruction((length*8)-1 downto (length-1)*8) = X"B8" then
                        if instruction((length*8)-1 downto (length-1)*8) = X"A8" then
                            operand_2 <= X"000000" & instruction(7 downto 0);
                        elsif instruction((length*8)-1 downto (length-1)*8) = X"40" then
                            operand_2 <= X"00000004";
                        else
                            operand_2 <= instruction(31 downto 0); -- immediate
                        end if;
              else
                if instruction((length*8)-1 downto (length-1)*8) /= X"81" and
                   instruction((length*8)-1 downto (length-1)*8) /= X"A8" and
                   instruction((length*8)-1 downto (length-1)*8) /= X"B8" then
                    case instruction(((length-1)*8)-1 downto ((length-2)*8)+6) is
                        when "00" =>
                            operand_2_isMemory <= '1';
                            case instruction(((length-1)*8)-6 downto (length-2)*8) is
                                when "000" => operand_2 <= EAX; 
                                when "001" => operand_2 <= ECX; 
                                when "010" => operand_2 <= EDX; 
                                when "011" => operand_2 <= EBX; 
                                when "100" => operand_2 <= ESP; 
                                when "101" => operand_2 <= EBP; 
                                when "110" => operand_2 <= ESI; 
                                when others => operand_2 <= EDI; 
                            end case;
                        when others => operand_2_isMemory <= '0';
                    case length_operand_2 is
                        when "00" =>
                            case instruction(((length-1)*8)-6 downto (length-2)*8) is
                                when "000" => operand_2 <= X"000000" & EAX(7 downto 0); -- AL
                                when "001" => operand_2 <= X"000000" & ECX(7 downto 0); -- CL
                                when "010" => operand_2 <= X"000000" & EDX(7 downto 0); -- DL
                                when "011" => operand_2 <= X"000000" & EBX(7 downto 0); -- BL
                                when "100" => operand_2 <= X"000000" & EAX(15 downto 8); -- AH
                                when "101" => operand_2 <= X"000000" & ECX(15 downto 8); -- CH
                                when "110" => operand_2 <= X"000000" & EDX(15 downto 8); -- DH
                                when others => operand_2 <= X"000000" & EBX(15 downto 8); -- BH
                            end case;
                        when "01" =>
                            case instruction(((length-1)*8)-6 downto (length-2)*8) is
                                when "000" => operand_2 <= X"0000" & EAX(15 downto 0); -- AX
                                when "001" => operand_2 <= X"0000" & ECX(15 downto 0); -- CX
                                when "010" => operand_2 <= X"0000" & EDX(15 downto 0); -- DX
                                when "011" => operand_2 <= X"0000" & EBX(15 downto 0); -- BX
                                when "100" => operand_2 <= X"0000" & ESP(15 downto 0); -- SP
                                when "101" => operand_2 <= X"0000" & EBP(15 downto 0); -- BP
                                when "110" => operand_2 <= X"0000" & ESI(15 downto 0); -- SI
                                when others => operand_2 <= X"0000" & EDI(15 downto 0); -- DI 
                            end case;
                        when others =>
                            case instruction(((length-1)*8)-6 downto (length-2)*8) is
                                when "000" => operand_2 <= EAX; 
                                when "001" => operand_2 <= ECX; 
                                when "010" => operand_2 <= EDX; 
                                when "011" => operand_2 <= EBX; 
                                when "100" => operand_2 <= ESP; 
                                when "101" => operand_2 <= EBP; 
                                when "110" => operand_2 <= ESI; 
                                when others => operand_2 <= EDI; 
                            end case;
                    end case;
                end case;
            end if;
        end if;
        else
            if instruction((instruction_length*8)-1 downto (instruction_length-1)*8) = X"81" or 
               instruction((instruction_length*8)-1 downto (instruction_length-1)*8) = X"A8" or
               instruction((instruction_length*8)-1 downto (instruction_length-1)*8) = X"40" or
               instruction((instruction_length*8)-1 downto (instruction_length-1)*8) = X"B8" then
                        if instruction((instruction_length*8)-1 downto (instruction_length-1)*8) = X"A8" then
                            operand_2 <= X"000000" & instruction(7 downto 0);
                        elsif instruction((length*8)-1 downto (length-1)*8) = X"40" then
                            operand_2 <= X"00000004";
                        else
                            operand_2 <= instruction(31 downto 0);
                        end if;
            else
                if instruction((instruction_length*8)-1 downto (instruction_length-1)*8) /= X"81" and
                   instruction((instruction_length*8)-1 downto (instruction_length-1)*8) /= X"A8" and
                   instruction((instruction_length*8)-1 downto (instruction_length-1)*8) /= X"B8" then
                        case instruction(((instruction_length-1)*8)-1 downto ((instruction_length-2)*8)+6) is
                            when "00" =>
                                operand_2_isMemory <= '1';
                                case instruction(((instruction_length-1)*8)-6 downto (instruction_length-2)*8) is
                                    when "000" => operand_2 <= EAX; 
                                    when "001" => operand_2 <= ECX; 
                                    when "010" => operand_2 <= EDX; 
                                    when "011" => operand_2 <= EBX; 
                                    when "100" => operand_2 <= ESP; 
                                    when "101" => operand_2 <= EBP; 
                                    when "110" => operand_2 <= ESI; 
                                    when others => operand_2 <= EDI; 
                                end case;
                            when others =>
                                operand_2_isMemory <= '0';
                        case length_operand_2 is
                            when "00" =>
                                case instruction(((instruction_length-1)*8)-6 downto (instruction_length-2)*8) is
                                    when "000" => operand_2 <= X"000000" & EAX(7 downto 0); -- AL
                                    when "001" => operand_2 <= X"000000" & ECX(7 downto 0); -- CL
                                    when "010" => operand_2 <= X"000000" & EDX(7 downto 0); -- DL
                                    when "011" => operand_2 <= X"000000" & EBX(7 downto 0); -- BL
                                    when "100" => operand_2 <= X"000000" & EAX(15 downto 8); -- AH
                                    when "101" => operand_2 <= X"000000" & ECX(15 downto 8); -- CH
                                    when "110" => operand_2 <= X"000000" & EDX(15 downto 8); -- DH
                                    when others => operand_2 <= X"000000" & EBX(15 downto 8); -- BH
                                end case;
                            when "01" =>
                                case instruction(((instruction_length-1)*8)-6 downto (instruction_length-2)*8) is
                                    when "000" => operand_2 <= X"0000" & EAX(15 downto 0); -- AX
                                    when "001" => operand_2 <= X"0000" & ECX(15 downto 0); -- CX
                                    when "010" => operand_2 <= X"0000" & EDX(15 downto 0); -- DX
                                    when "011" => operand_2 <= X"0000" & EBX(15 downto 0); -- BX
                                    when "100" => operand_2 <= X"0000" & ESP(15 downto 0); -- SP
                                    when "101" => operand_2 <= X"0000" & EBP(15 downto 0); -- BP
                                    when "110" => operand_2 <= X"0000" & ESI(15 downto 0); -- SI
                                    when others => operand_2 <= X"0000" & EDI(15 downto 0); -- DI 
                                end case;
                            when others =>
                                case instruction(((instruction_length-1)*8)-6 downto (instruction_length-2)*8) is
                                    when "000" => operand_2 <= EAX; 
                                    when "001" => operand_2 <= ECX; 
                                    when "010" => operand_2 <= EDX; 
                                    when "011" => operand_2 <= EBX; 
                                    when "100" => operand_2 <= ESP; 
                                    when "101" => operand_2 <= EBP; 
                                    when "110" => operand_2 <= ESI; 
                            when others => operand_2 <= EDI; 
                        end case;
                    end case;
                end case;
            end if;
        end if;
    end if;
    end process;

end Behavioral;
