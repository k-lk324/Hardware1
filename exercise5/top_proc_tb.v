`timescale 1ns / 1ps

module top_proc_tb;

    // Clock and reset signals
    reg clk;
    reg rst;

    // Instruction and data memory signals
    wire [31:0] instr;
    wire [31:0] dReadData;
    wire [31:0] dAddress;
    wire [31:0] dWriteData;
    wire [31:0] PC;

    wire MemRead;
    wire MemWrite;
    wire [31:0] WriteBackData;

    // Clock generation
    initial clk = 0;
    always begin
        #5 clk <= ~clk;  // 10 ns clock period
    end
    // Instantiate top_proc
    top_proc #(.INITIAL_PC(32'h00400000)) uut (
        .clk(clk),
        .rst(rst),
        .instr(instr),
        .dReadData(dReadData),
        .PC(PC),
        .dAddress(dAddress),
        .dWriteData(dWriteData),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .WriteBackData(WriteBackData)
    );

    // Instantiate instruction memory (rom)
    INSTRUCTION_MEMORY rom (
        .clk(clk),
        .addr(PC[8:0]),
        .dout(instr)
    );

    // Instantiate data memory (ram)
    DATA_MEMORY ram (
        .clk(clk),
        .we(MemWrite),
        .addr(dAddress[8:0]),
        .din(dWriteData),
        .dout(dReadData)
    );


    initial begin
        $dumpfile("top_proc_tb.vcd");
        $dumpvars(0, top_proc_tb);

        // Initialize reset
        rst = 1;
        #20;
        rst = 0;

        // Run simulation for a sufficient time to execute all instructions
        #1000;
        $finish;
    end

    initial begin
        $monitor("%b", instr);
    end

endmodule
