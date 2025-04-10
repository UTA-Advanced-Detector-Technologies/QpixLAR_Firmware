-------------------------------------------------------------------------------
-- Title         : TransactRegMap
-- Project       : IFDD
-------------------------------------------------------------------------------
-- File          : TransactRegMap.v
-- Author        : Kevin Keefe  <Kevin.Keefe@uta.edu>
-- Created       : Dec. 20. 2024
-------------------------------------------------------------------------------
-- Description :
-- Transaction register map 
-------------------------------------------------------------------------------
-- Modification history :
-- Created       : Oct. 8. 2024
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

library work;

entity TransactRegiMap is
   generic (
      Version : std_logic_vector(31 downto 0) := x"0000_0000"
   );
   port (
      clk         : in std_logic;
      -- rst         : in std_logic;

      -- 
      -- Interface pins
      -- 
      reg_0       : out std_logic_vector(31 downto 0);
      reg_1       : out std_logic_vector(31 downto 0);
      reg_2       : out std_logic_vector(31 downto 0);
      reg_3       : out std_logic_vector(31 downto 0);
      reg_4       : out std_logic_vector(31 downto 0);
      reg_5       : out std_logic_vector(31 downto 0);
      reg_6       : out std_logic_vector(31 downto 0);
      reg_7       : out std_logic_vector(31 downto 0);
      reg_8       : out std_logic_vector(31 downto 0);
      reg_9       : out std_logic_vector(31 downto 0);
      reg_a       : out std_logic_vector(31 downto 0);

      -- 
      -- Qpix Carrier Specific registers
      -- 
      SHDN         : out std_logic_vector(15 downto 0);
      QpixMask     : out std_logic_vector(15 downto 0);
      PacketLength : out std_logic_vector(31 downto 0);
      -- spi register controls
      load_DAC1    : out std_logic;
      DAC_reg1     : out std_logic_vector(15 downto 0);
      load_DAC2    : out std_logic;
      DAC_reg2     : out std_logic_vector(15 downto 0);

      force_valid  : out std_logic;

      -- interface to AXI slave module
      addr        : in  std_logic_vector(31 downto 0);
      rdata       : out std_logic_vector(31 downto 0);
      wdata       : in  std_logic_vector(31 downto 0);
      req         : in  std_logic;
      wen         : in  std_logic;
      ack         : out std_logic
   );
end entity TransactRegiMap;

architecture behav of TransactRegiMap is

   -- select addr subspace
   signal a_reg_addr   : std_logic_vector(15 downto 0)  := x"0000";
   signal scratch_word : std_logic_vector(31 downto 0) := x"05a7cafe";
   signal s_reg_0      : std_logic_vector(31 downto 0);
   signal s_reg_1      : std_logic_vector(31 downto 0);
   signal s_reg_2      : std_logic_vector(31 downto 0);
   signal s_reg_3      : std_logic_vector(31 downto 0);
   signal s_reg_4      : std_logic_vector(31 downto 0);
   signal s_reg_5      : std_logic_vector(31 downto 0);
   signal s_reg_6      : std_logic_vector(31 downto 0);
   signal s_reg_7      : std_logic_vector(31 downto 0);
   signal s_reg_8      : std_logic_vector(31 downto 0);
   signal s_reg_9      : std_logic_vector(31 downto 0);
   signal s_reg_a      : std_logic_vector(31 downto 0);

   -- qpix carrier specific
   signal s_SHDN         : std_logic_vector(15 downto 0);
   signal s_QpixMask     : std_logic_vector(15 downto 0);
   signal s_PacketLength : std_logic_vector(31 downto 0);
   signal s_DAC_reg1     : std_logic_vector(15 downto 0);
   signal s_DAC_reg2     : std_logic_vector(15 downto 0);
   signal s_force_valid  : std_logic;

begin

   a_reg_addr <= addr(15 downto 0);

   process (clk)
      variable count : unsigned(31 downto 0) := (others => '0');
   begin
      if rising_edge (clk) then

         -- defaults
         ack                  <= req;

         -- assignments
         reg_0 <= s_reg_0;
         reg_1 <= s_reg_1;
         reg_2 <= s_reg_2;
         reg_3 <= s_reg_3;
         reg_4 <= s_reg_4;
         reg_5 <= s_reg_5;
         reg_6 <= s_reg_6;
         reg_7 <= s_reg_7;
         reg_8 <= s_reg_8;
         reg_9 <= s_reg_9;
         reg_a <= s_reg_a;

         -- carrier specific
         SHDN         <= s_SHDN;
         QpixMask     <= s_QpixMask;
         PacketLength <= s_PacketLength;
         DAC_reg1     <= s_DAC_reg1;

         force_valid  <= s_force_valid;
         
         -- pulsed values
         load_DAC1 <= '0';
         load_DAC2 <= '0';
       
         -- reg mapping
         case a_reg_addr is

            -- scratchpad IO
            when x"0000" =>
               if wen = '1' and req = '1' then
                  scratch_word <= wdata;
               else
                  rdata <= scratch_word;
               end if;

            when x"0004" =>
               if wen = '1' and req = '1' then
                  s_reg_0 <= wdata;
               else
                  rdata <= s_reg_0;
               end if;

            when x"0008" =>
               if wen = '1' and req = '1' then
                  s_reg_1 <= wdata;
               else
                  rdata <= s_reg_1;
               end if;

            when x"000C" =>
               if wen = '1' and req = '1' then
                  s_reg_2 <= wdata;
               else
                  rdata <= s_reg_1;
               end if;

            when x"0010" =>
               if wen = '1' and req = '1' then
                  s_reg_3 <= wdata;
               else
                  rdata <= s_reg_3;
               end if;

            when x"0014" =>
               if wen = '1' and req = '1' then
                  s_reg_4 <= wdata;
               else
                  rdata <= s_reg_4;
               end if;

            when x"0018" =>
               if wen = '1' and req = '1' then
                  s_reg_5 <= wdata;
               else
                  rdata <= s_reg_5;
               end if;

            when x"001C" =>
               if wen = '1' and req = '1' then
                  s_reg_6 <= wdata;
               else
                  rdata <= s_reg_6;
               end if;

            when x"0020" =>
               if wen = '1' and req = '1' then
                  s_reg_7 <= wdata;
               else
                  rdata <= s_reg_7;
               end if;

            when x"0024" =>
               if wen = '1' and req = '1' then
                  s_reg_8 <= wdata;
               else
                  rdata <= s_reg_8;
               end if;

            when x"0028" =>
               if wen = '1' and req = '1' then
                  s_reg_9 <= wdata;
               else
                  rdata <= s_reg_9;
               end if;

            -- ..used to select deltaT synchronization
            when x"002C" =>
               if wen = '1' and req = '1' then
                  s_reg_a <= wdata;
               else
                  rdata <= s_reg_a;
               end if;

            -- control register offsets
            when x"1000" =>
               if wen = '1' and req = '1' then
                  s_SHDN <= wdata(15 downto 0);
               else
                  rdata(15 downto 0) <= s_SHDN;
               end if;

            when x"1004" =>
               if wen = '1' and req = '1' then
                  s_QpixMask <= wdata(15 downto 0);
               else
                  rdata(15 downto 0) <= s_QpixMask;
               end if;

            when x"1008" =>
               if wen = '1' and req = '1' then
                  s_PacketLength <= wdata;
               else
                  rdata <= s_PacketLength;
               end if;

            when x"100C" =>
               if wen = '1' and req = '1' then
                  s_DAC_reg1 <= wdata(15 downto 0);
                  load_DAC1  <= '1';
               else
                  rdata    <= (others => '0');
                  rdata(15 downto 0) <= s_DAC_reg1;
               end if;

            when x"1010" =>
               if wen = '1' and req = '1' then
                  s_DAC_reg2 <= wdata(15 downto 0);
                  load_DAC2  <= '1';
               else
                  rdata    <= (others => '0');
                  rdata(15 downto 0) <= s_DAC_reg2;
               end if;

            -- enable a valid override to enable
            -- any and all triggers from LTC chips
            when x"1014" =>
               if wen = '1' and req = '1' then
                  s_force_valid <= wdata(0);
               else
                  rdata    <= (others => '0');
                  rdata(0) <= s_force_valid;
               end if;

            when others =>
               rdata <= x"aBAD_ADD0";

         end case;

      end if;
         
   end process;

end behav;
