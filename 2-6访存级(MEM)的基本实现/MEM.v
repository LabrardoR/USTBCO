`timescale 1ns/1ps

`include "bus.v"

module MEM(
  input                       mem_read_flag_in,      // MEM 中内存的读信号
  input                       mem_write_flag_in,     // MEM 中内存的写信号
  input                       mem_sign_ext_flag_in,  // 读取内存数据符号拓展信号
  input       [`MEM_SEL_BUS]  mem_sel_in,            // MEM 的写位置信号 
  input       [`DATA_BUS]     mem_write_data,        // 给 MEM 的写数据
  input       [`DATA_BUS]     result_in,             // 输入的计算结果
  input                       reg_write_en_in,       // 寄存器对写使能
  input       [`REG_ADDR_BUS] reg_write_addr_in,     // 寄存器堆写地址
  input       [`ADDR_BUS]     current_pc_addr_in,    // 当前执行指令 PC 值
  output                      ram_en,                // ram 使能
  output      [`MEM_SEL_BUS]  ram_write_en,          // ram 写使能
  output      [`ADDR_BUS]     ram_addr,              // ram 地址
  output  reg [`DATA_BUS]     ram_write_data,        // ram 写数据
  // to ID stage
  output                      mem_load_flag,         // 发生 load 指令
  // to WB stage
  output                      mem_read_flag_out,     // MEM 中内存的读信号
  output                      mem_write_flag_out,    // MEM 中内存的写信号
  output                      mem_sign_ext_flag_out, // 读取内存数据符号拓展信号
  output      [`MEM_SEL_BUS]  mem_sel_out,           // MEM 的写位置信号
  output      [`DATA_BUS]     result_out,            // 将计算结果传给 WB
  output                      reg_write_en_out,      // 寄存器堆写使能
  output      [`REG_ADDR_BUS] reg_write_addr_out,    // 寄存器堆写地址
  output      [`ADDR_BUS]     current_pc_addr_out    // 当前执行指令PC值
);


  assign mem_read_flag_out = mem_read_flag_in;
  assign mem_write_flag_out = mem_write_flag_in;
  assign mem_sign_ext_flag_out = mem_sign_ext_flag_in;
  assign mem_sel_out = mem_sel_in;
  assign result_out = result_in;
  assign reg_write_en_out = reg_write_en_in;
  assign reg_write_addr_out = reg_write_addr_in;
  assign current_pc_addr_out = current_pc_addr_in;




endmodule