----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/22/2023 10:43:43 PM
-- Design Name: 
-- Module Name: UnitMemory - Behavioral
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

entity UnitMemory is
     Port ( 
          CLK:in STD_LOGIC; --pt scriere sincrona in memorie
          ALURes_in:in STD_LOGIC_VECTOR(15 downto 0); --lw/sw
          RD2:in STD_LOGIC_VECTOR(15 downto 0);
          MemWrite:in STD_LOGIC;    
          EN:in STD_LOGIC;    
              
          MemData:out STD_LOGIC_VECTOR(15 downto 0);
          ALURes:out STD_LOGIC_VECTOR(15 downto 0)
     );
end UnitMemory;

architecture Behavioral of UnitMemory is
type memory is array (0 to 31) of STD_LOGIC_VECTOR(15 downto 0);
signal M : memory := (
    X"0003",
    X"0008",
    X"0005",
    others => X"0000");

begin
--scriere sincrona cu activare EN
   process(CLK)             
   begin
       if rising_edge(CLK) then
           if EN = '1' and MemWrite = '1' then
               M(conv_integer(ALURes_in(4 downto 0))) <= RD2;            
           end if;
       end if;
   end process;
   
--citire asincrona
   MemData <= M(conv_integer(ALURes_in(4 downto 0)));
   ALURes <= ALURes_in;
   
end Behavioral;