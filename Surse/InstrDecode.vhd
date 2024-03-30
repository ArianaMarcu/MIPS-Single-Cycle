----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/09/2023 11:09:32 PM
-- Design Name: 
-- Module Name: InstrDecode - Behavioral
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

entity InstrDecode is
    Port(
        clk: in std_logic;
        instr: in std_logic_vector(12 downto 0);
        WD: in std_logic_vector(15 downto 0);
        RegWrite: in std_logic;
        RegDst: in std_logic;
        ExtOp: in std_logic;
        enable: in std_logic;
        ExtImm: out std_logic_vector(15 downto 0);
        RD1: out std_logic_vector(15 downto 0);
        RD2: out std_logic_vector(15 downto 0);
        func: out std_logic_vector(2 downto 0);
        sa: out std_logic
    );
end InstrDecode;

architecture Behavioral of InstrDecode is

--REG_FILE
--type reg_array is array(0 to 7) of STD_LOGIC_VECTOR(15 downto 0);
--signal reg_file: reg_array := (others => X"0000");
--signal wrAddr: STD_LOGIC_VECTOR(2 downto 0);

--begin
--    with RegDst select
--        wrAddr <= instr(6 downto 4) when '1', --rd
--                  instr(9 downto 7) when '0', --rt
--                  (others => '0') when others;
--    process(clk)
--    begin
--        if rising_edge(clk) then
--            if enable = '1' and RegWrite = '1' then
--                reg_file(conv_integer(wrAddr)) <= WD;
--            end if;
--        end if;
--    end process;   --SCRIEREA

--RD1 <= reg_file(conv_integer(instr(12 downto 10))); --rs
--RD2 <= reg_file(conv_integer(instr(9 downto 7)));   --rt  --CITIREA

--ExtImm(6 downto 0) <= instr(6 downto 0);
--with ExtOp select
--    ExtImm(15 downto 7) <= (others => instr(6)) when '1',
--                           (others => '0') when '0',
--                           (others => '0') when others;
--sa <= instr(3);
--func <= instr(2 downto 0);                 

component REG_FILE is
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
end component;
signal wrAddr: std_logic_vector(2 downto 0) := (others => '0');

begin
    register_file: REG_FILE port map(
            RA1 => instr(12 downto 10), 
            RA2 => instr(9 downto 7), 
            WA => wrAddr,
            WD => WD, 
     clk => clk, 
     en => enable, 
     RD1 => RD1,
      RD2 => RD2, 
      RegWr => RegWrite);
    
    sa <= instr(3);
    func <= instr(2 downto 0);
    
    process(RegDst)
    begin
            if RegDst = '0' then
                wrAddr <= instr(9 downto 7);
            else
                wrAddr <= instr(6 downto 4);
            end if;
        end process;
        
    process(ExtOp)
    begin
        if ExtOp = '1' then
            ExtImm <= instr(6) & instr(6) & instr(6) & instr(6) & instr(6) & instr(6) & instr(6) & instr(6) & instr(6) & instr(6 downto 0);
        end if;
    end process;
        --Imediatul extins la 16 biti

end Behavioral;
