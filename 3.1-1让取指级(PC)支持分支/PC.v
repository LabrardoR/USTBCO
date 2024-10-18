`timescale 1ns / 1ps

`include "bus.v"
`include "pcdef.v"

// IF 取指 : 更新指令地址，并将指令地址传输给 ROM
module PC(
  input                     clk,
  input                     rst,
  input                     stall_pc,       // 用于暂停 PC
  input                     branch_flag,    // 分支跳转信号
  input      [`ADDR_BUS]    branch_addr,    // 分支跳转地址

  output reg [`ADDR_BUS]    pc,             // 当前指令的 PC 值

  output reg                rom_en,         // ROM 使能
  output     [`MEM_SEL_BUS] rom_write_en,   // ROM 写使能
  output     [`ADDR_BUS]    rom_addr,       // ROM 地址信号
  output     [`DATA_BUS]    rom_write_data  // ROM 写数据      
);

  reg [`ADDR_BUS] next_pc;

  assign rom_write_en = 0;                  // 不进行写操作
  assign rom_write_data = 0;                // 不进行写操作
  assign rom_addr = next_pc;                // ROM 地址为 next_pc

  always @(posedge clk) begin
    if(rst) begin
      rom_en <= 0;
    end
    else begin
      rom_en <= 1;
    end
  end

  // 复位和 ROM 使能控制
  always @(posedge clk) begin
    if(!rom_en) begin
      pc <= `INIT_PC - 4;    // why               // 初始地址设为 INIT_PC - 4
    end
    else begin
      pc <= next_pc;
    end
  end
  
  always @(*) begin
    if(!stall_pc) begin             // pc 不暂停
      if(branch_flag) begin         
        next_pc <= branch_addr;     // 分支跳转
      end
      else begin
        next_pc <= pc + 4;          // 不跳转，继续 + 4
      end
    end
    else begin
      next_pc <= pc;                // 暂停
    end
  end


endmodule // PC



