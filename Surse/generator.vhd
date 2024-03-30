----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/05/2023 11:20:16 PM
-- Design Name: 
-- Module Name: generator - Behavioral
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

entity generator is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           en : out STD_LOGIC);
end generator;

architecture Behavioral of generator is
signal count_int: STD_LOGIC_VECTOR(15 downto 0);
signal Q1: STD_LOGIC;
signal Q2: STD_LOGIC;
signal Q3: STD_LOGIC;
begin

process(clk) --bistabil D flip-flop 1
begin
    if clk'event AND clk='1' then
        if count_int(15 downto 0)="1111111111111111" then Q1 <= btn;
        end if;
     end if;
end process;

process(clk)--bistabil D flip-flop 2
begin
if clk'event AND clk='1' then
    Q2 <= Q1;
    Q3 <= Q2;
end if;
end process;

process(clk) --counter
begin
    if clk='1' AND clk'event then
        count_int <= count_int + 1;
    end if;
end process;

en <= Q2 AND (not Q3);

end Behavioral;
