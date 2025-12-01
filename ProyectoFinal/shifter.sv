module shifter(
  input  logic [31:0] B,
  input  logic [1:0]  Sh, // 00=LSL, 01=LSR, 10=ASR, 11=ROR
  input  logic [4:0]  Shamt5,
  output logic [31:0] ShOut
);

  always_comb begin
    case (Sh)
      2'b00: ShOut = B << Shamt5;                      // LSL
      2'b01: ShOut = B >> Shamt5;                      // LSR lógico
      2'b10: ShOut = $signed(B) >>> Shamt5;            // ASR
      2'b11: ShOut = (B >> Shamt5) | (B << (32-Shamt5)); // ROR
      default: ShOut = B;
    endcase
  end
endmodule
