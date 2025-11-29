module rom_i (
    input  logic [6:0]  address,  // 128 palabras (0..127)
    output logic [31:0] q
);

    // Para FPGA
    (* ram_init_file = "program.hex" *)
    logic [31:0] mem [0:127];

`ifndef SYNTHESIS
    // Solo para simulación (ModelSim)
    initial $readmemh("program.hex", mem);
`endif

    always_comb begin
        q = mem[address];
    end

endmodule
