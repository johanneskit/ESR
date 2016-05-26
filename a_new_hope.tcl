#############################
#############################
## Engineers: Johannes Schwickerath and Kevin Höfle
## This script is a modified version of a automatically generated
## TCL script from Vivado 2015.4
## 
## To run this script: 
## 1. Create a Project and then run the script
## 2. The name of the design must be unique - but if the amount of processors change
##    the name will also change
#############################
#############################
set CPU_Anzahl 3



proc create_hier_cell_MicroBlaze { parentCell name } {
  if { $parentCell eq "" || $name eq "" } {
     puts "ERROR: create_hier_cell_MicroBlaze1() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $name]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:mbdebug_rtl:3.0 DEBUG
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:lmb_rtl:1.0 DLMB
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_DP

  # Create pins
  create_bd_pin -dir I -type clk Clk
  create_bd_pin -dir I -type rst Reset

    puts "Creating" 
    puts $name
    set AXI_BRAM_CTRL_NAME "axi_bram_ctrl_bram_"
    set LMB_BRAM_NAME "lmb_bram_if_cntrl_";
    puts $AXI_BRAM_CTRL_NAME$name
    puts $LMB_BRAM_NAME$name
  # Create instance: axi_bram_ctrl_0_bram3, and set properties
    set axi_bram_ctrl_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 $AXI_BRAM_CTRL_NAME$name ]
      set_property -dict [ list \
CONFIG.Assume_Synchronous_Clk {false} \
CONFIG.Enable_B {Always_Enabled} \
CONFIG.Memory_Type {Single_Port_RAM} \
CONFIG.Port_B_Clock {0} \
CONFIG.Port_B_Enable_Rate {0} \
CONFIG.Port_B_Write_Rate {0} \
CONFIG.Use_RSTB_Pin {false} \
 ] $axi_bram_ctrl_bram

  # Create instance: lmb_bram_if_cntlr_1, and set properties
  set lmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 $LMB_BRAM_NAME$name ]
  set microblaze [ create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:9.5 $name ]
  set_property -dict [ list \
CONFIG.C_DEBUG_ENABLED {1} \
CONFIG.C_D_AXI {1} \
CONFIG.C_D_LMB {1} \
CONFIG.C_INTERCONNECT {2} \
CONFIG.C_I_AXI {0} \
CONFIG.C_I_LMB {1} \
 ] $microblaze
    
    
  set BRAM_PORTA "/BRAM_PORTA"
  set BRAM_PORT  "/BRAM_PORT"
  set DLMB "/DLMB"
  set ILMB "/ILMB"
  set SLMB "/SLMB"
  set M_AXI_DP "/M_AXI_DP"
  set LMB_Clk "/LMB_CLK"
  set DEBUG "/DEBUG"
  set CLK "/CLK"
  set LMB_RST "/LMB_Rst"
  set RESET "/Reset"
  # Create interface connections
  
  set t1 [get_bd_intf_pins $AXI_BRAM_CTRL_NAME$name$BRAM_PORTA]
  set t2 [get_bd_intf_pins $LMB_BRAM_NAME$name$BRAM_PORT]
  
  
  connect_bd_intf_net -intf_net lmb_bram_if_cntlr_1_BRAM_PORT $t1 $t2
  
  set t1 [get_bd_intf_pins DLMB]
  set t2 [get_bd_intf_pins $microblaze$DLMB]
  connect_bd_intf_net -intf_net microblaze_0_DLMB $t1 $t2
  # connect_bd_intf_net -intf_net microblaze_0_DLMB [get_bd_intf_pins DLMB] [get_bd_intf_pins $microblaze/DLMB]
  
  
  
  set t1 [get_bd_intf_pins $LMB_BRAM_NAME$name$SLMB]
  set t2 [get_bd_intf_pins $microblaze$ILMB]
  
  connect_bd_intf_net  -intf_net microblaze_0_ILMB $t1 $t2
  #connect_bd_intf_net -intf_net microblaze_0_ILMB [get_bd_intf_pins lmb_bram_if_cntlr_1/SLMB] [get_bd_intf_pins $microblaze/ILMB]
  
  
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_DP [get_bd_intf_pins M_AXI_DP] [get_bd_intf_pins $microblaze$M_AXI_DP]
  connect_bd_intf_net -intf_net microblaze_0_debug [get_bd_intf_pins DEBUG] [get_bd_intf_pins $microblaze/DEBUG]
  
  set t1 [get_bd_pins Clk] 
  set t2 [get_bd_pins $LMB_BRAM_NAME$name$LMB_Clk]
  set t3 [get_bd_pins $microblaze$CLK]
  

  
  connect_bd_net -net microblaze_1_Clk $t1 $t2 $t3
  # # Create port connections
  # connect_bd_net -net microblaze_1_Clk [get_bd_pins Clk] [get_bd_pins $lmb_bram_if_cntlr/LMB_Clk] [get_bd_pins $microblaze/Clk]
  
  set t1 [get_bd_pins Reset]
  set t2 [get_bd_pins $LMB_BRAM_NAME$name$LMB_RST]
  set t3 [get_bd_pins $microblaze$RESET]
  connect_bd_net -net rst_clk_wiz_1_100M_mb_reset $t1 $t2 $t3
  #connect_bd_net -net rst_clk_wiz_1_100M_mb_reset [get_bd_pins Reset] [get_bd_pins $lmb_bram_if_cntlr/LMB_Rst] [get_bd_pins $microblaze/Reset]
  
  
  # Restore current instance
  current_bd_instance $oldCurInst
}


proc create_root_design { parentCell CPUs} {
	
  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set diff_clock_rtl [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 diff_clock_rtl ]
  set_property -dict [ list \
CONFIG.FREQ_HZ {100000000} \
 ] $diff_clock_rtl

  # Create ports
  set reset_rtl [ create_bd_port -dir I -type rst reset_rtl ]
  set_property -dict [ list \
CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $reset_rtl
  set reset_rtl_0 [ create_bd_port -dir I -type rst reset_rtl_0 ]
  set_property -dict [ list \
CONFIG.POLARITY {ACTIVE_LOW} \
 ] $reset_rtl_0

    #AUSSERHALB VON DER SCHLEIFE!
    # Create instance: clk_wiz_1, and set properties
    set clk_wiz_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.2 clk_wiz_1 ]
    set_property -quiet -dict [ list \
CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} \
 ] $clk_wiz_1
    
	set variable [expr int($CPUs)] 
	
    # # Create instance: mdm_1, and set properties
    set mdm_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mdm:3.2 mdm_1 ]
    set_property CONFIG.C_MB_DBG_PORTS $variable $mdm_1
    set rst_clk_wiz_1_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_clk_wiz_1_100M ]
    
    
    puts "ICH BIN HIER"
    set l [list]
    set MicroBlazeItName "MicroBlaze_"
	set lmb_bram_name "lm_bram_if_cntlr_"
	set MBDEBUG_NAME "MBDEBUG_"
	set mdm "mdm_1/"
    set DEBUG "/DEBUG"
	set axi_bram_ctrl_ "axi_bram_ctrl_"
	set axi_bram_ctrl_bram "axi_bram_ctrl_bram_"
	set lmb_bram_if_cntlrNAME "lmb_bram_if_cntlr_"
	puts $CPUs
    for {set i 0} {$i < $CPUs} {incr i} {
        puts $i
        set l [linsert $l 0 $MicroBlazeItName$i]
        puts [lindex $l 0]
        set temp [lindex $l 0]
        
        #Calls as often as needed
        create_hier_cell_MicroBlaze  [current_bd_instance .]  $temp 


		set MicroBlazeDebugPort $temp$DEBUG
		set MicroBlazeDebugPin [get_bd_intf_pins $MicroBlazeDebugPort ]
		puts $MicroBlazeDebugPort
		puts $MicroBlazeDebugPin
		
		set DebuggerPort $mdm$MBDEBUG_NAME$i
		set DebuggerPin [get_bd_intf_pins $DebuggerPort ]
		puts $DebuggerPort
		puts $MicroBlazeDebugPin
		set name2 $temp$i
		connect_bd_intf_net -intf_net $name2 $MicroBlazeDebugPin $DebuggerPin
		
		  # Create instance: axi_bram_ctrl_0, and set properties
		  set axi_bram_ctrl_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 $axi_bram_ctrl_$i ]
		  set_property -dict [ list \
		CONFIG.ECC_TYPE {0} \
		CONFIG.PROTOCOL {AXI4LITE} \
		CONFIG.SINGLE_PORT_BRAM {1} \
		 ] $axi_bram_ctrl_0
		
				  # Create instance: axi_bram_ctrl_0_bram, and set properties
		  set axi_bram_ctrl_0_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 $axi_bram_ctrl_bram$i ]
		  set_property -dict [list CONFIG.Write_Depth_A {32768} CONFIG.use_bram_block {Stand_Alone} CONFIG.Memory_Type {True_Dual_Port_RAM} CONFIG.Enable_32bit_Address {false} CONFIG.Use_Byte_Write_Enable {false} CONFIG.Byte_Size {9} CONFIG.Register_PortA_Output_of_Memory_Primitives {true} CONFIG.Register_PortB_Output_of_Memory_Primitives {true} CONFIG.Use_RSTA_Pin {false} CONFIG.Use_RSTB_Pin {false}] [get_bd_cells $axi_bram_ctrl_bram$i] $axi_bram_ctrl_0_bram


		# set_property -dict [ list \
		# CONFIG.Assume_Synchronous_Clk {true} \
		# CONFIG.Enable_B {Use_ENB_Pin} \
		# CONFIG.Memory_Type {True_Dual_Port_RAM} \
		# CONFIG.Port_B_Clock {100} \
		# CONFIG.Port_B_Enable_Rate {100} \
		# CONFIG.Port_B_Write_Rate {50} \
		# CONFIG.Use_RSTB_Pin {true} \
		 # ] $axi_bram_ctrl_0_bram
		
		set lmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 $lmb_bram_name$i ]
		
		set BRAM_PORTA "BRAM_PORTA"
		set axi_to_bram $axi_bram_ctrl_$i$BRAM_PORTA
		connect_bd_intf_net -intf_net $axi_to_bram [get_bd_intf_pins $axi_bram_ctrl_$i/BRAM_PORTA] [get_bd_intf_pins $axi_bram_ctrl_bram$i/BRAM_PORTB]
		set BRAM_PORT "BRAM_PORT"
		set LMB_BRAM_IF_CNTRL_X_BRAM_PORT $lmb_bram_name$i$BRAM_PORT
		connect_bd_intf_net -intf_net $LMB_BRAM_IF_CNTRL_X_BRAM_PORT [get_bd_intf_pins $axi_bram_ctrl_bram$i/BRAM_PORTA] [get_bd_intf_pins $lmb_bram_name$i/BRAM_PORT]

		set DLMB "_DLMB"
		set microblaze_X_DLMB $temp$DLMB
		connect_bd_intf_net -intf_net $microblaze_X_DLMB [get_bd_intf_pins $temp/DLMB] [get_bd_intf_pins $lmb_bram_name$i/SLMB]
		
		set M_AXI_DP "_M_AXI_DP"
		set microblaze_X_M_AXI_DP $temp$M_AXI_DP
		#connect_bd_intf_net -intf_net $microblaze_X_M_AXI_DP [get_bd_intf_pins $temp/M_AXI_DP] [get_bd_intf_pins SchwiHoeInterConnect_0/S00_AXI]
	

		set ResetName ALL_RESETS$temp
	#	MUSS AUSEINANDER GEPFLÜCKT WERDEN:
	#	connect_bd_net -net rst_clk_wiz_1_100M_mb_reset [get_bd_pins MicroBlaze0/Reset] [get_bd_pins MicroBlaze1/LMB_Rst] [get_bd_pins lmb_bram_if_cntlr_2/LMB_Rst] [get_bd_pins lmb_bram_if_cntlr_3/LMB_Rst] [get_bd_pins rst_clk_wiz_1_100M/mb_reset]
		connect_bd_net -net rst_clk_wiz_1_100M_mb_reset [get_bd_pins $temp/Reset] [get_bd_pins $lmb_bram_name$i/LMB_Rst] [get_bd_pins rst_clk_wiz_1_100M/mb_reset]
		connect_bd_net -net rst_clk_wiz_1_100M_peripheral_aresetn [get_bd_pins $axi_bram_ctrl_$i/s_axi_aresetn] [get_bd_pins rst_clk_wiz_1_100M/peripheral_aresetn]
 
		connect_bd_net -net microblaze_1_Clk [get_bd_pins $temp/Clk] [get_bd_pins $axi_bram_ctrl_$i/s_axi_aclk] [get_bd_pins clk_wiz_1/clk_out1] [get_bd_pins $lmb_bram_name$i/LMB_Clk] [get_bd_pins rst_clk_wiz_1_100M/slowest_sync_clk]
 
	}
	

	connect_bd_intf_net -intf_net diff_clock_rtl_1 [get_bd_intf_ports diff_clock_rtl] [get_bd_intf_pins clk_wiz_1/CLK_IN1_D]
	connect_bd_net -net clk_wiz_1_locked [get_bd_pins clk_wiz_1/locked] [get_bd_pins rst_clk_wiz_1_100M/dcm_locked]
	connect_bd_net -net mdm_1_debug_sys_rst [get_bd_pins mdm_1/Debug_SYS_Rst] [get_bd_pins rst_clk_wiz_1_100M/mb_debug_sys_rst]
	connect_bd_net -net reset_rtl_0_1 [get_bd_ports reset_rtl_0] [get_bd_pins rst_clk_wiz_1_100M/ext_reset_in]
    connect_bd_net -net reset_rtl_1 [get_bd_ports reset_rtl] [get_bd_pins clk_wiz_1/reset]
    
}

#Muss jedesmal geändert werden!
set Design "MyNewDesign" 
create_bd_design $Design$CPU_Anzahl
create_root_design "" $CPU_Anzahl