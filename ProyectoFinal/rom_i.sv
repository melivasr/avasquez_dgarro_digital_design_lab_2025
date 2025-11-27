module rom_i (
    input  logic [6:0] address, // 7 bits 128 posiciones
    output logic [31:0] q
);
    logic [31:0] mem [0:127]; // 0..127

    initial $readmemh("program.hex", mem);

    always_comb begin
        q = mem[address];
    end
endmodule
