`timescale 1ns/1ps

`include "bus.v"
`include "opcode.v"
`include "funct.v"

// 操作码 funct 生成模块
module FunctGen(
  input          [`INST_OP_BUS]   op,
  input          [`FUNCT_BUS]     funct_in,              // 从 IF 得到的指令内容
  output   reg   [`FUNCT_BUS]     funct            // 给 EX 的操作码
);
  
  
  always @(*) begin
    case (op)
      `OP_SPECIAL: funct <= funct_in;
      `OP_ADDIU: funct <= `FUNCT_ADDU;
      default: funct <= `FUNCT_NOP;
    endcase
  end

endmodule // FunctGen