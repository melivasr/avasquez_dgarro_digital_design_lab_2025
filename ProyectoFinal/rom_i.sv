module rom_i (
    input  logic [5:0] address, // PC[7:2]
    output logic [31:0] q
);
    logic [31:0] mem [0:63];
    initial $readmemh("program.hex", mem); 

    always_comb begin
        q = mem[address];
    end
endmodule
