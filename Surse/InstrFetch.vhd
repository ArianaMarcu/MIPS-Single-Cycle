----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2023 01:29:30 PM
-- Design Name: 
-- Module Name: InstrFetch - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity InstrFetch is
    Port (clk: in STD_LOGIC;
          rst : in STD_LOGIC;
          enablePC : in STD_LOGIC;
          BranchAddress : in STD_LOGIC_VECTOR(15 downto 0);
          JumpAddress : in STD_LOGIC_VECTOR(15 downto 0);
          Jump : in STD_LOGIC;
          PCSrc : in STD_LOGIC;
          Instruction : out STD_LOGIC_VECTOR(15 downto 0);
          nextA : out STD_LOGIC_VECTOR(15 downto 0));--PCinc
end InstrFetch;

architecture Behavioral of InstrFetch is

signal PC : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
signal out_mux_ja: STD_LOGIC_VECTOR(15 downto 0);
signal out_mux_ba: STD_LOGIC_VECTOR(15 downto 0);
signal out_sum: STD_LOGIC_VECTOR(15 downto 0);

-- CMMDC intre valoarea obtinuta ca suma numerelor dintr-un interval
-- si un numar dat pe care il scriu din memorie:
type tROM is array (0 to 255) of STD_LOGIC_VECTOR(15 downto 0);
signal ROM: tROM := (
--    B"000_000_000_101_0_011",   --0   add $5, $0, $0   X"0053"
--    B"000_000_000_001_0_011",   --4   add $1, $0, $0   X"0013"
--    B"001_000_010_0000011",     --1   addi $2, $0, 3   X"2103"
--    B"001_000_011_0000111",     --2   addi $3, $0, 7   X"2187"
--    B"001_000_100_0000101",     --3   addi $4, $0, 5   X"2205"
--    B"110_010_011_0000011",     --5   beq $2, $3, 3    X"C983"
--    B"000_101_010_101_0_011",   --6   add $5, $5, $2   X"1553"
--    B"001_010_010_0000001",     --7   addi $2, $2, 1   X"2901"
--    B"111_0000000000101",       --8   j 5              X"E005"
--    B"010_000_101_0101000",     --9   sw $5, 40($0)    X"42A8"
--    B"110_100_001_0001000",     --10  beq $4, $1, 8    X"D088"
--    B"000_101_100_111_0_101",   --11  slt $7, $5, $4   X"1675"
--    B"100_111_001_0001111",     --12  bne $7, $1, 15   X"9C8F"
--    B"000_101_100_101_0_000",   --13  sub $5, $5, $4   X"1650"
--    B"111_0000000001010",       --14  j 10             X"E00A"
--    B"000_101_001_110_0_011",   --15  add $6, $5, $1   X"14E3"
--    B"000_100_001_101_0_011",   --16  add $5, $4, $1   X"10D3"
--    B"000_110_001_100_0_011",   --17  add $4, $6, $1   X"18C3"
--    B"111_0000000001010",       --18  j 10             X"E00A"
--    B"010_000_101_0111000",     --19  sw $5, 56($0)    X"42B8"
--    others => X"0000" );

    B"000_000_000_001_0_011",   --0   add $1, $0, $0   X"0013"
    B"101_000_010_0000000",     --1   lw $2, 0($0)     X"A100"
    B"101_000_011_0000001",     --2   lw $3, 1($0)     X"A181"
    B"101_000_100_0000010",     --3   lw $4, 2($0)     X"A202"
    B"000_000_000_101_0_011",   --4   add $5, $0, $0   X"0053"
    B"110_010_011_0000011",     --5   beq $2, $3, 3    X"C983"
    B"000_001_010_001_0_011",   --6   add $1, $1, $2   X"0513"
    B"001_010_010_0000001",     --7   addi $2, $2, 1   X"2901"
    B"111_0000000000101",       --8   j 5              X"E005"
    B"110_100_001_0000110",     --9   beq $4, $1, 6    X"D086"
    B"000_100_001_101_0_101",   --10  slt $5, $4, $1   X"10D5"
    B"100_101_000_0000010",     --11  bne $5, $0, 2    X"9402"
    B"000_001_100_001_0_000",   --12  sub $1, $1, $4   X"0610"
    B"111_0000000001001",       --13  j 9              X"E009"
    B"000_100_001_100_0_000",   --14  sub $4, $4, $1   X"10C0"
    B"111_0000000001001",       --15  j 9              X"E009"
    B"010_000_100_0000011",     --16  sw $4, 3($0)     X"4203"
    others => X"0000" );
      
begin
    -- Program Counter
    process(PCSrc)
    begin
        case PCSrc is
            when '0' => out_mux_ba <= out_sum;
            when '1' => out_mux_ba <= BranchAddress;
            when others => out_mux_ba <= x"0000";
        end case;
    end process;

    process(Jump)
    begin
        case Jump is
            when '0' => out_mux_ja <= out_mux_ba;
            when '1' => out_mux_ja <= JumpAddress;
            when others => out_mux_ba <= x"0000";
        end case;
    end process;
    
    out_sum <= PC+1;  --16 biti
    nextA <= out_sum;
    
    process(clk, enablePC, rst)
    begin
        if rising_edge(clk) then
            if rst = '1' then PC <= x"0000";
            elsif enablePC = '1' then PC <= out_mux_ja;
            end if;
        end if;
    end process;
    
    --Instruction <= ROM(conv_integer(PC(3 downto 0)));
    Instruction <= ROM(conv_integer(PC));
end architecture;