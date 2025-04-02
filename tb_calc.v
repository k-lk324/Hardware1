`timescale 1ns / 1ps

module tb_calc;

    // Inputs
    reg clk = 0;
    reg btnc = 0;
    reg btnl = 0;
    reg btnu = 0;
    reg btnr = 0;
    reg btnd = 0;
    reg [15:0] sw = 0;

    // Outputs
    wire [15:0] led;

    calc uut (
        .clk(clk), 
        .btnc(btnc), 
        .btnl(btnl), 
        .btnu(btnu), 
        .btnr(btnr), 
        .btnd(btnd), 
        .sw(sw), 
        .led(led)
    );

    always #5 clk = ~clk;

    // Task for performing an operation
    task perform_operation;
        input [2:0] buttons;
        input [15:0] switch_value;
        begin
            {btnl, btnc, btnr} = buttons; 
            sw = switch_value;           
            #10;
            btnd = 1;                    
            #10;
            btnd = 0;
            #10;
        end
    endtask


    task display_result;
        input [15:0] expected;
        begin
            if (led !== expected)
                $display("FAIL: Expected 0x%h, Got 0x%h", expected, led);
            else
                $display("PASS: Result 0x%h", led);
        end
    endtask

    initial begin
        // Initialize waveform dump
        $dumpfile("dump.vcd"); 
        $dumpvars(0, tb_calc);

        // Reset the calculator
        btnu = 1;
        #10;
        btnu = 0;

        // Test cases
        $display("Starting Test Cases...");

        // ADD operation
        perform_operation(3'b010, 16'h354a);
        display_result(16'h354a);

        // SUB operation
        perform_operation(3'b011, 16'h1234);
        display_result(16'h2316);

        // OR operation
        perform_operation(3'b001, 16'h1001);
        display_result(16'h3317);

        // AND operation
        perform_operation(3'b000, 16'hf0f0);
        display_result(16'h3010);

        // XOR operation
        perform_operation(3'b111, 16'h1fa2);
        display_result(16'h2fb2);

        // ADD operation again
        perform_operation(3'b010, 16'h6aa2);
        display_result(16'h9a54);

        // Logical Shift Left
        perform_operation(3'b101, 16'h0004);
        display_result(16'ha540);

        // Arithmetic Shift Right
        perform_operation(3'b110, 16'h0001);
        display_result(16'hd2a0);

        // Less Than
        perform_operation(3'b100, 16'h46ff);
        display_result(16'h0001);

        #10;
        $finish;
    end
endmodule
