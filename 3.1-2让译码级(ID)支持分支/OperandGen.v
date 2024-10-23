`timescale 1ns/1ps

/*
判断指令操作数来自寄存器堆还是立即数，
然后从 RegFile 或者指令本身中，
读出寄存器或立即数的值，作为操作数的输出
*/
module OperandGen(
  input          [`INST_OP_BUS]   op,
  input          [`HALF_DATA_BUS] imm,
  input          [`DATA_BUS]      reg_data_1,        // 从 RegFile 得到的数据 1
  input          [`DATA_BUS]      reg_data_2,        // 从 RegFile 得到的数据 2
  output   reg   [`DATA_BUS]      operand_1,         
  output   reg   [`DATA_BUS]      operand_2
);

// extract immediate from instruction
  wire[`DATA_BUS] sign_ext_imm = {{16{imm[15]}}, imm};
// generate operand_1

  always @(*) begin
    case (op)
    // immediate
      `OP_ADDIU: begin
        operand_1 <= reg_data_1;
      end
      `OP_BEQ, `OP_BNE: begin
        operand_1 <= reg_data_1;
      end
      `OP_JAL: begin
        operand_1 <= reg_data_1;
      end
      default: begin
        operand_1 <= 0;
      end
    endcase
  end
// generate operand_2
  always @(*) begin
    case (op)
      `OP_ADDIU: begin
        operand_2 <= sign_ext_imm;
      end
      `OP_BEQ, `OP_BNE: begin
        operand_2 <= reg_data_2;
      end
      `OP_JAL: begin
        operand_2 <= reg_data_2;
      end
      `OP_SPECIAL: begin
        operand_2 <= reg_data_2;
      end
      default: begin
        operand_2 <= 0;
      end
    endcase
  end


endmodule
