# Create clocks
# create_clock -period 5.000 -name OSC_200MHz [get_ports OSC_200MHz]

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

# reference from UPenn qpix firmware
# # From Nandor's schematic 18-Feb-2023
# set_property PACKAGE_PIN T10 [get_ports FPGA_I2C_sda_io]
# set_property PACKAGE_PIN U13 [get_ports FPGA_I2C_scl_io]
# set_property PACKAGE_PIN V13 [get_ports TRIGGER]

## ext_POR
# set_property PACKAGE_PIN T11 [get_ports opad_Ext_POR]

## pad1
# set_property PACKAGE_PIN T15 [get_ports opad_RST_EXT]
# set_property PACKAGE_PIN K17 [get_ports opad_CLK]

# set_property PACKAGE_PIN C20 [get_ports opad_CLKin]
# set_property PACKAGE_PIN B20 [get_ports opad_CLKin2]
# set_property PACKAGE_PIN E17 [get_ports opad_DataIn]
# set_property PACKAGE_PIN D18 [get_ports opad_control]
# set_property PACKAGE_PIN E18 [get_ports opad_loadData]
# set_property PACKAGE_PIN E19 [get_ports opad_selDefData]
# set_property PACKAGE_PIN M19 [get_ports opad_serialOutCnt]
# set_property PACKAGE_PIN M20 [get_ports opad_startup]
# set_property PACKAGE_PIN L19 [get_ports opad_cal_control]
# set_property PACKAGE_PIN L20 [get_ports opad_DataOut1]
# set_property PACKAGE_PIN L16 [get_ports opad_DataOut2]
# set_property PACKAGE_PIN F20 [get_ports opad2_deltaT]


## pad2
# set_property PACKAGE_PIN F16 [get_ports opad2_CLKin]
# set_property PACKAGE_PIN F17 [get_ports opad2_CLKin2]
# set_property PACKAGE_PIN M17 [get_ports opad2_DataIn]
# set_property PACKAGE_PIN M18 [get_ports opad2_control]
# set_property PACKAGE_PIN B19 [get_ports opad2_loadData]
# set_property PACKAGE_PIN A20 [get_ports opad2_selDefData]
# set_property PACKAGE_PIN D19 [get_ports opad2_serialOutCnt]
# set_property PACKAGE_PIN D20 [get_ports opad2_startup]
# set_property PACKAGE_PIN L17 [get_ports opad2_cal_control]
# set_property PACKAGE_PIN K19 [get_ports opad2_DataOut1]
# set_property PACKAGE_PIN J19 [get_ports opad2_DataOut2]
# set_property PACKAGE_PIN F19 [get_ports opad_deltaT]

# set_property PACKAGE_PIN T14 [get_ports opad2_RST_EXT]
# set_property PACKAGE_PIN K18 [get_ports opad2_CLK]

# set_property PACKAGE_PIN H16 [get_ports OSC_200MHz]
# #set_property PACKAGE_PIN H17 [get_ports ]
# # set_property PACKAGE_PIN J18 [get_ports oTP1]
# # set_property PACKAGE_PIN H18 [get_ports oTP2]
# set_property PACKAGE_PIN G17 [get_ports oTP3]
# set_property PACKAGE_PIN G18 [get_ports oTP4]

# set_property PACKAGE_PIN J18 [get_ports i2c0_sda_io]
# set_property PACKAGE_PIN H18 [get_ports i2c0_scl_io]
# set_property PACKAGE_PIN H20 [get_ports {oLVDS[0]}]
# set_property PACKAGE_PIN J20 [get_ports {oLVDS[1]}]
# set_property PACKAGE_PIN G15 [get_ports {oLVDS[2]}]
# set_property PACKAGE_PIN H15 [get_ports {oLVDS[3]}]
# set_property PACKAGE_PIN N16 [get_ports {oLVDS[4]}]
# set_property PACKAGE_PIN N15 [get_ports {oLVDS[5]}]
# set_property PACKAGE_PIN M15 [get_ports {oLVDS[6]}]
# set_property PACKAGE_PIN M14 [get_ports {oLVDS[7]}]
# set_property PACKAGE_PIN G20 [get_ports {oLVDS[15]}]
# set_property PACKAGE_PIN G19 [get_ports {oLVDS[14]}]
# set_property PACKAGE_PIN J14 [get_ports {oLVDS[13]}]
# set_property PACKAGE_PIN K14 [get_ports {oLVDS[12]}]
# set_property PACKAGE_PIN L15 [get_ports {oLVDS[11]}]
# set_property PACKAGE_PIN L14 [get_ports {oLVDS[10]}]
# set_property PACKAGE_PIN J16 [get_ports {oLVDS[9]}]
# set_property PACKAGE_PIN K16 [get_ports {oLVDS[8]}]

# #set_property PULLUP true [get_ports i2c0_scl_io]
# #set_property PULLUP true [get_ports i2c0_sda_io]

# from Kevin's Carrier Board Schematic
# set_property PACKAGE_PIN V7  [get_ports Pad1_ClkbSHDN]
# set_property PACKAGE_PIN U10 [get_ports Pad2_ClkbSHDN]

################
## Pad 1 Pins ##
################
# set_property PACKAGE_PIN T15 [get_ports fPAD1_EXT_POR]
# set_property PACKAGE_PIN W13 [get_ports fPAD2_EXT_POR]

# set_property PACKAGE_PIN V10 [get_ports fPAD1_CLKIN]
# set_property PACKAGE_PIN T10 [get_ports fPAD1_CLKIN2]
# set_property PACKAGE_PIN T14 [get_ports fPAD1_DATAIN]
# set_property PACKAGE_PIN U13 [get_ports fPAD1_CTRL]
# set_property PACKAGE_PIN Y17 [get_ports fPAD1_LOADDATA]
# set_property PACKAGE_PIN Y9  [get_ports fPAD1_SEL_DEF_DATA]
# set_property PACKAGE_PIN Y8  [get_ports fPAD1_SER_OUT_CNT]
# set_property PACKAGE_PIN V11 [get_ports fPAD1_CAL_CTRL]
# set_property PACKAGE_PIN V13 [get_ports fPAD1_DATAOUT1]
# set_property PACKAGE_PIN T11 [get_ports fPAD1_DATAOUT2]
# set_property PACKAGE_PIN Y16 [get_ports fPAD1_DeltaT]

# set_property PACKAGE_PIN C20 [get_ports Rst1_out]
# set_property PACKAGE_PIN U7  [get_ports Clk1_Out]

################
## Pad 2 Pins ##
################
# set_property PACKAGE_PIN Y14 [get_ports fPAD2_CLKIN]
# set_property PACKAGE_PIN V8  [get_ports fPAD2_CLKIN2]
# set_property PACKAGE_PIN U12 [get_ports fPAD2_DATAIN]
# set_property PACKAGE_PIN W8  [get_ports fPAD2_CTRL]
# set_property PACKAGE_PIN P14 [get_ports fPAD2_LOADDATA]
# set_property PACKAGE_PIN R14 [get_ports fPAD2_SEL_DEF_DATA]
# set_property PACKAGE_PIN W14 [get_ports fPAD2_SER_OUT_CNT]
# set_property PACKAGE_PIN B20 [get_ports PAD2_STARTUP]
# set_property PACKAGE_PIN U14 [get_ports fPAD2_CAL_CTRL]
# set_property PACKAGE_PIN U15 [get_ports fPAD2_DATAOUT1]
# set_property PACKAGE_PIN T12 [get_ports fPAD2_DATAOUT2]
# set_property PACKAGE_PIN V12 [get_ports fPAD2_DeltaT]

# set_property PACKAGE_PIN E17 [get_ports Rst2_out]
# set_property PACKAGE_PIN T9  [get_ports Clk2_Out]

###################################
## QpixLar Carrier Specific pins ##
###################################
# set_property PACKAGE_PIN Y7 [get_ports ClkSyncOut]
# set_property PACKAGE_PIN Y6 [get_ports ClkSyncIn]

# set_property PACKAGE_PIN E18 [get_ports FPGA_ID_0]
# set_property PACKAGE_PIN E19 [get_ports FPGA_ID_1]
# set_property PACKAGE_PIN M19 [get_ports SDN_9]

# set_property PACKAGE_PIN L19 [get_ports Q_9]
# set_property PACKAGE_PIN L20 [get_ports Q_8]
# set_property PACKAGE_PIN L16 [get_ports SDN_8]

# set_property PACKAGE_PIN H16 [get_ports SDN_10]
# set_property PACKAGE_PIN H17 [get_ports SDN_15]
# set_property PACKAGE_PIN F19 [get_ports Q_15]
# set_property PACKAGE_PIN F20 [get_ports SDN_13]

# set_property PACKAGE_PIN J20 [get_ports Q_13]
# set_property PACKAGE_PIN H20 [get_ports SDN_14]
# set_property PACKAGE_PIN H15 [get_ports Q_14]
# set_property PACKAGE_PIN G15 [get_ports SDN_12]

# set_property PACKAGE_PIN N15 [get_ports Q_12]
# set_property PACKAGE_PIN N16 [get_ports SDN_3]
# set_property PACKAGE_PIN M14 [get_ports Q_3]
# set_property PACKAGE_PIN M15 [get_ports SDN_1]

# set_property PACKAGE_PIN B19 [get_ports PAD1_STARTUP]
# set_property PACKAGE_PIN A20 [get_ports CS2_bar]
# set_property PACKAGE_PIN D19 [get_ports CS1_bar]
# set_property PACKAGE_PIN D20 [get_ports LDAC_bar]

# set_property PACKAGE_PIN F16 [get_ports ExternalClkEnable]
# set_property PACKAGE_PIN F17 [get_ports SCK]
# set_property PACKAGE_PIN M17 [get_ports SDI]

# set_property PACKAGE_PIN K19 [get_ports SDN_11]
# set_property PACKAGE_PIN J19 [get_ports Q_11]
# set_property PACKAGE_PIN K17 [get_ports SDN_4]
# set_property PACKAGE_PIN K18 [get_ports Q_4]

# set_property PACKAGE_PIN J18 [get_ports Q_10]
# set_property PACKAGE_PIN H18 [get_ports Q_6]
# set_property PACKAGE_PIN G17 [get_ports SDN_6]
# set_property PACKAGE_PIN G18 [get_ports Q_5]

# set_property PACKAGE_PIN G19 [get_ports SDN_5]
# set_property PACKAGE_PIN G20 [get_ports Q_7]
# set_property PACKAGE_PIN K14 [get_ports SDN_7]
# set_property PACKAGE_PIN J14 [get_ports Q_0]

# set_property PACKAGE_PIN L14 [get_ports SDN_0]
# set_property PACKAGE_PIN L15 [get_ports Q_2]
# set_property PACKAGE_PIN K16 [get_ports SDN_2]
# set_property PACKAGE_PIN J16 [get_ports Q_1]
