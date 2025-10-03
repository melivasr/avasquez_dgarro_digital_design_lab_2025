transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+F:/Proyectos\ Quartos/avasquez_dgarro_digital_design_lab_2025/Lab3 {F:/Proyectos Quartos/avasquez_dgarro_digital_design_lab_2025/Lab3/controladora_FSM.sv}
vlog -sv -work work +incdir+F:/Proyectos\ Quartos/avasquez_dgarro_digital_design_lab_2025/Lab3 {F:/Proyectos Quartos/avasquez_dgarro_digital_design_lab_2025/Lab3/seven_segment_display.sv}
vlog -sv -work work +incdir+F:/Proyectos\ Quartos/avasquez_dgarro_digital_design_lab_2025/Lab3 {F:/Proyectos Quartos/avasquez_dgarro_digital_design_lab_2025/Lab3/vga.sv}
vlog -sv -work work +incdir+F:/Proyectos\ Quartos/avasquez_dgarro_digital_design_lab_2025/Lab3 {F:/Proyectos Quartos/avasquez_dgarro_digital_design_lab_2025/Lab3/time_counter.sv}
vlog -sv -work work +incdir+F:/Proyectos\ Quartos/avasquez_dgarro_digital_design_lab_2025/Lab3 {F:/Proyectos Quartos/avasquez_dgarro_digital_design_lab_2025/Lab3/timer15_7seg.sv}

vlog -sv -work work +incdir+F:/Proyectos\ Quartos/avasquez_dgarro_digital_design_lab_2025/Lab3 {F:/Proyectos Quartos/avasquez_dgarro_digital_design_lab_2025/Lab3/tb.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  tb

add wave *
view structure
view signals
run -all
