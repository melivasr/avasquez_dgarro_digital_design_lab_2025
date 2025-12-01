module rom_i (
    input  logic [7:0]  address,    // 0..255 (8 bits)
    output logic [31:0] q
);

    // Memoria de 256 palabras de 32 bits para código
    (* ram_init_file = "program.hex" *)
    logic [31:0] mem [0:255];

`ifndef SYNTHESIS
    // Para simulación
    initial $readmemh("program.hex", mem);
`endif

    always_comb begin
        q = mem[address];
    end

endmodule
