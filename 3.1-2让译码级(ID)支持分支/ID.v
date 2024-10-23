`timescale 1ns/1ps

`include "bus.v"
`include "segpos.v"
`include "opcode.v"
`include "funct.v"

module ID(

  input          [`ADDR_BUS]      addr,              // 从 IF 得到的 pc 取指地址
  input          [`INST_BUS]      inst,              // 从 IF 得到的指令内容

  input                           load_related_1,    // EX 中 load 指令标志
  input                           load_related_2,    // MEM 中 load 指令标志

  output                          reg_read_en_1,     // 给 RegFile 的使能信号 1
  output         [`REG_ADDR_BUS]  reg_addr_1,        // 给 RegFile 的地址 1
  input          [`DATA_BUS]      reg_data_1,        // 从 RegFile 得到的数据 1

  output                          reg_read_en_2,     // 给 RegFile 的使能信号 2
  output         [`REG_ADDR_BUS]      reg_addr_2,        // 给 RegFile 的地址 2
  input          [`DATA_BUS]      reg_data_2,        // 从 RegFile 得到的数据 2

  output                          stall_request,     // 暂停请求（暂不使用）

  output                          branch_flag,       // 跳转信号（暂不使用）
  output         [`ADDR_BUS]      branch_addr,       // 跳转地址（暂不使用）

  output         [`FUNCT_BUS]     funct,             // 给 EX 的操作码
  output         [`SHAMT_BUS]     shamt,             // 给 EX 的移位数
  output         [`DATA_BUS]      operand_1,         // 给 EX 的操作数 1
  output         [`DATA_BUS]      operand_2,         // 给 EX 的操作数 2

  output                          mem_read_flag,     // 给 MEM 的读信号
  output                          mem_write_flag,    // 给 MEM 的写信号
  output                          mem_sign_ext_flag, // 给 MEM 的符号拓展信号
  output         [`MEM_SEL_BUS]   mem_sel,           // 给 MEM 的写位置信号      
  output         [`DATA_BUS]      mem_write_data,    // 给 MEM 的写数据

  output                          reg_write_en,      // 给 WB 的写寄存器信号
  output         [`REG_ADDR_BUS]  reg_write_addr,    // 给 WB 的写寄存器地址
  output         [`ADDR_BUS]      current_pc_addr    // 给下一级的该指令地址       
);

  // 从 inst 中获得的精确信息
  wire[`INST_OP_BUS]   inst_op        = inst[`SEG_OPCODE];
  wire[`REG_ADDR_BUS]  inst_rs        = inst[`SEG_RS];
  wire[`REG_ADDR_BUS]  inst_rt        = inst[`SEG_RT];
  wire[`REG_ADDR_BUS]  inst_rd        = inst[`SEG_RD];
  wire[`SHAMT_BUS]     inst_shamt     = inst[`SEG_SHAMT];
  wire[`FUNCT_BUS]     inst_funct     = inst[`SEG_FUNCT];
  wire[`HALF_DATA_BUS] inst_imm       = inst[`SEG_IMM];

  assign shamt = inst_shamt;
  assign stall_request = load_related_1 || load_related_2;
  assign current_pc_addr = addr;


  BranchGen branch_gen(
    .addr          (addr),
    .inst          (inst),
    .op            (inst_op),
    .funct         (inst_funct),
    .reg_data_1    (reg_data_1),
    .reg_data_2    (reg_data_2),
    .branch_flag   (branch_flag),
    .branch_addr   (branch_addr)        
  );

  FunctGen funct_gen(
    .op            (inst_op),
    .funct_in      (inst_funct),
    .funct         (funct)
  );

  RegGen reg_gen(
    .op            (inst_op),
    .rs            (inst_rs),
    .rt            (inst_rt),
    .rd            (inst_rd),
    .reg_read_en_1 (reg_read_en_1),
    .reg_addr_1    (reg_addr_1),
    .reg_read_en_2 (reg_read_en_2),
    .reg_addr_2    (reg_addr_2), 
    .reg_write_en  (reg_write_en),
    .reg_write_addr(reg_write_addr)
  );

  OperandGen operand_gen(
    .imm           (inst_imm),
    .op            (inst_op),
    .reg_data_1    (reg_data_1),
    .reg_data_2    (reg_data_2),
    .operand_1     (operand_1),
    .operand_2     (operand_2)
  );



endmodule