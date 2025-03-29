
################################################################
# This is a generated script based on design: qpixlar_bd
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2024.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   if { [string compare $scripts_vivado_version $current_vivado_version] > 0 } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2042 -severity "ERROR" " This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Sourcing the script failed since it was created with a future version of Vivado."}

   } else {
     catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   }

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source qpixlar_bd_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# AxiLiteSlaveSimple, TransactRegiMap, qpix_reg_rtl, qpix_carrier_data_ctrl, qpix_carrier_fifo_ctrl, spi_interface_ctrl

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z020clg400-1
   set_property BOARD_PART myir.com:mys-7z020:part0:2.1 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name qpixlar_bd

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:processing_system7:5.5\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:axi_dma:7.1\
xilinx.com:ip:axis_data_fifo:2.0\
xilinx.com:ip:fifo_generator:13.2\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:xlconcat:2.1\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
AxiLiteSlaveSimple\
TransactRegiMap\
qpix_reg_rtl\
qpix_carrier_data_ctrl\
qpix_carrier_fifo_ctrl\
spi_interface_ctrl\
"

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]

  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]


  # Create ports
  set opad_DataOut1 [ create_bd_port -dir I opad_DataOut1 ]
  set opad_DataOut2 [ create_bd_port -dir I opad_DataOut2 ]
  set opad_deltaT [ create_bd_port -dir I opad_deltaT ]
  set opad2_DataOut1 [ create_bd_port -dir I opad2_DataOut1 ]
  set opad2_DataOut2 [ create_bd_port -dir I opad2_DataOut2 ]
  set opad2_deltaT [ create_bd_port -dir I opad2_deltaT ]
  set opad_Ext_POR [ create_bd_port -dir O opad_Ext_POR ]
  set opad_CLKin [ create_bd_port -dir O -type clk opad_CLKin ]
  set opad_CLKin2 [ create_bd_port -dir O opad_CLKin2 ]
  set opad_DataIn [ create_bd_port -dir O opad_DataIn ]
  set opad_control [ create_bd_port -dir O opad_control ]
  set opad_loadData [ create_bd_port -dir O opad_loadData ]
  set opad_selDefData [ create_bd_port -dir O opad_selDefData ]
  set opad_serialOutCnt [ create_bd_port -dir O opad_serialOutCnt ]
  set opad_startup [ create_bd_port -dir O opad_startup ]
  set opad_cal_control [ create_bd_port -dir O opad_cal_control ]
  set opad_RST_EXT [ create_bd_port -dir O opad_RST_EXT ]
  set opad_CLK [ create_bd_port -dir O -type clk opad_CLK ]
  set opad2_CLKin [ create_bd_port -dir O -type clk opad2_CLKin ]
  set opad2_CLKin2 [ create_bd_port -dir O opad2_CLKin2 ]
  set opad2_DataIn [ create_bd_port -dir O opad2_DataIn ]
  set opad2_control [ create_bd_port -dir O opad2_control ]
  set opad2_loadData [ create_bd_port -dir O opad2_loadData ]
  set opad2_selDefData [ create_bd_port -dir O opad2_selDefData ]
  set opad2_serialOutCnt [ create_bd_port -dir O opad2_serialOutCnt ]
  set opad2_startup [ create_bd_port -dir O opad2_startup ]
  set opad2_cal_control [ create_bd_port -dir O opad2_cal_control ]
  set opad2_RST_EXT [ create_bd_port -dir O opad2_RST_EXT ]
  set opad2_CLK [ create_bd_port -dir O -type clk opad2_CLK ]
  set SHDN [ create_bd_port -dir O -from 15 -to 0 SHDN ]
  set Q [ create_bd_port -dir I -from 15 -to 0 Q ]
  set SDI [ create_bd_port -dir O SDI ]
  set SCK [ create_bd_port -dir O SCK ]
  set bCS [ create_bd_port -dir O -from 1 -to 0 bCS ]
  set bLDAC [ create_bd_port -dir O bLDAC ]

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [list \
    CONFIG.PCW_ACT_APU_PERIPHERAL_FREQMHZ {500.000000} \
    CONFIG.PCW_ACT_CAN_PERIPHERAL_FREQMHZ {100.000000} \
    CONFIG.PCW_ACT_DCI_PERIPHERAL_FREQMHZ {10.158730} \
    CONFIG.PCW_ACT_ENET0_PERIPHERAL_FREQMHZ {125.000000} \
    CONFIG.PCW_ACT_ENET1_PERIPHERAL_FREQMHZ {10.000000} \
    CONFIG.PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ {200.000000} \
    CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ {50.000000} \
    CONFIG.PCW_ACT_FPGA2_PERIPHERAL_FREQMHZ {10.000000} \
    CONFIG.PCW_ACT_FPGA3_PERIPHERAL_FREQMHZ {10.000000} \
    CONFIG.PCW_ACT_PCAP_PERIPHERAL_FREQMHZ {200.000000} \
    CONFIG.PCW_ACT_QSPI_PERIPHERAL_FREQMHZ {200.000000} \
    CONFIG.PCW_ACT_SDIO_PERIPHERAL_FREQMHZ {100.000000} \
    CONFIG.PCW_ACT_SMC_PERIPHERAL_FREQMHZ {10.000000} \
    CONFIG.PCW_ACT_SPI_PERIPHERAL_FREQMHZ {10.000000} \
    CONFIG.PCW_ACT_TPIU_PERIPHERAL_FREQMHZ {200.000000} \
    CONFIG.PCW_ACT_TTC0_CLK0_PERIPHERAL_FREQMHZ {83.333336} \
    CONFIG.PCW_ACT_TTC0_CLK1_PERIPHERAL_FREQMHZ {83.333336} \
    CONFIG.PCW_ACT_TTC0_CLK2_PERIPHERAL_FREQMHZ {83.333336} \
    CONFIG.PCW_ACT_TTC1_CLK0_PERIPHERAL_FREQMHZ {83.333336} \
    CONFIG.PCW_ACT_TTC1_CLK1_PERIPHERAL_FREQMHZ {83.333336} \
    CONFIG.PCW_ACT_TTC1_CLK2_PERIPHERAL_FREQMHZ {83.333336} \
    CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ {100.000000} \
    CONFIG.PCW_ACT_WDT_PERIPHERAL_FREQMHZ {83.333336} \
    CONFIG.PCW_APU_CLK_RATIO_ENABLE {6:2:1} \
    CONFIG.PCW_APU_PERIPHERAL_FREQMHZ {666.666666} \
    CONFIG.PCW_CAN0_CAN0_IO {MIO 14 .. 15} \
    CONFIG.PCW_CAN0_GRP_CLK_ENABLE {0} \
    CONFIG.PCW_CAN0_PERIPHERAL_ENABLE {1} \
    CONFIG.PCW_CAN_PERIPHERAL_FREQMHZ {100} \
    CONFIG.PCW_CAN_PERIPHERAL_VALID {1} \
    CONFIG.PCW_CLK0_FREQ {200000000} \
    CONFIG.PCW_CLK1_FREQ {50000000} \
    CONFIG.PCW_CLK2_FREQ {10000000} \
    CONFIG.PCW_CLK3_FREQ {10000000} \
    CONFIG.PCW_CPU_CPU_6X4X_MAX_RANGE {667} \
    CONFIG.PCW_CPU_PERIPHERAL_CLKSRC {ARM PLL} \
    CONFIG.PCW_CRYSTAL_PERIPHERAL_FREQMHZ {33.333333} \
    CONFIG.PCW_DDR_PERIPHERAL_CLKSRC {DDR PLL} \
    CONFIG.PCW_DDR_RAM_HIGHADDR {0x3FFFFFFF} \
    CONFIG.PCW_DM_WIDTH {4} \
    CONFIG.PCW_DQS_WIDTH {4} \
    CONFIG.PCW_DQ_WIDTH {32} \
    CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27} \
    CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
    CONFIG.PCW_ENET0_GRP_MDIO_IO {MIO 52 .. 53} \
    CONFIG.PCW_ENET0_PERIPHERAL_CLKSRC {ARM PLL} \
    CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
    CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ {1000 Mbps} \
    CONFIG.PCW_ENET0_RESET_ENABLE {0} \
    CONFIG.PCW_ENET_RESET_ENABLE {1} \
    CONFIG.PCW_ENET_RESET_SELECT {Share reset pin} \
    CONFIG.PCW_EN_CAN0 {1} \
    CONFIG.PCW_EN_CLK0_PORT {1} \
    CONFIG.PCW_EN_CLK1_PORT {1} \
    CONFIG.PCW_EN_CLK2_PORT {0} \
    CONFIG.PCW_EN_CLK3_PORT {0} \
    CONFIG.PCW_EN_DDR {1} \
    CONFIG.PCW_EN_EMIO_I2C0 {1} \
    CONFIG.PCW_EN_EMIO_TTC0 {1} \
    CONFIG.PCW_EN_EMIO_UART0 {0} \
    CONFIG.PCW_EN_ENET0 {1} \
    CONFIG.PCW_EN_GPIO {1} \
    CONFIG.PCW_EN_I2C0 {1} \
    CONFIG.PCW_EN_I2C1 {1} \
    CONFIG.PCW_EN_QSPI {1} \
    CONFIG.PCW_EN_RST0_PORT {1} \
    CONFIG.PCW_EN_RST1_PORT {0} \
    CONFIG.PCW_EN_RST2_PORT {0} \
    CONFIG.PCW_EN_RST3_PORT {0} \
    CONFIG.PCW_EN_SDIO0 {1} \
    CONFIG.PCW_EN_TTC0 {1} \
    CONFIG.PCW_EN_UART0 {1} \
    CONFIG.PCW_EN_UART1 {1} \
    CONFIG.PCW_EN_USB0 {1} \
    CONFIG.PCW_FCLK0_PERIPHERAL_CLKSRC {IO PLL} \
    CONFIG.PCW_FCLK1_PERIPHERAL_CLKSRC {IO PLL} \
    CONFIG.PCW_FCLK2_PERIPHERAL_CLKSRC {IO PLL} \
    CONFIG.PCW_FCLK3_PERIPHERAL_CLKSRC {IO PLL} \
    CONFIG.PCW_FCLK_CLK0_BUF {FALSE} \
    CONFIG.PCW_FCLK_CLK1_BUF {FALSE} \
    CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {200} \
    CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {50} \
    CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {125} \
    CONFIG.PCW_FPGA3_PERIPHERAL_FREQMHZ {50} \
    CONFIG.PCW_FPGA_FCLK0_ENABLE {1} \
    CONFIG.PCW_FPGA_FCLK1_ENABLE {1} \
    CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {0} \
    CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} \
    CONFIG.PCW_GPIO_MIO_GPIO_IO {MIO} \
    CONFIG.PCW_GPIO_PERIPHERAL_ENABLE {1} \
    CONFIG.PCW_I2C0_I2C0_IO {EMIO} \
    CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {1} \
    CONFIG.PCW_I2C0_RESET_ENABLE {0} \
    CONFIG.PCW_I2C1_GRP_INT_ENABLE {0} \
    CONFIG.PCW_I2C1_I2C1_IO {MIO 12 .. 13} \
    CONFIG.PCW_I2C1_PERIPHERAL_ENABLE {1} \
    CONFIG.PCW_I2C_PERIPHERAL_FREQMHZ {83.333336} \
    CONFIG.PCW_I2C_RESET_ENABLE {1} \
    CONFIG.PCW_I2C_RESET_SELECT {Share reset pin} \
    CONFIG.PCW_IRQ_F2P_INTR {1} \
    CONFIG.PCW_MIO_0_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_0_PULLUP {enabled} \
    CONFIG.PCW_MIO_0_SLEW {slow} \
    CONFIG.PCW_MIO_10_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_10_PULLUP {enabled} \
    CONFIG.PCW_MIO_10_SLEW {slow} \
    CONFIG.PCW_MIO_11_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_11_PULLUP {enabled} \
    CONFIG.PCW_MIO_11_SLEW {slow} \
    CONFIG.PCW_MIO_12_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_12_PULLUP {enabled} \
    CONFIG.PCW_MIO_12_SLEW {slow} \
    CONFIG.PCW_MIO_13_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_13_PULLUP {enabled} \
    CONFIG.PCW_MIO_13_SLEW {slow} \
    CONFIG.PCW_MIO_14_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_14_PULLUP {enabled} \
    CONFIG.PCW_MIO_14_SLEW {slow} \
    CONFIG.PCW_MIO_15_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_15_PULLUP {enabled} \
    CONFIG.PCW_MIO_15_SLEW {slow} \
    CONFIG.PCW_MIO_16_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_16_PULLUP {enabled} \
    CONFIG.PCW_MIO_16_SLEW {slow} \
    CONFIG.PCW_MIO_17_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_17_PULLUP {enabled} \
    CONFIG.PCW_MIO_17_SLEW {slow} \
    CONFIG.PCW_MIO_18_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_18_PULLUP {enabled} \
    CONFIG.PCW_MIO_18_SLEW {slow} \
    CONFIG.PCW_MIO_19_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_19_PULLUP {enabled} \
    CONFIG.PCW_MIO_19_SLEW {slow} \
    CONFIG.PCW_MIO_1_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_1_PULLUP {disabled} \
    CONFIG.PCW_MIO_1_SLEW {slow} \
    CONFIG.PCW_MIO_20_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_20_PULLUP {enabled} \
    CONFIG.PCW_MIO_20_SLEW {slow} \
    CONFIG.PCW_MIO_21_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_21_PULLUP {enabled} \
    CONFIG.PCW_MIO_21_SLEW {slow} \
    CONFIG.PCW_MIO_22_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_22_PULLUP {enabled} \
    CONFIG.PCW_MIO_22_SLEW {slow} \
    CONFIG.PCW_MIO_23_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_23_PULLUP {enabled} \
    CONFIG.PCW_MIO_23_SLEW {slow} \
    CONFIG.PCW_MIO_24_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_24_PULLUP {enabled} \
    CONFIG.PCW_MIO_24_SLEW {slow} \
    CONFIG.PCW_MIO_25_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_25_PULLUP {enabled} \
    CONFIG.PCW_MIO_25_SLEW {slow} \
    CONFIG.PCW_MIO_26_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_26_PULLUP {enabled} \
    CONFIG.PCW_MIO_26_SLEW {slow} \
    CONFIG.PCW_MIO_27_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_27_PULLUP {enabled} \
    CONFIG.PCW_MIO_27_SLEW {slow} \
    CONFIG.PCW_MIO_28_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_28_PULLUP {enabled} \
    CONFIG.PCW_MIO_28_SLEW {slow} \
    CONFIG.PCW_MIO_29_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_29_PULLUP {enabled} \
    CONFIG.PCW_MIO_29_SLEW {slow} \
    CONFIG.PCW_MIO_2_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_2_SLEW {slow} \
    CONFIG.PCW_MIO_30_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_30_PULLUP {enabled} \
    CONFIG.PCW_MIO_30_SLEW {slow} \
    CONFIG.PCW_MIO_31_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_31_PULLUP {enabled} \
    CONFIG.PCW_MIO_31_SLEW {slow} \
    CONFIG.PCW_MIO_32_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_32_PULLUP {enabled} \
    CONFIG.PCW_MIO_32_SLEW {slow} \
    CONFIG.PCW_MIO_33_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_33_PULLUP {enabled} \
    CONFIG.PCW_MIO_33_SLEW {slow} \
    CONFIG.PCW_MIO_34_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_34_PULLUP {enabled} \
    CONFIG.PCW_MIO_34_SLEW {slow} \
    CONFIG.PCW_MIO_35_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_35_PULLUP {enabled} \
    CONFIG.PCW_MIO_35_SLEW {slow} \
    CONFIG.PCW_MIO_36_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_36_PULLUP {enabled} \
    CONFIG.PCW_MIO_36_SLEW {slow} \
    CONFIG.PCW_MIO_37_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_37_PULLUP {enabled} \
    CONFIG.PCW_MIO_37_SLEW {slow} \
    CONFIG.PCW_MIO_38_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_38_PULLUP {enabled} \
    CONFIG.PCW_MIO_38_SLEW {slow} \
    CONFIG.PCW_MIO_39_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_39_PULLUP {enabled} \
    CONFIG.PCW_MIO_39_SLEW {slow} \
    CONFIG.PCW_MIO_3_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_3_SLEW {slow} \
    CONFIG.PCW_MIO_40_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_40_PULLUP {enabled} \
    CONFIG.PCW_MIO_40_SLEW {slow} \
    CONFIG.PCW_MIO_41_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_41_PULLUP {enabled} \
    CONFIG.PCW_MIO_41_SLEW {slow} \
    CONFIG.PCW_MIO_42_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_42_PULLUP {enabled} \
    CONFIG.PCW_MIO_42_SLEW {slow} \
    CONFIG.PCW_MIO_43_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_43_PULLUP {enabled} \
    CONFIG.PCW_MIO_43_SLEW {slow} \
    CONFIG.PCW_MIO_44_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_44_PULLUP {enabled} \
    CONFIG.PCW_MIO_44_SLEW {slow} \
    CONFIG.PCW_MIO_45_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_45_PULLUP {enabled} \
    CONFIG.PCW_MIO_45_SLEW {slow} \
    CONFIG.PCW_MIO_46_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_46_PULLUP {disabled} \
    CONFIG.PCW_MIO_46_SLEW {slow} \
    CONFIG.PCW_MIO_47_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_47_PULLUP {disabled} \
    CONFIG.PCW_MIO_47_SLEW {slow} \
    CONFIG.PCW_MIO_48_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_48_PULLUP {enabled} \
    CONFIG.PCW_MIO_48_SLEW {slow} \
    CONFIG.PCW_MIO_49_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_49_PULLUP {enabled} \
    CONFIG.PCW_MIO_49_SLEW {slow} \
    CONFIG.PCW_MIO_4_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_4_SLEW {slow} \
    CONFIG.PCW_MIO_50_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_50_PULLUP {disabled} \
    CONFIG.PCW_MIO_50_SLEW {slow} \
    CONFIG.PCW_MIO_51_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_51_PULLUP {disabled} \
    CONFIG.PCW_MIO_51_SLEW {slow} \
    CONFIG.PCW_MIO_52_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_52_PULLUP {enabled} \
    CONFIG.PCW_MIO_52_SLEW {slow} \
    CONFIG.PCW_MIO_53_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_53_PULLUP {enabled} \
    CONFIG.PCW_MIO_53_SLEW {slow} \
    CONFIG.PCW_MIO_5_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_5_SLEW {slow} \
    CONFIG.PCW_MIO_6_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_6_SLEW {slow} \
    CONFIG.PCW_MIO_7_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_7_SLEW {slow} \
    CONFIG.PCW_MIO_8_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_8_SLEW {slow} \
    CONFIG.PCW_MIO_9_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_9_PULLUP {disabled} \
    CONFIG.PCW_MIO_9_SLEW {slow} \
    CONFIG.PCW_MIO_PRIMITIVE {54} \
    CONFIG.PCW_MIO_TREE_PERIPHERALS {GPIO#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#GPIO#Quad SPI Flash#GPIO#UART 0#UART 0#I2C 1#I2C 1#CAN 0#CAN 0#Enet 0#Enet\
0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#UART 1#UART 1#GPIO#USB\
Reset#Enet 0#Enet 0} \
    CONFIG.PCW_MIO_TREE_SIGNALS {gpio[0]#qspi0_ss_b#qspi0_io[0]#qspi0_io[1]#qspi0_io[2]#qspi0_io[3]/HOLD_B#qspi0_sclk#gpio[7]#qspi_fbclk#gpio[9]#rx#tx#scl#sda#rx#tx#tx_clk#txd[0]#txd[1]#txd[2]#txd[3]#tx_ctl#rx_clk#rxd[0]#rxd[1]#rxd[2]#rxd[3]#rx_ctl#data[4]#dir#stp#nxt#data[0]#data[1]#data[2]#data[3]#clk#data[5]#data[6]#data[7]#clk#cmd#data[0]#data[1]#data[2]#data[3]#cd#wp#tx#rx#gpio[50]#reset#mdc#mdio}\
\
    CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY0 {0.089} \
    CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY1 {0.075} \
    CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY2 {0.085} \
    CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY3 {0.092} \
    CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_0 {-0.025} \
    CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_1 {0.014} \
    CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_2 {-0.009} \
    CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_3 {-0.033} \
    CONFIG.PCW_PACKAGE_NAME {clg400} \
    CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 3.3V} \
    CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} \
    CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {1} \
    CONFIG.PCW_QSPI_GRP_FBCLK_IO {MIO 8} \
    CONFIG.PCW_QSPI_GRP_IO1_ENABLE {0} \
    CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
    CONFIG.PCW_QSPI_GRP_SINGLE_SS_IO {MIO 1 .. 6} \
    CONFIG.PCW_QSPI_GRP_SS1_ENABLE {0} \
    CONFIG.PCW_QSPI_PERIPHERAL_CLKSRC {IO PLL} \
    CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} \
    CONFIG.PCW_QSPI_PERIPHERAL_FREQMHZ {200} \
    CONFIG.PCW_QSPI_QSPI_IO {MIO 1 .. 6} \
    CONFIG.PCW_SD0_GRP_CD_ENABLE {1} \
    CONFIG.PCW_SD0_GRP_CD_IO {MIO 46} \
    CONFIG.PCW_SD0_GRP_POW_ENABLE {0} \
    CONFIG.PCW_SD0_GRP_WP_ENABLE {1} \
    CONFIG.PCW_SD0_GRP_WP_IO {MIO 47} \
    CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
    CONFIG.PCW_SD0_SD0_IO {MIO 40 .. 45} \
    CONFIG.PCW_SDIO_PERIPHERAL_CLKSRC {IO PLL} \
    CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {100} \
    CONFIG.PCW_SDIO_PERIPHERAL_VALID {1} \
    CONFIG.PCW_SINGLE_QSPI_DATA_MODE {x4} \
    CONFIG.PCW_TTC0_CLK0_PERIPHERAL_CLKSRC {CPU_1X} \
    CONFIG.PCW_TTC0_CLK1_PERIPHERAL_CLKSRC {CPU_1X} \
    CONFIG.PCW_TTC0_CLK2_PERIPHERAL_CLKSRC {CPU_1X} \
    CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {1} \
    CONFIG.PCW_TTC0_TTC0_IO {EMIO} \
    CONFIG.PCW_TTC_PERIPHERAL_FREQMHZ {50} \
    CONFIG.PCW_UART0_GRP_FULL_ENABLE {0} \
    CONFIG.PCW_UART0_PERIPHERAL_ENABLE {1} \
    CONFIG.PCW_UART0_UART0_IO {MIO 10 .. 11} \
    CONFIG.PCW_UART1_GRP_FULL_ENABLE {0} \
    CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} \
    CONFIG.PCW_UART1_UART1_IO {MIO 48 .. 49} \
    CONFIG.PCW_UART_PERIPHERAL_CLKSRC {IO PLL} \
    CONFIG.PCW_UART_PERIPHERAL_FREQMHZ {100} \
    CONFIG.PCW_UART_PERIPHERAL_VALID {1} \
    CONFIG.PCW_UIPARAM_ACT_DDR_FREQ_MHZ {533.333374} \
    CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.271} \
    CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.259} \
    CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {0.219} \
    CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {0.207} \
    CONFIG.PCW_UIPARAM_DDR_CLOCK_0_LENGTH_MM {0} \
    CONFIG.PCW_UIPARAM_DDR_CLOCK_1_LENGTH_MM {0} \
    CONFIG.PCW_UIPARAM_DDR_CLOCK_2_LENGTH_MM {0} \
    CONFIG.PCW_UIPARAM_DDR_CLOCK_3_LENGTH_MM {0} \
    CONFIG.PCW_UIPARAM_DDR_DQS_0_LENGTH_MM {0} \
    CONFIG.PCW_UIPARAM_DDR_DQS_1_LENGTH_MM {0} \
    CONFIG.PCW_UIPARAM_DDR_DQS_2_LENGTH_MM {0} \
    CONFIG.PCW_UIPARAM_DDR_DQS_3_LENGTH_MM {0} \
    CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {0.229} \
    CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {0.250} \
    CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {0.121} \
    CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {0.146} \
    CONFIG.PCW_UIPARAM_DDR_DQ_0_LENGTH_MM {0} \
    CONFIG.PCW_UIPARAM_DDR_DQ_1_LENGTH_MM {0} \
    CONFIG.PCW_UIPARAM_DDR_DQ_2_LENGTH_MM {0} \
    CONFIG.PCW_UIPARAM_DDR_DQ_3_LENGTH_MM {0} \
    CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41J256M16 RE-125} \
    CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE {1} \
    CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE {1} \
    CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {1} \
    CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF {0} \
    CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1} \
    CONFIG.PCW_USB0_RESET_ENABLE {1} \
    CONFIG.PCW_USB0_RESET_IO {MIO 51} \
    CONFIG.PCW_USB0_USB0_IO {MIO 28 .. 39} \
    CONFIG.PCW_USB_RESET_ENABLE {1} \
    CONFIG.PCW_USB_RESET_SELECT {Share reset pin} \
    CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
    CONFIG.PCW_USE_M_AXI_GP0 {1} \
    CONFIG.PCW_USE_M_AXI_GP1 {0} \
    CONFIG.PCW_USE_S_AXI_HP0 {1} \
  ] $processing_system7_0


  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property CONFIG.NUM_MI {2} $axi_interconnect_0


  # Create instance: AxiLiteSlaveSimple_0, and set properties
  set block_name AxiLiteSlaveSimple
  set block_cell_name AxiLiteSlaveSimple_0
  if { [catch {set AxiLiteSlaveSimple_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $AxiLiteSlaveSimple_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: TransactRegiMap_0, and set properties
  set block_name TransactRegiMap
  set block_cell_name TransactRegiMap_0
  if { [catch {set TransactRegiMap_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $TransactRegiMap_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: axi_dma_0, and set properties
  set axi_dma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_0 ]
  set_property -dict [list \
    CONFIG.c_include_mm2s {0} \
    CONFIG.c_include_s2mm {1} \
    CONFIG.c_include_sg {0} \
    CONFIG.c_sg_length_width {26} \
  ] $axi_dma_0


  # Create instance: axi_mem_intercon, and set properties
  set axi_mem_intercon [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_intercon ]
  set_property -dict [list \
    CONFIG.NUM_MI {1} \
    CONFIG.NUM_SI {1} \
  ] $axi_mem_intercon


  # Create instance: qpix_reg_rtl_0, and set properties
  set block_name qpix_reg_rtl
  set block_cell_name qpix_reg_rtl_0
  if { [catch {set qpix_reg_rtl_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $qpix_reg_rtl_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: axis_data_fifo_0, and set properties
  set axis_data_fifo_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_0 ]
  set_property CONFIG.FIFO_MODE {2} $axis_data_fifo_0


  # Create instance: fifo_generator_0, and set properties
  set fifo_generator_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.2 fifo_generator_0 ]
  set_property -dict [list \
    CONFIG.Fifo_Implementation {Independent_Clocks_Builtin_FIFO} \
    CONFIG.Input_Data_Width {80} \
    CONFIG.Input_Depth {2048} \
    CONFIG.Performance_Options {First_Word_Fall_Through} \
    CONFIG.Valid_Flag {true} \
  ] $fifo_generator_0


  # Create instance: qpix_carrier_data_ct_0, and set properties
  set block_name qpix_carrier_data_ctrl
  set block_cell_name qpix_carrier_data_ct_0
  if { [catch {set qpix_carrier_data_ct_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $qpix_carrier_data_ct_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: qpix_carrier_fifo_ct_0, and set properties
  set block_name qpix_carrier_fifo_ctrl
  set block_cell_name qpix_carrier_fifo_ct_0
  if { [catch {set qpix_carrier_fifo_ct_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $qpix_carrier_fifo_ct_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property CONFIG.CONST_VAL {0} $xlconstant_0


  # Create instance: spi_interface_ctrl_0, and set properties
  set block_name spi_interface_ctrl
  set block_cell_name spi_interface_ctrl_0
  if { [catch {set spi_interface_ctrl_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $spi_interface_ctrl_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]

  # Create instance: xlconcat_2, and set properties
  set xlconcat_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_2 ]

  # Create interface connections
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_S2MM [get_bd_intf_pins axi_dma_0/M_AXI_S2MM] [get_bd_intf_pins axi_mem_intercon/S00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins AxiLiteSlaveSimple_0/axi]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins axi_interconnect_0/M01_AXI] [get_bd_intf_pins axi_dma_0/S_AXI_LITE]
  connect_bd_intf_net -intf_net axi_mem_intercon_M00_AXI [get_bd_intf_pins axi_mem_intercon/M00_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_HP0]
  connect_bd_intf_net -intf_net axis_data_fifo_0_M_AXIS [get_bd_intf_pins axis_data_fifo_0/M_AXIS] [get_bd_intf_pins axi_dma_0/S_AXIS_S2MM]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins axi_interconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net qpix_carrier_fifo_ct_0_S_AXI_0 [get_bd_intf_pins qpix_carrier_fifo_ct_0/S_AXI_0] [get_bd_intf_pins axis_data_fifo_0/S_AXIS]

  # Create port connections
  connect_bd_net -net AxiLiteSlaveSimple_0_addr [get_bd_pins AxiLiteSlaveSimple_0/addr] [get_bd_pins TransactRegiMap_0/addr]
  connect_bd_net -net AxiLiteSlaveSimple_0_req [get_bd_pins AxiLiteSlaveSimple_0/req] [get_bd_pins TransactRegiMap_0/req]
  connect_bd_net -net AxiLiteSlaveSimple_0_wdata [get_bd_pins AxiLiteSlaveSimple_0/wdata] [get_bd_pins TransactRegiMap_0/wdata]
  connect_bd_net -net AxiLiteSlaveSimple_0_wen [get_bd_pins AxiLiteSlaveSimple_0/wen] [get_bd_pins TransactRegiMap_0/wen]
  connect_bd_net -net Q_0_1 [get_bd_ports Q] [get_bd_pins qpix_carrier_data_ct_0/Q]
  connect_bd_net -net S00_ARESETN_1 [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_dma_0/axi_resetn] [get_bd_pins axi_interconnect_0/M01_ARESETN] [get_bd_pins axi_mem_intercon/S00_ARESETN] [get_bd_pins axi_mem_intercon/M00_ARESETN] [get_bd_pins axi_mem_intercon/ARESETN] [get_bd_pins AxiLiteSlaveSimple_0/axi_aresetn] [get_bd_pins axis_data_fifo_0/s_axis_aresetn]
  connect_bd_net -net TransactRegiMap_0_DAC_reg1 [get_bd_pins TransactRegiMap_0/DAC_reg1] [get_bd_pins xlconcat_2/In0]
  connect_bd_net -net TransactRegiMap_0_DAC_reg2 [get_bd_pins TransactRegiMap_0/DAC_reg2] [get_bd_pins xlconcat_2/In1]
  connect_bd_net -net TransactRegiMap_0_PacketLength [get_bd_pins TransactRegiMap_0/PacketLength] [get_bd_pins qpix_carrier_fifo_ct_0/qpixPacketLength]
  connect_bd_net -net TransactRegiMap_0_QpixMask [get_bd_pins TransactRegiMap_0/QpixMask] [get_bd_pins qpix_carrier_data_ct_0/qpixMask]
  connect_bd_net -net TransactRegiMap_0_SHDN [get_bd_pins TransactRegiMap_0/SHDN] [get_bd_ports SHDN]
  connect_bd_net -net TransactRegiMap_0_ack [get_bd_pins TransactRegiMap_0/ack] [get_bd_pins AxiLiteSlaveSimple_0/ack]
  connect_bd_net -net TransactRegiMap_0_load_DAC1 [get_bd_pins TransactRegiMap_0/load_DAC1] [get_bd_pins xlconcat_1/In0]
  connect_bd_net -net TransactRegiMap_0_load_DAC2 [get_bd_pins TransactRegiMap_0/load_DAC2] [get_bd_pins xlconcat_1/In1]
  connect_bd_net -net TransactRegiMap_0_rdata [get_bd_pins TransactRegiMap_0/rdata] [get_bd_pins AxiLiteSlaveSimple_0/rdata]
  connect_bd_net -net TransactRegiMap_0_reg_0 [get_bd_pins TransactRegiMap_0/reg_0] [get_bd_pins qpix_reg_rtl_0/reg_0]
  connect_bd_net -net TransactRegiMap_0_reg_1 [get_bd_pins TransactRegiMap_0/reg_1] [get_bd_pins qpix_reg_rtl_0/reg_1]
  connect_bd_net -net TransactRegiMap_0_reg_2 [get_bd_pins TransactRegiMap_0/reg_2] [get_bd_pins qpix_reg_rtl_0/reg_2]
  connect_bd_net -net TransactRegiMap_0_reg_3 [get_bd_pins TransactRegiMap_0/reg_3] [get_bd_pins qpix_reg_rtl_0/reg_3]
  connect_bd_net -net TransactRegiMap_0_reg_4 [get_bd_pins TransactRegiMap_0/reg_4] [get_bd_pins qpix_reg_rtl_0/reg_4]
  connect_bd_net -net TransactRegiMap_0_reg_5 [get_bd_pins TransactRegiMap_0/reg_5] [get_bd_pins qpix_reg_rtl_0/reg_5]
  connect_bd_net -net TransactRegiMap_0_reg_6 [get_bd_pins TransactRegiMap_0/reg_6] [get_bd_pins qpix_reg_rtl_0/reg_6]
  connect_bd_net -net TransactRegiMap_0_reg_7 [get_bd_pins TransactRegiMap_0/reg_7] [get_bd_pins qpix_reg_rtl_0/reg_7]
  connect_bd_net -net TransactRegiMap_0_reg_8 [get_bd_pins TransactRegiMap_0/reg_8] [get_bd_pins qpix_reg_rtl_0/reg_8]
  connect_bd_net -net TransactRegiMap_0_reg_9 [get_bd_pins TransactRegiMap_0/reg_9] [get_bd_pins qpix_reg_rtl_0/reg_9]
  connect_bd_net -net axi_dma_0_s2mm_introut [get_bd_pins axi_dma_0/s2mm_introut] [get_bd_pins processing_system7_0/IRQ_F2P]
  connect_bd_net -net fifo_generator_0_dout [get_bd_pins fifo_generator_0/dout] [get_bd_pins qpix_carrier_fifo_ct_0/fifo_dout]
  connect_bd_net -net fifo_generator_0_empty [get_bd_pins fifo_generator_0/empty] [get_bd_pins qpix_carrier_fifo_ct_0/fifo_empty]
  connect_bd_net -net fifo_generator_0_valid [get_bd_pins fifo_generator_0/valid] [get_bd_pins qpix_carrier_fifo_ct_0/fifo_valid]
  connect_bd_net -net opad2_DataOut1_0_1 [get_bd_ports opad2_DataOut1] [get_bd_pins qpix_reg_rtl_0/opad2_DataOut1]
  connect_bd_net -net opad2_DataOut2_0_1 [get_bd_ports opad2_DataOut2] [get_bd_pins qpix_reg_rtl_0/opad2_DataOut2]
  connect_bd_net -net opad2_deltaT_0_1 [get_bd_ports opad2_deltaT] [get_bd_pins qpix_reg_rtl_0/opad2_deltaT]
  connect_bd_net -net opad_DataOut1_0_1 [get_bd_ports opad_DataOut1] [get_bd_pins qpix_reg_rtl_0/opad_DataOut1]
  connect_bd_net -net opad_DataOut2_0_1 [get_bd_ports opad_DataOut2] [get_bd_pins qpix_reg_rtl_0/opad_DataOut2]
  connect_bd_net -net opad_deltaT_0_1 [get_bd_ports opad_deltaT] [get_bd_pins qpix_reg_rtl_0/opad_deltaT]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins qpix_reg_rtl_0/clk200] [get_bd_pins qpix_carrier_data_ct_0/clk] [get_bd_pins fifo_generator_0/wr_clk]
  connect_bd_net -net processing_system7_0_FCLK_CLK1 [get_bd_pins processing_system7_0/FCLK_CLK1] [get_bd_pins qpix_reg_rtl_0/clk] [get_bd_pins axi_mem_intercon/ACLK] [get_bd_pins axi_mem_intercon/S00_ACLK] [get_bd_pins axi_mem_intercon/M00_ACLK] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/M01_ACLK] [get_bd_pins axi_dma_0/s_axi_lite_aclk] [get_bd_pins axi_dma_0/m_axi_s2mm_aclk] [get_bd_pins AxiLiteSlaveSimple_0/axi_aclk] [get_bd_pins axis_data_fifo_0/s_axis_aclk] [get_bd_pins qpix_carrier_fifo_ct_0/clk] [get_bd_pins fifo_generator_0/rd_clk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK] [get_bd_pins TransactRegiMap_0/clk] [get_bd_pins spi_interface_ctrl_0/clk]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins proc_sys_reset_0/ext_reset_in]
  connect_bd_net -net qpix_carrier_data_ct_0_qpixCtrlOut [get_bd_pins qpix_carrier_data_ct_0/qpixCtrlOut] [get_bd_pins fifo_generator_0/din]
  connect_bd_net -net qpix_carrier_data_ct_0_qpixCtrlOutValid [get_bd_pins qpix_carrier_data_ct_0/qpixCtrlOutValid] [get_bd_pins fifo_generator_0/wr_en]
  connect_bd_net -net qpix_carrier_fifo_ct_0_qpix_fifo_ren [get_bd_pins qpix_carrier_fifo_ct_0/qpix_fifo_ren] [get_bd_pins fifo_generator_0/rd_en]
  connect_bd_net -net qpix_reg_rtl_0_opad2_CLK [get_bd_pins qpix_reg_rtl_0/opad2_CLK] [get_bd_ports opad2_CLK]
  connect_bd_net -net qpix_reg_rtl_0_opad2_CLKin [get_bd_pins qpix_reg_rtl_0/opad2_CLKin] [get_bd_ports opad2_CLKin]
  connect_bd_net -net qpix_reg_rtl_0_opad2_CLKin2 [get_bd_pins qpix_reg_rtl_0/opad2_CLKin2] [get_bd_ports opad2_CLKin2]
  connect_bd_net -net qpix_reg_rtl_0_opad2_DataIn [get_bd_pins qpix_reg_rtl_0/opad2_DataIn] [get_bd_ports opad2_DataIn]
  connect_bd_net -net qpix_reg_rtl_0_opad2_RST_EXT [get_bd_pins qpix_reg_rtl_0/opad2_RST_EXT] [get_bd_ports opad2_RST_EXT]
  connect_bd_net -net qpix_reg_rtl_0_opad2_cal_control [get_bd_pins qpix_reg_rtl_0/opad2_cal_control] [get_bd_ports opad2_cal_control]
  connect_bd_net -net qpix_reg_rtl_0_opad2_control [get_bd_pins qpix_reg_rtl_0/opad2_control] [get_bd_ports opad2_control]
  connect_bd_net -net qpix_reg_rtl_0_opad2_loadData [get_bd_pins qpix_reg_rtl_0/opad2_loadData] [get_bd_ports opad2_loadData]
  connect_bd_net -net qpix_reg_rtl_0_opad2_selDefData [get_bd_pins qpix_reg_rtl_0/opad2_selDefData] [get_bd_ports opad2_selDefData]
  connect_bd_net -net qpix_reg_rtl_0_opad2_serialOutCnt [get_bd_pins qpix_reg_rtl_0/opad2_serialOutCnt] [get_bd_ports opad2_serialOutCnt]
  connect_bd_net -net qpix_reg_rtl_0_opad2_startup [get_bd_pins qpix_reg_rtl_0/opad2_startup] [get_bd_ports opad2_startup]
  connect_bd_net -net qpix_reg_rtl_0_opad_CLK [get_bd_pins qpix_reg_rtl_0/opad_CLK] [get_bd_ports opad_CLK]
  connect_bd_net -net qpix_reg_rtl_0_opad_CLKin [get_bd_pins qpix_reg_rtl_0/opad_CLKin] [get_bd_ports opad_CLKin]
  connect_bd_net -net qpix_reg_rtl_0_opad_CLKin2 [get_bd_pins qpix_reg_rtl_0/opad_CLKin2] [get_bd_ports opad_CLKin2]
  connect_bd_net -net qpix_reg_rtl_0_opad_DataIn [get_bd_pins qpix_reg_rtl_0/opad_DataIn] [get_bd_ports opad_DataIn]
  connect_bd_net -net qpix_reg_rtl_0_opad_Ext_POR [get_bd_pins qpix_reg_rtl_0/opad_Ext_POR] [get_bd_ports opad_Ext_POR]
  connect_bd_net -net qpix_reg_rtl_0_opad_RST_EXT [get_bd_pins qpix_reg_rtl_0/opad_RST_EXT] [get_bd_ports opad_RST_EXT]
  connect_bd_net -net qpix_reg_rtl_0_opad_cal_control [get_bd_pins qpix_reg_rtl_0/opad_cal_control] [get_bd_ports opad_cal_control]
  connect_bd_net -net qpix_reg_rtl_0_opad_control [get_bd_pins qpix_reg_rtl_0/opad_control] [get_bd_ports opad_control]
  connect_bd_net -net qpix_reg_rtl_0_opad_loadData [get_bd_pins qpix_reg_rtl_0/opad_loadData] [get_bd_ports opad_loadData]
  connect_bd_net -net qpix_reg_rtl_0_opad_selDefData [get_bd_pins qpix_reg_rtl_0/opad_selDefData] [get_bd_ports opad_selDefData]
  connect_bd_net -net qpix_reg_rtl_0_opad_serialOutCnt [get_bd_pins qpix_reg_rtl_0/opad_serialOutCnt] [get_bd_ports opad_serialOutCnt]
  connect_bd_net -net qpix_reg_rtl_0_opad_startup [get_bd_pins qpix_reg_rtl_0/opad_startup] [get_bd_ports opad_startup]
  connect_bd_net -net spi_interface_ctrl_0_SCK [get_bd_pins spi_interface_ctrl_0/SCK] [get_bd_ports SCK]
  connect_bd_net -net spi_interface_ctrl_0_SDI [get_bd_pins spi_interface_ctrl_0/SDI] [get_bd_ports SDI]
  connect_bd_net -net spi_interface_ctrl_0_bCS [get_bd_pins spi_interface_ctrl_0/bCS] [get_bd_ports bCS]
  connect_bd_net -net spi_interface_ctrl_0_bLDAC [get_bd_pins spi_interface_ctrl_0/bLDAC] [get_bd_ports bLDAC]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins xlconcat_1/dout] [get_bd_pins spi_interface_ctrl_0/new_reg]
  connect_bd_net -net xlconcat_2_dout [get_bd_pins xlconcat_2/dout] [get_bd_pins spi_interface_ctrl_0/spi_data]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconstant_0/dout] [get_bd_pins qpix_carrier_fifo_ct_0/rst] [get_bd_pins qpix_carrier_data_ct_0/rst] [get_bd_pins fifo_generator_0/rst] [get_bd_pins spi_interface_ctrl_0/rst]

  # Create address segments
  assign_bd_address -offset 0x40000000 -range 0x00004000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs AxiLiteSlaveSimple_0/axi/reg0] -force
  assign_bd_address -offset 0x40400000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


