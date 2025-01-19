`include "datapath.v"

module top_proc #(parameter INITIAL_PC[31:0] = 32'h00400000)(
    input clk,
    input rst,
    input [31:0] instr,
    input [31:0] dReadData,
    output reg [31:0] PC,
    output reg [31:0] dAddress,
    output reg [31:0] dWriteData,
    output MemRead,
    output MemWrite,
    output reg [31:0] WriteBackData
);

    wire Zero;
    wire [6:0] opcode;
    wire [2:0] funct3; 
    wire [6:0] funct7;

    reg PCSrc;
    reg ALUSrc;
    reg RegWrite;
    reg MemToReg;
    reg loadPC;
    reg [3:0] ALUCtrl;

    datapath #(.INITIAL_PC(INITIAL_PC))datapath(
        .clk(clk),
        .rst(rst),
        .instr(instr),
        .PCSrc(PCSrc),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .MemToReg(MemToReg),
        .ALUCtrl(ALUCtrl),
        .loadPC(loadPC),
        .PC(PC),
        .Zero(Zero),
        .dAddress(dAddress),
        .dWriteData(dWriteData),
        .dReadData(dReadData),
        .WriteBackData(WriteBackData)


    );

    // RISC-V opcode
    assign opcode = instr[6:0];
    localparam [6:0] LW = 7'b0000011;
    localparam [6:0] SW = 7'b0100011;
    localparam [6:0] BEQ = 7'b1100011;
    localparam [6:0] IMMEDIATE = 7'b0010011;
    localparam [6:0] NON_IMMEDIATE = 7'b0110011;

    // RISC-V funct3
    // immediate
    assign funct3 = instr[14:12];
    localparam [2:0] FUNCT3_ADDI = 3'b000;
    localparam [2:0] FUNCT3_SLTI = 3'b010;
    localparam [2:0] FUNCT3_XORI = 3'b100;
    localparam [2:0] FUNCT3_ORI = 3'b110;
    localparam [2:0] FUNCT3_ANDI = 3'b111;
    localparam [2:0] FUNCT3_SLLI = 3'b001;
    localparam [2:0] FUNCT3_SRLI = 3'b101;
    localparam [2:0] FUNCT3_SRAI = 3'b101;

    // non-immediate
    localparam [2:0] FUNCT3_ADD = 3'b000;
    localparam [2:0] FUNCT3_SUB = 3'b000;
    localparam [2:0] FUNCT3_SLL = 3'b001;
    localparam [2:0] FUNCT3_SLT = 3'b010;
    localparam [2:0] FUNCT3_XOR = 3'b100;
    localparam [2:0] FUNCT3_SRL = 3'b101;
    localparam [2:0] FUNCT3_SRA = 3'b101;
    localparam [2:0] FUNCT3_OR = 3'b110;
    localparam [2:0] FUNCT3_AND = 3'b111;

    // RISC-V funct7
    assign funct7 = instr[31:25];
    localparam [6:0] FUNCT7_SRLI = 7'b0000000;
    localparam [6:0] FUNCT7_SRAI = 7'b0100000;

    localparam [6:0] FUNCT7_ADD = 7'b0000000;
    localparam [6:0] FUNCT7_SUB = 7'b0100000;

    localparam [6:0] FUNCT7_SRL = 7'b0000000;
    localparam [6:0] FUNCT7_SRA = 7'b0100000;






    // FSM states
    reg [2:0] state;
    localparam [2:0] IF = 3'b000;
    localparam [2:0] ID = 3'b001;
    localparam [2:0] EX = 3'b010;
    localparam [2:0] MEM = 3'b011;
    localparam [2:0] WB = 3'b100;

    // FSM state logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IF;
        end else begin
            case (state)
                IF: begin
                    // Instruction Fetch
                    loadPC   <= 0;
                    MemRead  <= 0;
                    MemWrite <= 0;
                    RegWrite <= 0;
                    MemToReg <= 0;

                end
                ID: // Instruction Decode
                EX: // Execute
                MEM: begin
                    // Memory Access
                    if (opcode == LW)
                        MemRead  <= 1;
                    else if (opcode == SW)
                        MemWrite <= 1;
                end
                WB: begin
                    // Write Back
                    loadPC <= 1;
                    if (opcode == LW)
                        MemToReg <= 1;
                    if (opcode != SW && opcode != BEQ)
                        RegWrite <= 1;
                    
                end
            endcase

            // State transition
            case (state)
                IF: state <= ID;
                ID: state <= EX;
                EX: state <= MEM;
                MEM: state <= WB;
                WB: state <= IF;
            endcase
        end
    end

    // ALUSrc
    always @(*) begin
        case (opcode)
            LW: begin
                ALUSrc = 1;
            end
            SW: begin
                ALUSrc = 1;
            end
            BEQ: begin
                ALUSrc = 0;
            end
            IMMEDIATE: begin
                ALUSrc = 1;
            end
            default: begin
                ALUSrc = 0;
            end
        endcase
    end

    // ALUCtrl
    always @(*) begin
        case (opcode)
            BEQ: begin
                ALUCtrl = 4'b0110;
            end
            IMMEDIATE: begin
                ALUCtrl = 4'b0010;
            end
            default: begin
                ALUCtrl = 4'b0000;
            end
        endcase
    end


endmodule