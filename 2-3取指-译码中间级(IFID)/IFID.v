`timescale 1ns/1ps

`include "bus.v"
// 接受 PC 级输出的地址与指令作为输入，
// 然后在上升沿时锁存模块的输入到输出
module IFID(
  input                     clk,
  input                     rst,
  input                     stall_current_stage,     // 暂停当前阶段信号
  input                     stall_next_stage,        // 暂停下一阶段信号
  input        [`ADDR_BUS]  addr_in,                 // 地址输入
  input        [`INST_BUS]  inst_in,                 // 指令输入
  output       [`ADDR_BUS]  addr_out,                // 地址输出
  output       [`INST_BUS]  inst_out                 // 指令输出
);

  PipelineDeliver #(`ADDR_BUS_WIDTH) ff_addr(
    clk,rst,
    stall_current_stage, stall_next_stage,
    addr_in, addr_out
  );

  PipelineDeliver #(`INST_BUS_WIDTH) ff_inst(
    clk, rst,
    stall_current_stage, stall_next_stage,
    inst_in, inst_out
  );


endmodule