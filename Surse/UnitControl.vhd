----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/09/2023 11:28:01 PM
-- Design Name: 
-- Module Name: UnitControl - Behavioral
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

entity UnitControl is  --cei 3 biti de opcode
    Port ( 
        Instr : in std_logic_vector(2 downto 0);
        RegDst : out std_logic;
        ExtOp : out std_logic;
        ALUSRC : out std_logic;
        Branch : out std_logic;
        BrGez : out std_logic;
        BrNe : out std_logic;
        Jump : out std_logic;
        ALUOp : out std_logic_vector(2 downto 0);
        MemWrite : out std_logic;
        MemtoReg : out std_logic;
        RegWrite : out std_logic
   );
end UnitControl;

architecture Behavioral of UnitControl is

begin
    process(Instr)  
    begin
        RegDst <= '0'; --pentru a evita sa se atribuie semnalele de control pe fiecare ramura din case
        ExtOp <= '0';
        ALUSRC <= '0';
        Branch <= '0';
        BrGez <= '0';
        BrNe <= '0';
        Jump <= '0';
        ALUOp <= "000";
        MemWrite <= '0';
        MemtoReg <= '0';
        RegWrite <= '0';
        
        case (Instr) is
            when "000" => -- tip R
                   RegDst <= '1'; 
                   RegWrite <= '1'; 
                   ALUOp <= "000";
                   
            when "001" => -- ADDI
                   ExtOp <= '1';
                   ALUSRC <= '1';
                   RegWrite <= '1';
                   ALUOp <= "001";
                   
            when "010" => -- SW
                   ALUSRC <= '1';
                   ExtOp <= '1';
                   MemWrite <= '1';
                   ALUOp <= "010";
                   
             when "011" => -- BGEZ
                   BrGez <= '1';
                   ExtOp <= '1';
                   ALUOp <= "011";  
                   
             when "100" => --BNE
                   BrNe <= '1';
                   ExtOp <= '1';  
                   ALUOp <= "100";  
                   
             when "101" => -- LW
                   ALUOp <= "101";
                   RegWrite <= '1';
                   ALUSRC <= '1';
                   ExtOp <= '1';
                   MemtoReg <= '1';
                   
             when "110" => -- BEQ
                   ExtOp <= '1';
                   ALUOp <= "110";
                   Branch <= '1';
                   
             when "111" => -- JUMP
                   Jump <= '1';
                   
             when others =>
                   RegDst <= '0';
                   ExtOp <= '0';
                   ALUSRC <= '0';
                   Branch <= '0';
                   BrGez <= '0';
                   BrNe <= '0';
                   Jump <= '0';
                   MemWrite <= '0';
                   MemtoReg <= '0';
                   ALUOp <= "000";
                   RegWrite <= '0';

        end case;
    end process;
end Behavioral;
