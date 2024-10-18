`timescale 1ns/1ps

`include "bus.v"

module RegReadProxy(
  input                         clk,
  input                         rst,
  // input from ID stage
  input                         read_en_1,
  input                         read_en_2,
  input        [`REG_ADDR_BUS]  read_addr_1,
  input        [`REG_ADDR_BUS]  read_addr_2,
  // input from regfile
  input        [`DATA_BUS]      data_1_from_reg,
  input        [`DATA_BUS]      data_2_from_reg,
  // input from EX stage (solve data hazards)
  input                         ex_load_flag,
  input                         reg_write_en_from_ex,
  input        [`REG_ADDR_BUS]  reg_write_addr_from_ex, 
  input        [`DATA_BUS]      data_from_ex,
  // input from MEM stage (solve data hazards)
  input                         mem_load_flag,
  input                         reg_write_en_from_mem,
  input        [`REG_ADDR_BUS]  reg_write_addr_from_mem,
  input        [`DATA_BUS]      data_from_mem,
  // load related signals
  output                        load_related_1,
  output                        load_related_2, 
  // reg data output (WB stage)
  output  reg  [`DATA_BUS]      read_data_1,
  output  reg  [`DATA_BUS]      read_data_2
);

/*
如果模块发现 ID 正在读取的数据正好是 EX 或是 MEM 模块要写入的，
那么就要将输出设为 EX 或 MEM 级的写入数据；
反之直接输出 RegFile 中读取的数据。
*/

  always @(*) begin
    if(read_en_1) begin
      if (reg_write_en_from_ex && reg_write_addr_from_ex == read_addr_1) begin
        read_data_1 <= data_from_ex;
      end
      else if (reg_write_en_from_mem
      && reg_write_addr_from_mem == read_addr_1) begin
        read_data_1 <= data_from_mem;
      end
      else begin
        read_data_1 <= data_1_from_reg;
      end
    end
    else begin
      read_data_1 <= 0;
    end
  end

  always @(*) begin
    if(read_en_2) begin
      if (reg_write_en_from_ex && reg_write_addr_from_ex == read_addr_2) begin
        read_data_2 <= data_from_ex;
      end
      else if (reg_write_en_from_mem && reg_write_addr_from_mem == read_addr_2) begin
        read_data_2 <= data_from_mem;
      end
      else begin
        read_data_2 <= data_2_from_reg;
      end
    end
    else begin
      read_data_2 <= 0;
    end
  end

endmodule