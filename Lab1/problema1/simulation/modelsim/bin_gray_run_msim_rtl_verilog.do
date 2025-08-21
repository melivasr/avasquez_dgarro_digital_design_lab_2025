transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+F:/Proyectos\ Quartos/avasquez_dgarro_digital_design_lab_2025/Lab1/problema1 {F:/Proyectos Quartos/avasquez_dgarro_digital_design_lab_2025/Lab1/problema1/bin_gray.sv}

vlog -sv -work work +incdir+F:/Proyectos\ Quartos/avasquez_dgarro_digital_design_lab_2025/Lab1/problema1 {F:/Proyectos Quartos/avasquez_dgarro_digital_design_lab_2025/Lab1/problema1/bin_gray_tb.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  bin_gray_tb

add wave *
view structure
view signals
run -all
