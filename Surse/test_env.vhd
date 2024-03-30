----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/05/2023 12:24:12 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
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

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is

component generator is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           en : out STD_LOGIC);
end component generator;

component SSD is
    Port( clk: in STD_LOGIC;
    digits: in STD_LOGIC_VECTOR(15 downto 0);
    an: out STD_LOGIC_VECTOR(3 downto 0);
    cat: out STD_LOGIC_VECTOR(6 downto 0));
end component;

--component REG_FILE is
--    Port (
--        RA1: in STD_LOGIC_VECTOR(3 downto 0);
--        RA2: in STD_LOGIC_VECTOR(3 downto 0);
--        WA: in STD_LOGIC_VECTOR(3 downto 0);
--        WD: in STD_LOGIC_VECTOR(15 downto 0);
--        clk: in STD_LOGIC;
--        RD1: out STD_LOGIC_VECTOR(15 downto 0);
--        RD2: out STD_LOGIC_VECTOR(15 downto 0);
--        RegWr: in STD_LOGIC
--    );
--end component;

component InstrFetch is
    Port (clk: in STD_LOGIC;
          rst : in STD_LOGIC;
          enablePC : in STD_LOGIC;
          BranchAddress : in STD_LOGIC_VECTOR(15 downto 0);
          JumpAddress : in STD_LOGIC_VECTOR(15 downto 0);
          Jump : in STD_LOGIC;
          PCSrc : in STD_LOGIC;
          Instruction : out STD_LOGIC_VECTOR(15 downto 0);
          nextA : out STD_LOGIC_VECTOR(15 downto 0));
end component;

component InstrDecode is
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
end component;

component UnitControl is
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
end component;

component UnitExec is
      Port ( 
           AdUrm:in STD_LOGIC_VECTOR(15 downto 0);
           RD1:in STD_LOGIC_VECTOR(15 downto 0);
           RD2:in STD_LOGIC_VECTOR(15 downto 0);
           ExtImm:in STD_LOGIC_VECTOR(15 downto 0);
           func:in STD_LOGIC_VECTOR(2 downto 0);
           sa:in STD_LOGIC;
           ALUSrc:in STD_LOGIC;
           ALUOp:in STD_LOGIC_VECTOR(2 downto 0);
           
           BranchAdd:out STD_LOGIC_VECTOR(15 downto 0);
           ALURes:out STD_LOGIC_VECTOR(15 downto 0);
           Zero:out STD_LOGIC
      );
end component;

component UnitMemory is
     Port ( 
          CLK:in STD_LOGIC; --pt scriere sincrona in memorie
          ALURes_in:in STD_LOGIC_VECTOR(15 downto 0); --lw/sw
          RD2:in STD_LOGIC_VECTOR(15 downto 0);
          MemWrite:in STD_LOGIC;    
          EN:in STD_LOGIC;    
              
          MemData:out STD_LOGIC_VECTOR(15 downto 0);
          ALURes:out STD_LOGIC_VECTOR(15 downto 0)
     );
end component;


--type tROM is array (0 to 255) of STD_LOGIC_VECTOR(15 downto 0);
--signal ROM: tROM := (
--    x"0001",
--    x"0005",
--    x"000A",
--    x"0F09",
--    x"FF10",
--    others => x"0000" );
    
--type RAM is array(0 to 255) of STD_LOGIC_VECTOR(15 downto 0);
--signal RAM: ram_type;
--begin
--process(clk)
--    begin
--        if clk'event and clk='1' then
--            if en='1' then
--                if WE='1' then
--                    RAM(conv_integer(adresa)) <= dataIN;
--                else dataOUT <= RAM(conv_integer(adresa));
--                end if;
--            end if;
--        end if;
--end process;

--signal en: STD_LOGIC:='0';
--signal cnt: STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
--signal do: STD_LOGIC_VECTOR(15 downto 0);
--signal CE: STD_LOGIC;
--signal cnt_mem: STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
--signal adder, substractor, leftShift, rightShift, 

signal RegDst, ExtOp, ALUSRC, Branch, Jump, MemWrite, MemtoReg, RegWrite, BrGez, BrNe: STD_LOGIC;
signal RD1, RD2, WD, Ext_imm, Ext_func, Ext_sa: STD_LOGIC_VECTOR(15 downto 0);
signal JumpAddr, BranchAddr, ALURes, rezultat, MemData : STD_LOGIC_VECTOR(15 downto 0);
signal func, ALUOp : STD_LOGIC_VECTOR(2 downto 0);
signal sa, Zero, en, reset, PCSrc: STD_LOGIC;
signal digits, inst, PCinc: STD_LOGIC_VECTOR(15 downto 0);

begin
    MPG: generator port map(clk, btn(0), en);
    MPG_2: generator port map(clk, btn(1), reset);
    --ExtragereaInstr: InstrFetch port map(clk, en, reset, x"0004", x"0000", sw(0), sw(1), inst, PCinc);
    SevenSegDis: SSD port map(clk, digits, an, cat);
    
    --ExtragereaInstr: InstrFetch port map(clk, en, reset, BranchAddr, JumpAddr, Jump, PCSrc, inst, PCinc);
    --DecodificareaInstr: InstrDecode port map(clk, inst(12 downto 0), WD, RegWrite, RegDst, ExtOp, en, Ext_imm, RD1, RD2, func, sa);
    UnitatePrincipalaControl: UnitControl port map(inst(15 downto 13), RegDst, ExtOp, ALUSRC, Branch, BrGez, BrNe, Jump, ALUOp, MemWrite, MemtoReg, RegWrite);
    Executie: UnitExec port map(PCinc, RD1, RD2, Ext_imm, func, sa, ALUSRC, ALUOp, BranchAddr, ALURes, Zero); 
    Memorie: UnitMemory port map(clk, ALURes, RD2, MemWrite, en, MemData, rezultat);
    ExtragereaInstr: InstrFetch port map(clk, en, reset, BranchAddr, JumpAddr, Jump, PCSrc, inst, PCinc);
    DecodificareaInstr: InstrDecode port map(clk, inst(12 downto 0), WD, RegWrite, RegDst, ExtOp, en, Ext_imm, RD1, RD2, func, sa);
    
    with MemtoReg select
        WD <= MemData when '1',
              rezultat when '0',
              (others => 'X') when others;
    
    PCSrc <= (Zero and Branch) or (BrNe and not(Zero));
    JumpAddr <= PCinc(15 downto 13) & inst(12 downto 0);
    
    --WD <= RD1 + RD2;
    --Ext_func <= "0000000000000"&func;
    --Ext_sa <= "000000000000000"&sa;
    --JumpAddr <= "000" & inst(12 downto 0);
    
   with sw(7 downto 5) select
       digits <= inst when "000",
                 PCinc when "001",
                 RD1 when "010",
                 RD2 when "011",
                 Ext_imm when "100",
                 ALURes when "101",
                 MemData when "110",
                 WD when "111",
       (others => 'X') when others;
       
    
--    process(sw(11))  --!
--    begin
--        case sw(11) is
--            when '1' => digits <= PCinc;
--            when '0' => digits <= inst;
--            when others => digits <= x"0000";
--        end case;
--    end process;
    
    led(10 downto 0) <= ALUOp & RegDst & ExtOp & ALUSRC & Branch & Jump & MemWrite & MemtoReg & RegWrite;
    
    --digits <= x"1235";
   -- digits <= inst;
    
    --MPG_PC: entity WORK.MPG port map(btn => btn(0), clk => clk, enab
    --MPG2: generator port map(clk, btn(1), reset);
    -- CE, btn(0), clk
    
   -- instr_IF: InstrFetch port map(clk, reset, en, x"0004", x"0000", sw(0), sw(1), Instruction, PCinc);
    --with sw(7) select
       -- digits <= PCinc when '1',
        --          Instruction when '0',
        --          (others => 'X') when others;
    --display: SSD port map (clk, digits, an, cat);
--process(clk, en)
--begin
--    if rising_edge(clk) then
--        if en='1' then
--            if sw(0)='1' then cnt <= cnt+1;
--            else cnt <= cnt-1;
--            end if;
--        end if;
--    end if;
--end process;

--adder <= ("000000000000" & sw(3 downto 0)) + ("000000000000" & sw(7 downto 4));
--substractor <= ("000000000000" & sw(3 downto 0)) - ("000000000000" & sw(7 downto 4));
--leftShift <= "000000" & sw(7 downto 0) & "00";
--rightShift <= "0000000000" & sw(7 downto 2);

--mux: process(cnt, adder, substractor, leftShift, rightShift)
--begin
--    case cnt is
--        when "00" => digits <= adder;
--        when "01" => digits <= substractor;
--        when "10" => digits <= leftShift;
--        when "11" => digits <= rightShift;
--        when others => digits <= (others => 'X');
--    end case;
--end process;

--do <= ROM(conv_integer(cnt));

--led(7) <= '1' when digits=0 else '0';

--process(clk)
--begin
--    if rising_edge(clk) then
--        case cnt is
--                when "0000" => led <= "0000000000000001";
--                when "0001" => led <= "0000000000000010";
--                when "0010" => led <= "0000000000000100";
--                when "0011" => led <= "0000000000001000";
--                when "0100" => led <= "0000000000010000";
--                when "0101" => led <= "0000000000100000";
--                when "0110" => led <= "0000000001000000";
--                when "0111" => led <= "0000000010000000";
--                when "1000" => led <= "0000000100000000";
--                when "1001" => led <= "0000001000000000";
--                when "1010" => led <= "0000010000000000";
--                when "1011" => led <= "0000100000000000";
--                when "1100" => led <= "0001000000000000";
--                when "1101" => led <= "0010000000000000";
--                when "1110" => led <= "0100000000000000";
--                when "1111" => led <= "1000000000000000";
--                when others => led <= "0000000000000000";
--        end case;
--     end if;
--end process;



--an <= btn(3 downto 0);
--cat <= (others=>'0');
--led <= cnt;

end Behavioral;
