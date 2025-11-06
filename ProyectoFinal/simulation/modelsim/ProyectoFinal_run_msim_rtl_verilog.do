transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/melis/Documents/github/avasquez_dgarro_digital_design_lab_2025/ProyectoFinal {C:/Users/melis/Documents/github/avasquez_dgarro_digital_design_lab_2025/ProyectoFinal/ram.v}
vlog -vlog01compat -work work +incdir+C:/Users/melis/Documents/github/avasquez_dgarro_digital_design_lab_2025/ProyectoFinal {C:/Users/melis/Documents/github/avasquez_dgarro_digital_design_lab_2025/ProyectoFinal/rom.v}
vlog -sv -work work +incdir+C:/Users/melis/Documents/github/avasquez_dgarro_digital_design_lab_2025/ProyectoFinal {C:/Users/melis/Documents/github/avasquez_dgarro_digital_design_lab_2025/ProyectoFinal/alu.sv}
vlog -sv -work work +incdir+C:/Users/melis/Documents/github/avasquez_dgarro_digital_design_lab_2025/ProyectoFinal {C:/Users/melis/Documents/github/avasquez_dgarro_digital_design_lab_2025/ProyectoFinal/arm.sv}
vlog -sv -work work +incdir+C:/Users/melis/Documents/github/avasquez_dgarro_digital_design_lab_2025/ProyectoFinal {C:/Users/melis/Documents/github/avasquez_dgarro_digital_design_lab_2025/ProyectoFinal/condcheck.sv}
vlog -sv -work work +incdir+C:/Users/melis/Documents/github/avasquez_dgarro_digital_design_lab_2025/ProyectoFinal {C:/Users/melis/Documents/github/avasquez_dgarro_digital_design_lab_2025/ProyectoFinal/condlogic.sv}
vlog -sv -work work +incdir+C:/Users/melis/Documents/github/avasquez_dgarro_digital_design_lab_2025/ProyectoFinal {C:/Users/melis/Documents/github/avasquez_dgarro_digital_design_lab_2025/ProyectoFinal/controller.sv}
vlog -sv -work work +incdir+C:/Users/melis/Documents/github/avasquez_dgarro_digital_design_lab_2025/ProyectoFinal {C:/Users/melis/Documents/github/avasquez_dgarro_digital_design_lab_2025/ProyectoFinal/datapath.sv}
vlog -sv -work work +incdir+C:/Users/melis/Documents/github/avasquez_dgarro_digital_design_lab_2025/ProyectoFinal {C:/Users/melis/Documents/github/avasquez_dgarro_digital_design_lab_2025/ProyectoFinal/decoder.sv}
vlog -sv -work work +incdir+C:/Users/melis/Documents/github/avasquez_dgarro_digital_design_lab_2025/ProyectoFinal {C:/Users/melis/Documents/github/avasquez_dgarro_digital_design_lab_2025/ProyectoFinal/extend.sv}
vlog -sv -work work +incdir+C:/Users/melis/Documents/github/avasquez_dgarro_digital_design_lab_2025/ProyectoFinal {C:/Users/melis/Documents/github/avasquez_dgarro_digital_design_lab_2025/ProyectoFinal/flopenr.sv}
vlog -sv -work work +incdir+C:/Users/melis/Documents/github/avasquez_dgarro_digital_design_lab_2025/ProyectoFinal {C:/Users/melis/Documents/github/avasquez_dgarro_digital_design_lab_2025/ProyectoFinal/flopr.sv}
vlog -sv -work work +incdir+C:/Users/melis/Documents/github/avasquez_dgarro_digital_design_lab_2025/ProyectoFinal {C:/Users/melis/Documents/github/avasquez_dgarro_digital_design_lab_2025/ProyectoFinal/mux2.sv}
vlog -sv -work work +incdir+C:/Users/melis/Documents/github/avasquez_dgarro_digital_design_lab_2025/ProyectoFinal {C:/Users/melis/Documents/github/avasquez_dgarro_digital_design_lab_2025/ProyectoFinal/regfile.sv}
vlog -sv -work work +incdir+C:/Users/melis/Documents/github/avasquez_dgarro_digital_design_lab_2025/ProyectoFinal {C:/Users/melis/Documents/github/avasquez_dgarro_digital_design_lab_2025/ProyectoFinal/top.sv}
vlog -sv -work work +incdir+C:/Users/melis/Documents/github/avasquez_dgarro_digital_design_lab_2025/ProyectoFinal {C:/Users/melis/Documents/github/avasquez_dgarro_digital_design_lab_2025/ProyectoFinal/adder_n_bit.sv}

vlog -sv -work work +incdir+C:/Users/melis/Documents/github/avasquez_dgarro_digital_design_lab_2025/ProyectoFinal {C:/Users/melis/Documents/github/avasquez_dgarro_digital_design_lab_2025/ProyectoFinal/top_tb.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  top_tb

add wave *
view structure
view signals
run -all
