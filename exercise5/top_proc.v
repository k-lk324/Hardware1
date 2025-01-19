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
//change
    reg PCSrc;
    reg ALUSrc;
    reg RegWrite;
    reg MemToReg;
    reg loadPC;
    reg [3:0] ALUCtrl;

    datapath datapath(
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



    // FSM
    reg [2:0] state;
    localparam [2:0] IF = 3'b000;
    localparam [2:0] ID = 3'b001;
    localparam [2:0] EX = 3'b010;
    localparam [2:0] MEM = 3'b011;
    localparam [2:0] WB = 3'b100;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IF;
        end else begin
            case (state)
                IF: begin
                    // Instruction Fetch
                end
                ID: begin
                    // Instruction Decode
                end
                EX: begin
                    // Execute
                end
                MEM: begin
                    // Memory Access
                end
                WB: begin
                    // Write Back

                    
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


endmodule