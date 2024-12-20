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
-- take it, it's yours
-- (Brad Pitt in Troy)
--------------------------------------------------------------------------------
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


begin

   a_reg_addr <= addr(15 downto 0);

   process (clk)
      variable count : unsigned(31 downto 0) := (others => '0');
   begin
      if rising_edge (clk) then

         -- defaults
         ack                  <= req;


         -- TODO, track when PHY_BUS_RST is actually asserted

         -- reg mapping
         case a_reg_addr is

            -- scratchpad IO
            when x"0000" =>
               if wen = '1' and req = '1' then
                  scratch_word <= wdata;
               else
                  rdata <= scratch_word;
               end if;


            when others =>
               rdata <= x"aBAD_ADD0";

         end case;

      end if;
         
   end process;

end behav;
