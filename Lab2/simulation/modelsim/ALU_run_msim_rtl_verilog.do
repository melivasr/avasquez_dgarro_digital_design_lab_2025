transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+F:/Proyectos\ Quartos/avasquez_dgarro_digital_design_lab_2025/Lab2 {F:/Proyectos Quartos/avasquez_dgarro_digital_design_lab_2025/Lab2/XOR.sv}
vlog -sv -work work +incdir+F:/Proyectos\ Quartos/avasquez_dgarro_digital_design_lab_2025/Lab2 {F:/Proyectos Quartos/avasquez_dgarro_digital_design_lab_2025/Lab2/AND.sv}
vlog -sv -work work +incdir+F:/Proyectos\ Quartos/avasquez_dgarro_digital_design_lab_2025/Lab2 {F:/Proyectos Quartos/avasquez_dgarro_digital_design_lab_2025/Lab2/OR.sv}
vlog -sv -work work +incdir+F:/Proyectos\ Quartos/avasquez_dgarro_digital_design_lab_2025/Lab2 {F:/Proyectos Quartos/avasquez_dgarro_digital_design_lab_2025/Lab2/Full_Adder.sv}
vlog -sv -work work +incdir+F:/Proyectos\ Quartos/avasquez_dgarro_digital_design_lab_2025/Lab2 {F:/Proyectos Quartos/avasquez_dgarro_digital_design_lab_2025/Lab2/Full_Substractor.sv}
vlog -sv -work work +incdir+F:/Proyectos\ Quartos/avasquez_dgarro_digital_design_lab_2025/Lab2 {F:/Proyectos Quartos/avasquez_dgarro_digital_design_lab_2025/Lab2/NOT.sv}
vlog -sv -work work +incdir+F:/Proyectos\ Quartos/avasquez_dgarro_digital_design_lab_2025/Lab2 {F:/Proyectos Quartos/avasquez_dgarro_digital_design_lab_2025/Lab2/Division.sv}
vlog -sv -work work +incdir+F:/Proyectos\ Quartos/avasquez_dgarro_digital_design_lab_2025/Lab2 {F:/Proyectos Quartos/avasquez_dgarro_digital_design_lab_2025/Lab2/Ripple_carry_adder4.sv}
vlog -sv -work work +incdir+F:/Proyectos\ Quartos/avasquez_dgarro_digital_design_lab_2025/Lab2 {F:/Proyectos Quartos/avasquez_dgarro_digital_design_lab_2025/Lab2/ALU.sv}
vlog -sv -work work +incdir+F:/Proyectos\ Quartos/avasquez_dgarro_digital_design_lab_2025/Lab2 {F:/Proyectos Quartos/avasquez_dgarro_digital_design_lab_2025/Lab2/Full_subtractor4.sv}
vlog -sv -work work +incdir+F:/Proyectos\ Quartos/avasquez_dgarro_digital_design_lab_2025/Lab2 {F:/Proyectos Quartos/avasquez_dgarro_digital_design_lab_2025/Lab2/shift_left.sv}
vlog -sv -work work +incdir+F:/Proyectos\ Quartos/avasquez_dgarro_digital_design_lab_2025/Lab2 {F:/Proyectos Quartos/avasquez_dgarro_digital_design_lab_2025/Lab2/shift_right.sv}
vlog -sv -work work +incdir+F:/Proyectos\ Quartos/avasquez_dgarro_digital_design_lab_2025/Lab2 {F:/Proyectos Quartos/avasquez_dgarro_digital_design_lab_2025/Lab2/Modulo.sv}
vlog -sv -work work +incdir+F:/Proyectos\ Quartos/avasquez_dgarro_digital_design_lab_2025/Lab2 {F:/Proyectos Quartos/avasquez_dgarro_digital_design_lab_2025/Lab2/7seg_display.sv}
vlog -sv -work work +incdir+F:/Proyectos\ Quartos/avasquez_dgarro_digital_design_lab_2025/Lab2 {F:/Proyectos Quartos/avasquez_dgarro_digital_design_lab_2025/Lab2/Alu_control.sv}

vlog -sv -work work +incdir+F:/Proyectos\ Quartos/avasquez_dgarro_digital_design_lab_2025/Lab2 {F:/Proyectos Quartos/avasquez_dgarro_digital_design_lab_2025/Lab2/tb.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  tb

add wave *
view structure
view signals
run -all
