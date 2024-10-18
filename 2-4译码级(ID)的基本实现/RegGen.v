`timescale 1ns/1ps

`include "bus.v"
`include "opcode.v"

/*
RegGen.v：生成所有与寄存器读写相关的控制信号。对所有 OP_SPECIAL 的指令（R
型指令）而言，我们需要同时读取 rs 与 rt 的内容，并将结果写入 rd 寄存器。而对于 OP_ADDIU
这条 I 型指令，只需读取 rs 寄存器的值（因为另一个操作数是立即数而非寄存器），并将结
果写入 rt 寄存器。因此有如下代码：
*/
module RegGen(
  input          [`INST_OP_BUS]   op,
  input          [`REG_ADDR_BUS]  rs,
  input          [`REG_ADDR_BUS]  rd,
  input          [`REG_ADDR_BUS]  rt,

  output   reg                    reg_read_en_1,     // 给 RegFile 的使能信号 1
  output   reg   [`REG_ADDR_BUS]  reg_addr_1,        // 给 RegFile 的地址 1

  output   reg                    reg_read_en_2,     // 给 RegFile 的使能信号 2
  output   reg   [`REG_ADDR_BUS]  reg_addr_2,         // 给 RegFile 的地址 2

  output   reg                    reg_write_en,
  output   reg   [`REG_ADDR_BUS]  reg_write_addr
);


  always @(*) begin // generate read address
    case (op)
      `OP_ADDIU: begin
        reg_read_en_1 <= 1;
        reg_read_en_2 <= 0;
        reg_addr_1 <= rs;
        reg_addr_2 <= 0;
      end
      `OP_SPECIAL: begin
        reg_read_en_1 <= 1;
        reg_read_en_2 <= 1;
        reg_addr_1 <= rs;
        reg_addr_2 <= rt;
      end
      // 默认不读寄存器
      default: begin
        reg_read_en_1 <= 0;
        reg_read_en_2 <= 0;
        reg_addr_1 <= 0;
        reg_addr_2 <= 0;
      end
    endcase
  end

  always @(*) begin // generate write address
    case (op)
      `OP_ADDIU: begin
        reg_write_en <= 1;
        reg_write_addr <= rt;
      end
      `OP_SPECIAL: begin
        reg_write_en <= 1;
        reg_write_addr <= rd;
      end
      default: begin
        reg_write_en <= 0;
        reg_write_addr <= 0;
      end
    endcase
  end


endmodule
