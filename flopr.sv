module flopr #(parameter WIDTH = 8)
              (input  logic             clk, reset,
               input  logic [WIDTH-1:0] d,
               input  logic [WIDTH-1:0] instr,
               input  logic [WIDTH-1:0] srca, 
               output logic [WIDTH-1:0] q);
               
               logic [31:0] pcf = d; 
               always_comb
               case({instr[31:26],instr[5:0]})
               12'b000000001000: pcf <= srca;
               default:   pcf <= d;
               endcase
  always_ff @(posedge clk, posedge reset)
    if (reset) q <= 0;
    else       q <= pcf;
endmodule