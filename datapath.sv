////////////
`timescale 1ns / 1ps
module datapath(input  logic        clk, reset,
                input  logic        memtoreg, pcsrc,
                input  logic        alusrc, regdst,
                input  logic        regwrite, jump,
                input  logic [3:0]  alucontrol,
                output logic        zero,
                output logic [31:0] pc,
                input  logic [31:0] instr,
                output logic [31:0] aluout, writedata,
                input  logic [31:0] readdata);
  logic jrcontrol1, jrcontrol2;
  logic [4:0]  writereg;
  logic [31:0] pcnext, pcnextbr, pcplus4, pcbranch,jrnext;
  logic [31:0] signimm, signimmsh;
  logic [31:0] srca, srcb, srcd;
  logic [31:0] result;
  // next PC logic
  flopr #(32) pcreg(clk, reset, pcnext,instr,srca, pc);
//  adder       pcadd1(pc, 32'b100, pcplus4); //This is what is wrong, this assumes a "simpler" adder; what we have from lab 7 is more complex, it even takes in c_in, and even produces c_out
  adder #(32) pcadd1(pc, 32'b100, 'b0, pcplus4); //So we adjust to use the more complex adder
  sl2         immsh(signimm, signimmsh);
//  adder       pcadd2(pcplus4, signimmsh, pcbranch); //See comment above
  adder #(32) pcadd2(pcplus4, signimmsh, 'b0, pcbranch); //See comment above
  mux2 #(32)  pcbrmux(pcplus4, pcbranch, pcsrc, pcnextbr);
  mux2 #(32)  pcmux(pcnextbr, {pcplus4[31:28], 
                    instr[25:0], 2'b00}, jump, pcnext);               
  // register file logic
  regfile     rf(clk, regwrite, instr[25:21], instr[20:16], 
                 writereg, result, srca, writedata,srcd);
  mux2 #(5)   wrmux(instr[20:16], instr[15:11],
                    regdst, writereg);
  mux2 #(32)  resmux(aluout, readdata, memtoreg, result);
  signext     se(instr[15:0],instr[31:26], signimm);

  // ALU logic
  mux2 #(32)  srcbmux(writedata, signimm, alusrc, srcb);
  alu         alu(srca, srcb,srcd, alucontrol,instr[31:26],instr[10:6], aluout, zero);
endmodule