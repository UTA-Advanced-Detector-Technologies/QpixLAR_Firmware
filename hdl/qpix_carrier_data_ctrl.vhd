-------------------------------------------------------------------------------
-- Title      : qpix_carrier_data_ctrl
-- Project    : ZyboQDB
-------------------------------------------------------------------------------
-- File       : qpix_carrier_data_ctrl.vhd
-- Author     : Kevin Keefe <kevin.keefe2@uta.edu>
-- Company    : University of Texas at Arlington
-- Created    : 2025-28-02
-- Last update: 2025-28-02
-- Platform   : Windows 11
-- Standard   : VHDL08
-------------------------------------------------------------------------------
-- Description:  modified version of SAQ Data control for use in qpix_carrier
-- SAQ Data Ctrl, controlled via SAQNode. Primary responsibility
-- is to correctly read / timestamp incoming data from physical ports of SAQ
-------------------------------------------------------------------------------
-- Copyright (c) 2022
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2022-09-06  1.0      keefe	Created
-------------------------------------------------------------------------------

library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

library work;
use work.QpixPkg.all;
use work.QpixProtoPkg.all;

-- fancy sl / slv alias'
use work.UtilityPkg.all;

entity qpix_carrier_data_ctrl is
generic (
  N_QPIX_PORTS    : natural := 16;
  TIMESTAMP_BITS  : natural := 64);      -- number of input QPIX channels to zturn
port (
  clk             : in  std_logic;
  rst             : in  std_logic;
  -- Data IO
  Q                : in  std_logic_vector(N_QPIX_PORTS - 1 downto 0);
  qpixCtrlOut      : out std_logic_vector(N_QPIX_PORTS + TIMESTAMP_BITS - 1 downto 0);
  qpixCtrlOutValid : out std_logic;
  -- Register Config ports
  qpixMask         : in  std_logic_vector(N_QPIX_PORTS-1 downto 0);
  qpixDiv          : in  std_logic_vector(TIMESTAMP_BITS-1 downto 0)
  );
  
end qpix_carrier_data_ctrl;

architecture Behavioral of qpix_carrier_data_ctrl is

  -- timestamp on the QPIX hits
  signal counter : slv(TIMESTAMP_BITS-1 downto 0) := (others => '0');

  -- edge detector data
  signal qpixPortDataE : slv(N_QPIX_PORTS-1 downto 0) := (others => '0');
  signal trigger       : sl                           := '0';

  constant qpixDataEmpty : slv(N_QPIX_PORTS-1 downto 0) := (others => '0');

begin  -- architecture qpix_carrier_data_ctrl

   -- increment counter
   process (clk, counter)
     variable local_cnt : unsigned(TIMESTAMP_BITS-1 downto 0) := (others => '0');
   begin
      if rising_edge(clk) then
         local_cnt := local_cnt + 1;
         if rst = '1' then
            counter <= (others => '0');
            local_cnt := (others => '0');
         elsif local_cnt >= unsigned(qpixDiv) then
            counter <= counter + 1;
            local_cnt := (others => '0');
         end if;
      end if;
   end process;

   -- edge detector on the QPIX data
   QPIX_ANALOG_IN_GEN : for i in 0 to N_QPIX_PORTS-1 generate
      QPIX_PulseEdge_U : entity work.EdgeDetector
         port map(
            clk    => clk,
            rst    => rst,
            input  => Q(i),
            output => qpixPortDataE(i)
         );
   end generate QPIX_ANALOG_IN_GEN;

   ---------------------------------------------------
   -- Data Ctrl
   ---------------------------------------------------
   -- if we get a trigger, then we should format the data and send
   -- it to the FIFO
   process (clk, trigger, counter)
     variable trg : slv(N_QPIX_PORTS-1 downto 0) := (others => '0');
   begin
      if rising_edge(clk) then
         qpixCtrlOutValid <= '0';
         -- if trigger = '1' then
         for i in N_QPIX_PORTS - 1 downto 0 loop
             trg(i) := qpixPortDataE(i) and qpixMask(i);
         end loop;
         if trg /= qpixDataEmpty then
             qpixCtrlOutValid <= '1';
             qpixCtrlOut      <= qpixPortDataE & counter;
         end if;
      end if;
   end process;

end architecture Behavioral;