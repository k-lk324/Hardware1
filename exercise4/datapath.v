`include "alu.v"
`include "regfile.v"

module datapath #(parameter INITIAL_PC[31:0] = 32'h00400000)(
    input clk,
    input rst, 
    input [31:0] instr,
    input PCSrc, 
    input ALUSrc,
    input RegWrite,
    input MemToReg,
    input [3:0] ALUCtrl,
    input loadPC,
    output [31:0] PC,
    output zero,
    output reg [31:0] dAddress,
    output reg [31:0] dWriteData,
    input [31:0] dReadData,
    output reg [31:0] WriteBackData
);

endmodule