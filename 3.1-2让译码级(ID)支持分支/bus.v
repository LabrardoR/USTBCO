`ifndef TINYMIPS_BUS_V_
`define TINYMIPS_BUS_V_

// address bus                 地址总线
`define ADDR_BUS                 31:0
`define ADDR_BUS_WIDTH           32

// instruction bus             指令总线
`define INST_BUS                 31:0
`define INST_BUS_WIDTH           32

// data bus                    数据总线
`define DATA_BUS                 31:0
`define DATA_BUS_WIDTH           32

`define HALF_DATA_BUS            15:0
`define HALF_DATA_BUS_WIDTH      16

// register bus                寄存器总线
`define REG_ADDR_BUS             4:0
`define REG_ADDR_BUS_WIDTH       5

// instruction information bus 指令信息总线
`define INST_OP_BUS              5:0
`define INST_OP_BUS_WIDTH        6
`define FUNCT_BUS                5:0
`define FUNCT_BUS_WIDTH          6
`define SHAMT_BUS                4:0
`define SHAMT_BUS_WIDTH          5

// memory byte selection bus
`define MEM_SEL_BUS              3:0
`define MEM_SEL_BUS_WIDTH        4

`endif // TINYMIPS_BUS_V