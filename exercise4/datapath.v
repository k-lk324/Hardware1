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
    output reg [31:0] PC,
    output Zero,
    output reg [31:0] dAddress,
    output reg [31:0] dWriteData,
    input [31:0] dReadData,
    output reg [31:0] WriteBackData
);

    // RISC-V opcode
    localparam [6:0] LW = 7'b0000011;
    localparam [6:0] SW = 7'b0100011;
    localparam [6:0] BEQ = 7'b1100011;
    localparam [6:0] IMMEDIATE = 7'b0010011;

    wire [31:0] immI;
    wire [31:0] immS;
    wire [31:0] immB;
    wire [31:0] imm;
    wire [31:0] aluResult;

    assign immI = {{20{instr[31]}}, instr[31:20]};
    assign immS = {{20{instr[31]}}, instr[31:25], instr[11:7]};
    assign immB = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};

    // Instruction Decode
    reg [4:0] rs1, rs2, rd;
    reg [6:0] opcode;
    always @(*) begin
        opcode = instr[6:0];
        rs1 = instr[19:15];
        rs2 = instr[24:20];
        rd = instr[11:7];
    end

    reg [31:0] readData1, readData2;
    // Register File
    regfile registers(
        .clk(clk),
        .readReg1(rs1),
        .readReg2(rs2),
        .writeReg(rd),
        .writeData(WriteBackData),
        .write(RegWrite),
        .readData1(readData2),
        .readData2(readData2)
    );

    // ALU
    alu alu(
        .op1(readData1),
        .op2(ALUSrc ? imm : readData2),
        .alu_op(ALUCtrl),
        .result(aluResult),
        .zero(Zero)
    )


    // Immediate Generation
    always @(*) begin
        case(opcode)
            LW: imm = immI;
            SW: imm = immS;
            BEQ: imm = immB;
            IMMEDIATE: imm = immI;
        endcase
    end

    // Program Counter
    always @(posedge clk or posedge rst)
    begin
        if (rst)
            PC <= INITIAL_PC;
        else if (loadPC)
            // branch target
            PC <= PCSrc ? PC + imm : PC + 4;

    end

    // Data Memory
    always @(*) begin
        dAddress = aluResult;
        dWriteData = readData2;

        // Write Back to Registers
        WriteBackData = MemToReg ? dReadData : aluResult;
    end

endmodule