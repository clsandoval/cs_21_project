////////////
`timescale 1ns / 1ps
module alu(input  logic [31:0] a, b, d,
           input  logic [3:0]  alucontrol,
           input logic [5:0] opcode,
           input logic [4:0] shamt,
           output logic [31:0] result,
           output logic        zero);

  logic [31:0] condinvb, sum, diffshift, diff;
  assign diff =  a + ~b + alucontrol[3];
  assign condinvb = alucontrol[3] ? ~b : b;
  assign sum = a + condinvb + alucontrol[3];
  
  always_comb
        begin
        if (diff > 32)
            diffshift <=32'hc0debabe;
        else
            diffshift <= (d << diff);
        end
  always_comb
    case (alucontrol[2:0])
      3'b000: result = a & b;
      3'b001: result = a | b;
      3'b010: result = sum;
      3'b011: result = sum[31];
      3'b111: result = b >> shamt;
      3'b100: result <= diffshift;
    endcase
  always_comb
    case(opcode)
      6'b100110: zero <= (~result[31]); // bge
      6'b000001: zero <= (result[31]); // blt
      6'b000101: zero <= (result != 32'b0); // bne
      default:   zero <= (result == 32'b0); // beq
    endcase
endmodule
