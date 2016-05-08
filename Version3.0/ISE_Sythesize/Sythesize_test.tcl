
# ############################ Introduction ################################################
# Project automation script for Sythesize_test 
#
# Created for ISE version 14.2
# 
# This file contains several Tcl procedures (procs) that you can use to automate
# your project by running from xtclsh or the Project Navigator Tcl console.
# If you load this file (using the Tcl command: source Sythesize_test.tcl), then you can
# run any of the procs included here.
# 
# This script is generated assuming your project has HDL sources.
# Several of the defined procs won't apply to an EDIF or NGC based project.
# If that is the case, simply remove them from this script.
# 
# You may also edit any of these procs to customize them. See comments in each
# proc for more instructions.
# 
# This file contains the following procedures:
# 
# Top Level procs (meant to be called directly by the user):
#	 new_project: you can use this top_level procedure to new a project named 
#	     "Sythesize_test",then set project properties, add source files and 
#		  create libraries.
#		 
#    run_process: you can use this top-level procedure to run any processes
#        that you choose to by adding and removing comments, or by
#        adding new entries. By this process,you can sythesize the project ,
#		 implement design and generate programming file.
#
#    rebuild_project: you can alternatively use this top-level procedure
#        to recreate your entire project, and the run selected processes.
# 
#
# Lower Level (helper) procs (called under in various cases by the top level procs):
#    show_help: print some basic information describing how this script works
#    add_source_files: adds the listed source files to your project.
#    set_project_props: sets the project properties that were in effect when this
#        script was generated.
#    create_libraries: creates and adds file to VHDL libraries that were defined when
#        this script was generated.
#    set_process_props: set the process properties as they were set for your project
#        when this script was generated.
#	 map_report: show the map report
# 
# ########################## End Introduction ##############################################

# set project's name
set myProject "Sythesize_test"    
# set script's name
set myScript "Sythesize_test.tcl"
# set dirpath
set dirpath "E:/u"
# set top_file_name
set topFile_name "top"  

# ##########################################################################################
# Main (top-level) routines
# ##########################################################################################

# ####################
# new_project
# ####################
# This procedure is used to new a project called "Sythesize_test".
#
# This proc also set project props, add sources files , and create libraries
#
proc  new_project {} {
	global myScript
	global myProject
	
	if {  [ file exists ${myProject}.xise ] } { 
      ## project file isn't there, new it.
      puts "Project $myProject has been created."
	  puts "Please select run_process or rebuild_project."
	  
	  }
	 
   project new $myProject
   set_project_props
   add_source_files
   create_libraries
   puts "$myScript: Complete new project."
}


# ####################
# run_process
# ####################
# This procedure is used to run processes on an existing project. You may comment or
# uncomment lines to control which processes are run. This routine is set up to run
# the Sythesize, the Implement Design and Generate Programming File processes by default. 
#
# This proc also sets process properties as specified in the "set_process_props" proc. Only
# those properties which have values different from their current settings in the project
# file will be modified in the project.
# 
proc run_process {} {

   global myScript
   global myProject

   ## put out a 'heartbeat' - so we know something's happening.
   puts "\n$myScript: running ($myProject)...\n"

   if { ! [ open_project ] } {
	  puts  "No project was opend."
      return false
   }

   set_process_props
   ############### Function: sythesize ###################################
   #######################################################################
   #
   # Remove the comment characters (#'s) to enable the following commands 
    process run "Synthesize"
   # process run "Translate"
   # process run "Map"
   # process run "Place & Route"
   #
   puts  "Synthesize completed(successfully)."
   
   ############### Function: Implement Design ############################
   #######################################################################
   #
   # Remove the comment characters (#'s) to enable the following commands 
   # set task "Implement Design"
   # if { ! [run_task $task] } {
   #   puts "$myScript: $task run failed, check run output for details."
   #   project close
   #   return
   #}
   
   ############### Function: Generate Programming File ###################
   #######################################################################   
   #
   # Remove the comment characters (#'s) to enable the following commands 
   # set task "Generate Programming File"
   # if { ! [run_task $task] } {
   #   puts "$myScript: $task run failed, check run output for details."
   #   project close
   #   return
   #}

  # puts "Run completed (successfully)." 
  map_report
  return true
  project close
}


# ######################
# rebuild_project
# ######################
# This procedure renames the project file (if it exists) and recreates the project.
# It then sets project properties and adds project sources as specified by the
# set_project_props and add_source_files support procs. It recreates VHDL Libraries
# as they existed at the time this script was generated.
# 
# It then calls run_process to set process properties and run selected processes.
# 
proc rebuild_project {} {

   global myScript
   global myProject

   project close
   ## put out a 'heartbeat' - so we know something's happening.
   puts "\n$myScript: Rebuilding ($myProject)...\n"

   set proj_exts [ list ise xise gise ]
   foreach ext $proj_exts {
      set proj_name "${myProject}.$ext"
      if { [ file exists $proj_name ] } { 
         file delete $proj_name
      }
   }

   project new $myProject
   set_project_props
   add_source_files
   create_libraries
   puts "$myScript: project rebuild completed."

   run_process
}



# ##########################################################################################
# Support Routines
# ##########################################################################################

# #################
# run_task
# #################
# This proc is used to set task. For example,if you want to run the function: 
# Implement Design and the function: Generate Programming File, you should 
# use this proc .
#
proc run_task { task } {

   # helper proc for run_process

   puts "Running '$task'"
   set result [ process run "$task" ]
   #
   # check process status (and result)
   set status [ process get $task status ]
   if { ( ( $status != "up_to_date" ) && \
            ( $status != "warnings" ) ) || \
         ! $result } {
      return false
   }
   return true
}

# ##################
# show_help: 
# ##################         
# This proc print information to help users understand the options available 
# when  running this script.
# 
proc show_help {} {

   global myScript

   puts ""
   puts "usage: xtclsh $myScript <options>"
   puts "       or you can run xtclsh and then enter 'source $myScript'."
   puts ""
   puts "options:"
   puts "   new_project       - new project "
   puts "   run_process       - set properties and run processes."
   puts "   rebuild_project   - rebuild the project from scratch and run processes."
   puts "   set_project_props - set project properties (device, speed, etc.)"
   puts "   add_source_files  - add source files"
   puts "   create_libraries  - create vhdl libraries"
   puts "   set_process_props - set process property values"
   puts "   show_help         - print this message"
   puts ""
}

# ########################
# open_project
# ########################
# This proc is used to check that if there has been a project called 
# Sythesize_test. If not,give a message to tell the user. Otherwise,
# open the project.
#
proc open_project {} {
  
   global myScript
   global myProject

   if { ! [ file exists ${myProject}.xise ] } { 
      ## project file isn't there, build it.
      puts "Project $myProject not found. Use new_project to create it."
      return false
   }

   project open $myProject
   return true
   puts "Project has been opend."
}


# ########################
# set_project_props
# ########################
# This procedure sets the project properties as they were set in the project
# at the time this script was generated.
# 
proc set_project_props {} {

   global myScript

   if { ! [ open_project ] } {
	  puts  "No project was opend."
      return false
   }

   puts "$myScript: Setting project properties..."

   project set family "Spartan6"
   project set device "xc6slx16"
   project set package "csg324"
   project set speed "-3"
   project set top_level_module_type "HDL"
   project set synthesis_tool "XST (VHDL/Verilog)"
   project set simulator "ISim (VHDL/Verilog)"
   project set "Preferred Language" "Verilog"
   project set "Enable Message Filtering" "false"

   puts "$myScript: Finish setting project properties..."
}




# #########################
# create_libraries
# #########################
# This procedure defines VHDL libraries and associates files with those libraries.
# It is expected to be used when recreating the project. Any libraries defined
# when this script was generated are recreated by this procedure.
# 
proc create_libraries {} {

   global myScript

   if { ! [ open_project ] } {
	  puts  "No project was opend."
      return false
   }

   puts "$myScript: Creating libraries..."

   # must close the project or library definitions aren't saved.
   project save
   puts "$myScript: Finish creating libraries..."
} ; # end create_libraries


# ######################## 
# set_process_props
# ########################
# This procedure sets properties as requested during script generation (either
# all of the properties, or only those modified from their defaults).
# 
proc set_process_props {} {

   global myScript

   if { ! [ open_project ] } {
	  puts  "No project was opend."
      return false
   }

   puts "$myScript: setting process properties..."

   project set "Compiled Library Directory" "\$XILINX/<language>/<simulator>"
   project set "Global Optimization" "Off" -process "Map"
   project set "Pack I/O Registers/Latches into IOBs" "Off" -process "Map"
   project set "Place And Route Mode" "Route Only" -process "Place & Route"
   project set "Regenerate Core" "Under Current Project Setting" -process "Regenerate Core"
   project set "Filter Files From Compile Order" "true"
   project set "Last Applied Goal" "Balanced"
   project set "Last Applied Strategy" "Xilinx Default (unlocked)"
   project set "Last Unlock Status" "false"
   project set "Manual Compile Order" "false"
   project set "Placer Effort Level" "High" -process "Map"
   project set "Extra Cost Tables" "0" -process "Map"
   project set "LUT Combining" "Off" -process "Map"
   project set "Combinatorial Logic Optimization" "false" -process "Map"
   project set "Starting Placer Cost Table (1-100)" "1" -process "Map"
   project set "Power Reduction" "Off" -process "Map"
   project set "Report Fastest Path(s) in Each Constraint" "true" -process "Generate Post-Place & Route Static Timing"
   project set "Generate Datasheet Section" "true" -process "Generate Post-Place & Route Static Timing"
   project set "Generate Timegroups Section" "false" -process "Generate Post-Place & Route Static Timing"
   project set "Report Fastest Path(s) in Each Constraint" "true" -process "Generate Post-Map Static Timing"
   project set "Generate Datasheet Section" "true" -process "Generate Post-Map Static Timing"
   project set "Generate Timegroups Section" "false" -process "Generate Post-Map Static Timing"
   project set "Property Specification in Project File" "Store non-default values only"
   project set "Reduce Control Sets" "Auto" -process "Synthesize - XST"
   project set "Shift Register Minimum Size" "2" -process "Synthesize - XST"
   project set "Case Implementation Style" "None" -process "Synthesize - XST"
   project set "RAM Extraction" "true" -process "Synthesize - XST"
   project set "ROM Extraction" "true" -process "Synthesize - XST"
   project set "FSM Encoding Algorithm" "Auto" -process "Synthesize - XST"
   project set "Optimization Goal" "Speed" -process "Synthesize - XST"
   project set "Optimization Effort" "Normal" -process "Synthesize - XST"
   project set "Resource Sharing" "true" -process "Synthesize - XST"
   project set "Shift Register Extraction" "true" -process "Synthesize - XST"
   project set "User Browsed Strategy Files" ""
   project set "VHDL Source Analysis Standard" "VHDL-93"
   project set "Analysis Effort Level" "Standard" -process "Analyze Power Distribution (XPower Analyzer)"
   project set "Analysis Effort Level" "Standard" -process "Generate Text Power Report"
   project set "Input TCL Command Script" "" -process "Generate Text Power Report"
   project set "Load Physical Constraints File" "Default" -process "Analyze Power Distribution (XPower Analyzer)"
   project set "Load Physical Constraints File" "Default" -process "Generate Text Power Report"
   project set "Load Simulation File" "Default" -process "Analyze Power Distribution (XPower Analyzer)"
   project set "Load Simulation File" "Default" -process "Generate Text Power Report"
   project set "Load Setting File" "" -process "Analyze Power Distribution (XPower Analyzer)"
   project set "Load Setting File" "" -process "Generate Text Power Report"
   project set "Setting Output File" "" -process "Generate Text Power Report"
   project set "Produce Verbose Report" "false" -process "Generate Text Power Report"
   project set "Other XPWR Command Line Options" "" -process "Generate Text Power Report"
   project set "Essential Bits" "false" -process "Generate Programming File"
   project set "Other Bitgen Command Line Options" "" -process "Generate Programming File"
   project set "Maximum Signal Name Length" "20" -process "Generate IBIS Model"
   project set "Show All Models" "false" -process "Generate IBIS Model"
   project set "VCCAUX Voltage Level" "2.5V" -process "Generate IBIS Model"
   project set "Disable Detailed Package Model Insertion" "false" -process "Generate IBIS Model"
   project set "Launch SDK after Export" "true" -process "Export Hardware Design To SDK with Bitstream"
   project set "Launch SDK after Export" "true" -process "Export Hardware Design To SDK without Bitstream"
   project set "Target UCF File Name" "" -process "Back-annotate Pin Locations"
   project set "Ignore User Timing Constraints" "false" -process "Map"
   project set "Register Ordering" "4" -process "Map"
   project set "Use RLOC Constraints" "Yes" -process "Map"
   project set "Other Map Command Line Options" "" -process "Map"
   project set "Use LOC Constraints" "true" -process "Translate"
   project set "Other Ngdbuild Command Line Options" "" -process "Translate"
   project set "Use 64-bit PlanAhead on 64-bit Systems" "true" -process "Floorplan Area/IO/Logic (PlanAhead)"
   project set "Use 64-bit PlanAhead on 64-bit Systems" "true" -process "I/O Pin Planning (PlanAhead) - Pre-Synthesis"
   project set "Use 64-bit PlanAhead on 64-bit Systems" "true" -process "I/O Pin Planning (PlanAhead) - Post-Synthesis"
   project set "Ignore User Timing Constraints" "false" -process "Place & Route"
   project set "Other Place & Route Command Line Options" "" -process "Place & Route"
   project set "Use DSP Block" "Auto" -process "Synthesize - XST"
   project set "UserID Code (8 Digit Hexadecimal)" "0xFFFFFFFF" -process "Generate Programming File"
   project set "Configuration Pin Done" "Pull Up" -process "Generate Programming File"
   project set "Enable External Master Clock" "false" -process "Generate Programming File"
   project set "Create ASCII Configuration File" "false" -process "Generate Programming File"
   project set "Create Bit File" "true" -process "Generate Programming File"
   project set "Enable BitStream Compression" "false" -process "Generate Programming File"
   project set "Run Design Rules Checker (DRC)" "true" -process "Generate Programming File"
   project set "Enable Cyclic Redundancy Checking (CRC)" "true" -process "Generate Programming File"
   project set "Create IEEE 1532 Configuration File" "false" -process "Generate Programming File"
   project set "Create ReadBack Data Files" "false" -process "Generate Programming File"
   project set "Configuration Pin Program" "Pull Up" -process "Generate Programming File"
   project set "Place MultiBoot Settings into Bitstream" "false" -process "Generate Programming File"
   project set "Configuration Rate" "2" -process "Generate Programming File"
   project set "Set SPI Configuration Bus Width" "1" -process "Generate Programming File"
   project set "JTAG Pin TCK" "Pull Up" -process "Generate Programming File"
   project set "JTAG Pin TDI" "Pull Up" -process "Generate Programming File"
   project set "JTAG Pin TDO" "Pull Up" -process "Generate Programming File"
   project set "JTAG Pin TMS" "Pull Up" -process "Generate Programming File"
   project set "Unused IOB Pins" "Pull Down" -process "Generate Programming File"
   project set "Watchdog Timer Value" "0xFFFF" -process "Generate Programming File"
   project set "Security" "Enable Readback and Reconfiguration" -process "Generate Programming File"
   project set "FPGA Start-Up Clock" "CCLK" -process "Generate Programming File"
   project set "Done (Output Events)" "Default (4)" -process "Generate Programming File"
   project set "Drive Done Pin High" "false" -process "Generate Programming File"
   project set "Enable Outputs (Output Events)" "Default (5)" -process "Generate Programming File"
   project set "Wait for DCM and PLL Lock (Output Events)" "Default (NoWait)" -process "Generate Programming File"
   project set "Release Write Enable (Output Events)" "Default (6)" -process "Generate Programming File"
   project set "Enable Internal Done Pipe" "false" -process "Generate Programming File"
   project set "Drive Awake Pin During Suspend/Wake Sequence" "false" -process "Generate Programming File"
   project set "Enable Suspend/Wake Global Set/Reset" "false" -process "Generate Programming File"
   project set "Enable Multi-Pin Wake-Up Suspend Mode" "false" -process "Generate Programming File"
   project set "GTS Cycle During Suspend/Wakeup Sequence" "4" -process "Generate Programming File"
   project set "GWE Cycle During Suspend/Wakeup Sequence" "5" -process "Generate Programming File"
   project set "Wakeup Clock" "Startup Clock" -process "Generate Programming File"
   project set "Allow Logic Optimization Across Hierarchy" "false" -process "Map"
   project set "Maximum Compression" "false" -process "Map"
   project set "Generate Detailed MAP Report" "true" -process "Map"
   project set "Map Slice Logic into Unused Block RAMs" "false" -process "Map"
   project set "Trim Unconnected Signals" "true" -process "Map"
   project set "Create I/O Pads from Ports" "false" -process "Translate"
   project set "Macro Search Path" "" -process "Translate"
   project set "Netlist Translation Type" "Timestamp" -process "Translate"
   project set "User Rules File for Netlister Launcher" "" -process "Translate"
   project set "Allow Unexpanded Blocks" "false" -process "Translate"
   project set "Allow Unmatched LOC Constraints" "false" -process "Translate"
   project set "Allow Unmatched Timing Group Constraints" "false" -process "Translate"
   project set "Perform Advanced Analysis" "false" -process "Generate Post-Place & Route Static Timing"
   project set "Report Paths by Endpoint" "3" -process "Generate Post-Place & Route Static Timing"
   project set "Report Type" "Verbose Report" -process "Generate Post-Place & Route Static Timing"
   project set "Number of Paths in Error/Verbose Report" "3" -process "Generate Post-Place & Route Static Timing"
   project set "Stamp Timing Model Filename" "" -process "Generate Post-Place & Route Static Timing"
   project set "Report Unconstrained Paths" "" -process "Generate Post-Place & Route Static Timing"
   project set "Perform Advanced Analysis" "false" -process "Generate Post-Map Static Timing"
   project set "Report Paths by Endpoint" "3" -process "Generate Post-Map Static Timing"
   project set "Report Type" "Verbose Report" -process "Generate Post-Map Static Timing"
   project set "Number of Paths in Error/Verbose Report" "3" -process "Generate Post-Map Static Timing"
   project set "Report Unconstrained Paths" "" -process "Generate Post-Map Static Timing"
   project set "Number of Clock Buffers" "16" -process "Synthesize - XST"
   project set "Add I/O Buffers" "true" -process "Synthesize - XST"
   project set "Global Optimization Goal" "AllClockNets" -process "Synthesize - XST"
   project set "Keep Hierarchy" "No" -process "Synthesize - XST"
   project set "Max Fanout" "100000" -process "Synthesize - XST"
   project set "Register Balancing" "No" -process "Synthesize - XST"
   project set "Register Duplication" "true" -process "Synthesize - XST"
   project set "Library for Verilog Sources" "" -process "Synthesize - XST"
   project set "Export Results to XPower Estimator" "" -process "Generate Text Power Report"
   project set "Asynchronous To Synchronous" "false" -process "Synthesize - XST"
   project set "Automatic BRAM Packing" "false" -process "Synthesize - XST"
   project set "BRAM Utilization Ratio" "100" -process "Synthesize - XST"
   project set "Bus Delimiter" "<>" -process "Synthesize - XST"
   project set "Case" "Maintain" -process "Synthesize - XST"
   project set "Cores Search Directories" "" -process "Synthesize - XST"
   project set "Cross Clock Analysis" "false" -process "Synthesize - XST"
   project set "DSP Utilization Ratio" "100" -process "Synthesize - XST"
   project set "Equivalent Register Removal" "true" -process "Synthesize - XST"
   project set "FSM Style" "LUT" -process "Synthesize - XST"
   project set "Generate RTL Schematic" "Yes" -process "Synthesize - XST"
   project set "Generics, Parameters" "" -process "Synthesize - XST"
   project set "Hierarchy Separator" "/" -process "Synthesize - XST"
   project set "HDL INI File" "" -process "Synthesize - XST"
   project set "LUT Combining" "Auto" -process "Synthesize - XST"
   project set "Library Search Order" "" -process "Synthesize - XST"
   project set "Netlist Hierarchy" "As Optimized" -process "Synthesize - XST"
   project set "Optimize Instantiated Primitives" "false" -process "Synthesize - XST"
   project set "Pack I/O Registers into IOBs" "Auto" -process "Synthesize - XST"
   project set "Power Reduction" "false" -process "Synthesize - XST"
   project set "Read Cores" "true" -process "Synthesize - XST"
   project set "Use Clock Enable" "Auto" -process "Synthesize - XST"
   project set "Use Synchronous Reset" "Auto" -process "Synthesize - XST"
   project set "Use Synchronous Set" "Auto" -process "Synthesize - XST"
   project set "Use Synthesis Constraints File" "true" -process "Synthesize - XST"
   project set "Verilog Include Directories" "" -process "Synthesize - XST"
   project set "Verilog Macros" "" -process "Synthesize - XST"
   project set "Work Directory" "C:/Users/heyihui/Desktop/Bombe0.12.6/BombeBeta/Bombe/xst" -process "Synthesize - XST"
   project set "Write Timing Constraints" "false" -process "Synthesize - XST"
   project set "Other XST Command Line Options" "" -process "Synthesize - XST"
   project set "Timing Mode" "Performance Evaluation" -process "Map"
   project set "Generate Asynchronous Delay Report" "false" -process "Place & Route"
   project set "Generate Clock Region Report" "false" -process "Place & Route"
   project set "Generate Post-Place & Route Power Report" "false" -process "Place & Route"
   project set "Generate Post-Place & Route Simulation Model" "false" -process "Place & Route"
   project set "Power Reduction" "false" -process "Place & Route"
   project set "Place & Route Effort Level (Overall)" "High" -process "Place & Route"
   project set "Auto Implementation Compile Order" "true"
   project set "Equivalent Register Removal" "true" -process "Map"
   project set "Placer Extra Effort" "None" -process "Map"
   project set "Power Activity File" "" -process "Map"
   project set "Register Duplication" "Off" -process "Map"
   project set "Generate Constraints Interaction Report" "false" -process "Generate Post-Map Static Timing"
   project set "Synthesis Constraints File" "" -process "Synthesize - XST"
   project set "RAM Style" "Auto" -process "Synthesize - XST"
   project set "Maximum Number of Lines in Report" "1000" -process "Generate Text Power Report"
   project set "MultiBoot: Insert IPROG CMD in the Bitfile" "Enable" -process "Generate Programming File"
   project set "Output File Name" "top" -process "Generate IBIS Model"
   project set "Timing Mode" "Performance Evaluation" -process "Place & Route"
   project set "Create Binary Configuration File" "false" -process "Generate Programming File"
   project set "Enable Debugging of Serial Mode BitStream" "false" -process "Generate Programming File"
   project set "Create Logic Allocation File" "false" -process "Generate Programming File"
   project set "Create Mask File" "false" -process "Generate Programming File"
   project set "Retry Configuration if CRC Error Occurs" "false" -process "Generate Programming File"
   project set "MultiBoot: Starting Address for Next Configuration" "0x00000000" -process "Generate Programming File"
   project set "MultiBoot: Starting Address for Golden Configuration" "0x00000000" -process "Generate Programming File"
   project set "MultiBoot: Use New Mode for Next Configuration" "true" -process "Generate Programming File"
   project set "MultiBoot: User-Defined Register for Failsafe Scheme" "0x0000" -process "Generate Programming File"
   project set "Setup External Master Clock Division" "1" -process "Generate Programming File"
   project set "Allow SelectMAP Pins to Persist" "false" -process "Generate Programming File"
   project set "Mask Pins for Multi-Pin Wake-Up Suspend Mode" "0x00" -process "Generate Programming File"
   project set "Enable Multi-Threading" "Off" -process "Map"
   project set "Generate Constraints Interaction Report" "false" -process "Generate Post-Place & Route Static Timing"
   project set "Move First Flip-Flop Stage" "true" -process "Synthesize - XST"
   project set "Move Last Flip-Flop Stage" "true" -process "Synthesize - XST"
   project set "ROM Style" "Auto" -process "Synthesize - XST"
   project set "Safe Implementation" "No" -process "Synthesize - XST"
   project set "Power Activity File" "" -process "Place & Route"
   project set "Extra Effort (Highest PAR level only)" "None" -process "Place & Route"
   project set "MultiBoot: Next Configuration Mode" "001" -process "Generate Programming File"
   project set "Encrypt Bitstream" "false" -process "Generate Programming File"
   project set "Enable Multi-Threading" "Off" -process "Place & Route"
   project set "AES Initial Vector" "" -process "Generate Programming File"
   project set "Encrypt Key Select" "BBRAM" -process "Generate Programming File"
   project set "AES Key (Hex String)" "" -process "Generate Programming File"
   project set "Input Encryption Key File" "" -process "Generate Programming File"
   project set "Functional Model Target Language" "Verilog" -process "View HDL Source"
   project set "Change Device Speed To" "-3" -process "Generate Post-Place & Route Static Timing"
   project set "Change Device Speed To" "-3" -process "Generate Post-Map Static Timing"

   puts "$myScript: project property values set."

} ; # end set_process_props


# ################
# MAP_Report
# ################
# This proc is used to  show the Map Report
#
proc map_report {} {
	global dirpath
	global topFile_name
	set f [open "$dirpath/$topFile_name.syr" r]
    set w [open "$dirpath/map_report.txt" w]

	set Phrase "Device utilization summary:"
	set Phrase1 "Timing Summary:"

	set count 1
	set start 0
	set count1 1
	set start1 0

	while {[gets $f line] != -1} {

		set flag [string match $line $Phrase]
		if {$flag == 1} { set start [expr $start+1] }
		if { $start == 1 && $count <25} {
		puts $line
		puts $w $line
		set count [expr $count+1]
		}
	
		set flag1 [string match $line $Phrase1]
		if {$flag1 == 1} { set start1 [expr $start1+1] }
		if { $start1 == 1 && $count1 <9} {
		puts $line
		puts $w $line
		set count1 [expr $count1+1]
		}
	}
		close $f
		close $w
}


# ##########################################################################################
# main  
# ##########################################################################################
proc main {} {

   if { [llength $::argv] == 0 } {
      show_help
      return true
   }

   foreach option $::argv {
      switch $option {
	     "new_project"         { new_project}
         "show_help"           { show_help }
         "run_process"         { run_process }
         "rebuild_project"     { rebuild_project }
         "set_project_props"   { set_project_props }
         "add_source_files"    { add_source_files }
         "create_libraries"    { create_libraries }
         "set_process_props"   { set_process_props }
         default               { puts "unrecognized option: $option"; show_help }
      }
   }
}

if { $tcl_interactive } {
   show_help
} else {
   if {[catch {main} result]} {
      puts "$myScript failed: $result."
   }
}


# #######################
# add_source_files
# #######################
# This procedure add the source files that were known to the project at the
# time this script was generated.
# 

 proc add_source_files {} {

   global myScript

   if { ! [ open_project ] } {
    puts  "No project was opend."
    return false }

 puts "$myScript: Adding sources to project..." 
  xfile add "AddrDec.v" 
  xfile add "ALU.v" 
  xfile add "AluDec.v" 
  xfile add "btn.v" 
  xfile add "Buffer.v" 
  xfile add "Buffer_n.v" 
  xfile add "CharDecROM.v" 
  xfile add "controller.v" 
  xfile add "CP0.v" 
  xfile add "cp0_cause.v" 
  xfile add "cp0_compare.v" 
  xfile add "cp0_reg.v" 
  xfile add "cp0_SR.v" 
  xfile add "CPU.v" 
  xfile add "DataMem.v" 
  xfile add "datapath.v" 
  xfile add "ExcVector.v" 
  xfile add "extend.v" 
  xfile add "flopr.v" 
  xfile add "flopr_n.v" 
  xfile add "fsm.v" 
  xfile add "GC_AttrDec.v" 
  xfile add "GC_CharDec.v" 
  xfile add "GC_CRTctrl.v" 
  xfile add "GC_mem.v" 
  xfile add "GC_memRAM.v" 
  xfile add "GC_RF.v" 
  xfile add "GC_top.v" 
  xfile add "InstrMem.v" 
  xfile add "IOUnit.v" 
  xfile add "LED.v" 
  xfile add "MainProcess.v" 
  xfile add "MDU.v" 
  xfile add "MDU_comb.v" 
  xfile add "MDU_counter.v" 
  xfile add "mux2.v" 
  xfile add "mux4.v" 
  xfile add "mux8.v" 
  xfile add "myclk.v" 
  xfile add "myclk_exdes.v" 
  xfile add "myclk_tb.v" 
  xfile add "PC_reg.v" 
  xfile add "ps2_RF.v" 
  xfile add "ps2_scan.v" 
  xfile add "ps2_top.v" 
  xfile add "RAM_32KB.v" 
  xfile add "regfile.v" 
  xfile add "ROM_8KB.v" 
  xfile add "sl2.v" 
  xfile add "SysBr.v" 
  xfile add "SysBrDec.v" 
  xfile add "TC8253.v" 
  xfile add "TC8253_tb.v" 
  xfile add "testbench.v" 
  xfile add "timer.v" 
  xfile add "top.v" 
  xfile add "VGA_char.v" 
  xfile add "CharDecROM.xco" 
  xfile add "GC_memRAM.xco" 
  xfile add "myclk.xco" 
  xfile add "RAM_32KB.xco" 
  xfile add "ROM_8KB.xco" 
#  Set the Top Module as well... 
   project set top "top" 

   puts "$myScript: project sources reloaded." 

  }
