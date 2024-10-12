`timescale 1ns/1ps

`include "bus.v"


// DATA_BUS 31:0   REG_ADDR_BUS 4:0
module RegFile(
  input                        clk,
  input                        rst,

  input                        read_en_1,      // 读使能信号 1
  input       [`REG_ADDR_BUS]  read_addr_1,    // 读寄存器地址 1
  output  reg [`DATA_BUS]      read_data_1,    // 读出数据 1

  input                        read_en_2,      // 读使能信号 2
  input       [`REG_ADDR_BUS]  read_addr_2,    // 读寄存器地址 2
  output  reg [`DATA_BUS]      read_data_2,    // 读出数据 2

  input                        write_en,       // 写使能信号
  input       [`REG_ADDR_BUS]  write_addr,     // 写寄存器地址
  input       [`DATA_BUS]      write_data      // 写入数据
);

// 两个读端口，一个写端口，读异步，写同步
  
  reg[`DATA_BUS] registers[0:31]; // 寄存器堆内有32个通用寄存器
  integer i;

  // 写:写入寄存器
  always @(posedge clk) begin
    if (rst) begin
      for (i = 0; i < 32; i = i + 1) begin
        registers[i] <= 0;
      end
    end
    else if (write_en && (|write_addr)) begin // 保证禁止写入0号寄存器
      registers[write_addr] <= write_data;
    end
  end

  // 读:从寄存器读取数据
  // 
  always @(*) begin
    if(rst) begin
      read_data_1 <= 0;
    end
    else if (write_addr == read_addr_2 && write_en && read_en_1) begin // 读和写在同一个寄存器上 
      read_data_1 <= write_data;   // 直接读取要写入的数据
    end
    else if (read_en_1) begin
      read_data_1 <= registers[read_addr_1];
    end
    else begin
      read_data_1 <= 0;
    end
  end

  // 同上
  always @(*) begin
    if(rst) begin
      read_data_2 <= 0;
    end
    else if(write_addr == read_addr_2 && write_en && read_en_2) begin
      read_data_2 <= write_data;
    end
    else if(read_en_2) begin
      read_data_2 <= registers[read_addr_2];
    end
    else begin
      read_data_2 <= 0;
    end
  end

endmodule  // RegFile