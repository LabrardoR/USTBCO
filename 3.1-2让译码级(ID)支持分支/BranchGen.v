`timescale 1ns/1ps

`include "bus.v"
`include "opcode.v"
`include "funct.v"
`include "segpos.v"

module BranchGen(
  input        [`ADDR_BUS]     addr,
  input        [`INST_BUS]     inst,
  input        [`INST_OP_BUS]  op,
  input        [`FUNCT_BUS]    funct,
  input        [`DATA_BUS]     reg_data_1,
  input        [`DATA_BUS]     reg_data_2,
  output  reg                  branch_flag,
  output  reg  [`ADDR_BUS]     branch_addr
);

  wire[`ADDR_BUS] addr_plus_4 = addr + 4;
  wire[25:0]  jump_addr = inst[25:0];
  // todo

  always @(*) begin
    case(op)
// OP_JALR == OP_SPECIAL 
      `OP_SPECIAL: begin
        // 跳转目标为寄存器 rs 中的值。
        // 同时将该分支对应延迟槽指令之后的指令的 PC 值保存至寄存器 rd 中。 
        if(funct == `FUNCT_JALR) begin
          branch_flag <= 1;
          branch_addr <= reg_data_1;
        end
        else begin
          branch_flag <= 0;
          branch_addr <= 0;
        end
      end

// 转移目标由立即数 offset 左移 2 位，并进行有符号扩展的值加上该分支指令对应的延迟槽指令的 PC 计算得到
      `OP_BEQ: begin
        if(reg_data_1 == reg_data_2) begin
          branch_flag <= 1;
          branch_addr <= addr_plus_4 + {{14{inst[15]}},{inst[`SEG_OFFSET]}, 2'b00};
        end
        else begin
          branch_flag <= 0;
          branch_addr <= 0;
        end
      end
// 同上
      `OP_BNE: begin
        if(reg_data_1 != reg_data_2) begin
          branch_flag <= 1;
          branch_addr <= addr_plus_4 + {{14{inst[15]}},{inst[`SEG_OFFSET]}, 2'b00};
        end
        else begin
          branch_flag <= 0;
          branch_addr <= 0;
        end      
      end
// 跳转目标由该分支指令对应的延迟槽指令的 PC 的最高 4 位与立即数 instr_index 左移 2 位后的值拼接得到。
// 同时将该分支对应延迟槽指令之后的指令的 PC 值保存至第 31 号通用寄存器中。
      `OP_JAL: begin
        branch_flag <= 1;
        branch_addr <= {addr_plus_4[31:28], jump_addr, 2'b00};
      end
      default: begin
        branch_flag <= 0;
        branch_addr <= 0;
      end
    endcase
  end




endmodule // BranchGen.v