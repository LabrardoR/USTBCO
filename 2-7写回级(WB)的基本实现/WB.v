`timescale 1ns/1ps


`include "bus.v"

module WB (
  input       [`DATA_BUS]     ram_read_data,       // 从内存中读取的数据
  input                       mem_read_flag,       // MEM 中内存的读信号
  input                       mem_write_flag,      // MEM 中内存的写信号
  input                       mem_sign_ext_flag,   // 读取内存数据符号拓展信号
  input       [`MEM_SEL_BUS]  mem_sel,             // 内存的写位置信号
  input       [`DATA_BUS]     result_in,           // EX 中的计算结果
  input                       reg_write_en_in,     // 寄存器堆写使能
  input       [`REG_ADDR_BUS] reg_write_addr_in,   // 寄存器堆写地址
  input       [`ADDR_BUS]     current_pc_addr_in,  // 当前执行指令 PC 值
  output reg  [`DATA_BUS]     result_out,          // 写入寄存器堆的数据
  output                      reg_write_en_out,    // 寄存器堆写使能
  output      [`REG_ADDR_BUS] reg_write_addr_out,  // 寄存器堆写地址

  output                      debug_reg_write_en,  // 寄存器堆写使能（debug）
  output      [`ADDR_BUS]     debug_pc_addr_out    // 寄存器堆写地址（debug）
);

  assign reg_write_en_out = reg_write_en_in;
  assign reg_write_addr_out = reg_write_addr_in;

  assign debug_reg_write_en = reg_write_en_in;
  assign debug_pc_addr_out = current_pc_addr_in;

  always @(*) begin
    result_out <= result_in;
  end      



endmodule