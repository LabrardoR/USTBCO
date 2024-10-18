`timescale 1ns/1ps

`include "bus.v"
`include "funct.v"


module EX (
  input         [`FUNCT_BUS]         funct,                // 操作码
  input         [`SHAMT_BUS]         shamt,                // 移位数
  input         [`DATA_BUS]          operand_1,            // 操作数 1
  input         [`DATA_BUS]          operand_2,            // 操作数 2

  output                             ex_load_flag,         // 发生 load 指令
  output  reg   [`DATA_BUS]          result = 0,               // 对操作数计算后的结果


  input                              mem_read_flag_in,     // 给 MEM 的读信号
  input                              mem_write_flag_in,    // 给 MEM 的写信号
  input                              mem_sign_ext_flag_in, // 给 MEM 的符号拓展信号
  input         [`MEM_SEL_BUS]       mem_sel_in,           // 给 MEM 的写位置信号
  input         [`DATA_BUS]          mem_write_data_in,    // 给 MEM 的写数据

  output                             mem_read_flag_out,    // 给 MEM 的读信号
  output                             mem_write_flag_out,   // 给 MEM 的写信号
  output                             mem_sign_ext_flag_out,// 给 MEM 的符号拓展信号
  output        [`MEM_SEL_BUS]       mem_sel_out,          // 给 MEM 的写位置信号
  output        [`DATA_BUS]          mem_write_data_out,   // 给 MEM 的写数据


  input                              reg_write_en_in,      // 给 WB 的写寄存器信号 
  input         [`REG_ADDR_BUS]      reg_write_addr_in,    // 给 WB 的写寄存器地址

  output                             reg_write_en_out,     // 给 WB 的写寄存器信号
  output        [`REG_ADDR_BUS]      reg_write_addr_out,   // 给 WB 的写寄存器地址


  input         [`ADDR_BUS]          current_pc_addr_in,   // 当前指令 PC 值
  output        [`ADDR_BUS]          current_pc_addr_out   // 当前执行指令 PC 值


);

/*
这里传递给 MEM、WB 的信号（mem、reg 开头的信号）以及当前 PC 值并不需
要进行处理，只需将其输入直接连接到输出即可
*/
  assign mem_read_flag_out = mem_read_flag_in;
  assign mem_write_flag_out = mem_write_flag_in;
  assign mem_sign_ext_flag_out = mem_sign_ext_flag_in;
  assign mem_sel_out = mem_sel_in;
  assign mem_write_data_out = mem_write_data_in;

  assign reg_write_en_out = reg_write_en_in;
  assign reg_write_addr_out = reg_write_addr_in;
  
  assign current_pc_addr_out = current_pc_addr_in;


  always @(*) begin
    
    case(funct)
      `FUNCT_ADDU: result <= operand_1 + operand_2;
      `FUNCT_NOP : result <= 0;
      default: result <= 0;
          
    endcase

  end 


endmodule // EX.v