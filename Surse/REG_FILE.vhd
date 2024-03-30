----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/13/2023 01:19:19 PM
-- Design Name: 
-- Module Name: REG_FILE - Behavioral
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

entity REG_FILE is
    Port (
        RA1: in STD_LOGIC_VECTOR(2 downto 0);
        RA2: in STD_LOGIC_VECTOR(2 downto 0);
        WA: in STD_LOGIC_VECTOR(2 downto 0);
        WD: in STD_LOGIC_VECTOR(15 downto 0);
        clk: in STD_LOGIC;
        en: in STD_LOGIC;
        RD1: out STD_LOGIC_VECTOR(15 downto 0);
        RD2: out STD_LOGIC_VECTOR(15 downto 0);
        RegWr: in STD_LOGIC
    );
end entity;

architecture Behavioral of REG_FILE is
    type reg_array is array(0 to 7) of STD_LOGIC_VECTOR(15 downto 0);
    signal reg_file: reg_array := (
        x"0000",
        x"0000",
        x"0000",
        x"0000",
        x"0000",
        x"0000",
        x"0000",
        x"0000",
        others => x"0000");
--    type reg_array is array(0 to 15) of STD_LOGIC_VECTOR(15 downto 0);
--    signal reg_file: reg_array;
begin
    --write port:
    RD1 <= reg_file(conv_integer(RA1));
    RD2 <= reg_file(conv_integer(RA2));
    process(clk, en, RegWr)
    begin
        if rising_edge(clk) then
        if RegWr = '1' and en = '1' then
            reg_file(conv_integer(WA)) <= WD;
        end if;
        end if;
    end process;
--    write: process(clk)
--    begin
--        if rising_edge(clk) then
--            if RegWr = '1' then
--                reg_file(conv_integer(WA)) <= WD;
--            end if;
--        end if;
--    end process;
end Behavioral;
