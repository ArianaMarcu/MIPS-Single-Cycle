----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/22/2023 09:26:56 PM
-- Design Name: 
-- Module Name: UnitExec - Behavioral
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

entity UnitExec is
      Port ( 
           AdUrm:in STD_LOGIC_VECTOR(15 downto 0);
           RD1:in STD_LOGIC_VECTOR(15 downto 0); --rs
           RD2:in STD_LOGIC_VECTOR(15 downto 0); --rt
           ExtImm:in STD_LOGIC_VECTOR(15 downto 0);
           func:in STD_LOGIC_VECTOR(2 downto 0);
           sa:in STD_LOGIC;
           ALUSrc:in STD_LOGIC;
           ALUOp:in STD_LOGIC_VECTOR(2 downto 0);
           
           BranchAdd:out STD_LOGIC_VECTOR(15 downto 0);
           ALURes:out STD_LOGIC_VECTOR(15 downto 0);
           Zero:out STD_LOGIC
      );
end UnitExec;

architecture Behavioral of UnitExec is

signal result : STD_LOGIC_VECTOR(15 downto 0);
signal ALUIn : STD_LOGIC_VECTOR(15 downto 0);
signal ALUCtrl : STD_LOGIC_VECTOR(2 downto 0);

begin

    with ALUSrc select
        ALUIn <= RD2 when '0', 
	              ExtImm when '1',
	              (others => '0') when others; --MUX
			  
    process(ALUOp, func)
    begin
        case ALUOp is
            when "000" => -- R
                case func is
                    when "000" => ALUCtrl <= "000"; -- SUB
                    when "001" => ALUCtrl <= "001"; -- XOR
                    when "010" => ALUCtrl <= "010"; -- SLL
                    when "011" => ALUCtrl <= "011"; -- ADD
                    when "100" => ALUCtrl <= "100"; -- SRL
                    when "101" => ALUCtrl <= "101"; -- SLT
                    when "110" => ALUCtrl <= "110"; -- AND
                    when "111" => ALUCtrl <= "111"; -- OR
                    when others => ALUCtrl <= (others => 'X');
                end case;
            when "001" => ALUCtrl <= "011"; -- ADDI
            when "101" => ALUCtrl <= "011"; -- L
            when "010" => ALUCtrl <= "011"; -- 
            when "110" => ALUCtrl <= "000"; -- -
            when "100" => ALUCtrl <= "000"; -- -
            when "011" => ALUCtrl <= "000"; -- -
            when others => ALUCtrl <= (others => 'X');
        end case;
    end process;

    process(ALUCtrl, RD1, AluIn, sa, result)
    begin
        case ALUCtrl  is
            when "000" =>
                result <= RD1 - ALUIn;
            when "001" =>
                result <= RD1 xor ALUIn;                                  
            when "010" =>
                case sa is
                    when '1' => result <= ALUIn(14 downto 0) & "0"; --shift left
                    when '0' => result <= ALUIn;
                    when others => result <= (others => 'X');
                 end case;
            when "011" =>
                result <= RD1 + ALUIn;
            when "100" =>
                case sa is
                    when '1' => result <= "0" & ALUIn(15 downto 1); --shift right
                    when '0' => result <= ALUIn;
                    when others => result <= (others => 'X');
                end case;
            when "101" =>
                if signed(RD1) < signed(ALUIn) then
                    result <= X"0001";
                else result <= X"0000";
                end if;  --detecteaza mai mic decat
            when "110" =>
                result <= RD1 and ALUIn;		
            when "111" =>
                result <= RD1 or ALUIn; 
            when others =>
                result <= (others => '0');              
        end case;
        
        ALURes <= result;
        case result is
                when X"0000" => Zero <= '1';
                when others => Zero <= '0';
         end case;
         end process;  
     BranchAdd <= AdUrm + ExtImm;
end Behavioral;
