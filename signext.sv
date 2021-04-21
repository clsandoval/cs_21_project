module signext(input  logic [15:0] a, input logic [5:0] b,
               output logic [31:0] y);
    always_comb
    case(b)
      6'b001100: y <= {{16{0}}, a}; // RTYPE
      default:   y <= {{16{a[15]}}, a}; // illegal op
    endcase
endmodule