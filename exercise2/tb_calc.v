`timescale 1ns / 1ps
module tb_calc


    // Inputs
    reg [3:0] switches;       // Switch inputs
    reg [15:0] prev_value;    // Previous value (accumulator)
    reg btnl, btnc, btnr;     // Button inputs

    // Output
    wire [15:0] result;       // ALU result output

    // Instantiate the Unit Under Test (UUT)
    alu uut (
        .switches(switches),
        .prev_value(prev_value),
        .btnl(btnl),
        .btnc(btnc),
        .btnr(btnr),
        .result(result)
    );

    // Test procedure
    initial begin
        // Reset signal
        btnl = 0; btnc = 1; btnr = 0; // Reset condition
        prev_value = 16'hxxxx;        // Undefined previous value
        switches = 16'hxxxx;         // Undefined switches
        #10;                         // Wait for reset
        if (result != 16'h0000) $display("Test Failed: Reset");
        
        // Test Case 1: ADD
        btnl = 0; btnc = 1; btnr = 0; // ADD operation
        prev_value = 16'h0000;
        switches = 16'h354a;
        #10;
        if (result != 16'h354a) $display("Test Failed: ADD");

        // Test Case 2: SUB
        btnl = 0; btnc = 1; btnr = 1; // SUB operation
        prev_value = 16'h354a;
        switches = 16'h1234;
        #10;
        if (result != 16'h2316) $display("Test Failed: SUB");

        // Test Case 3: OR
        btnl = 0; btnc = 0; btnr = 1; // OR operation
        prev_value = 16'h2316;
        switches = 16'h1001;
        #10;
        if (result != 16'h3317) $display("Test Failed: OR");

        // Test Case 4: AND
        btnl = 0; btnc = 0; btnr = 0; // AND operation
        prev_value = 16'h3317;
        switches = 16'h0f0f;
        #10;
        if (result != 16'h3010) $display("Test Failed: AND");

        // Test Case 5: XOR
        btnl = 1; btnc = 1; btnr = 1; // XOR operation
        prev_value = 16'h3010;
        switches = 16'h1fa2;
        #10;
        if (result != 16'h2fb2) $display("Test Failed: XOR");

        // Test Case 6: ADD
        btnl = 0; btnc = 1; btnr = 0; // ADD operation
        prev_value = 16'h2fb2;
        switches = 16'h6aa2;
        #10;
        if (result != 16'h9a54) $display("Test Failed: ADD");

        // Test Case 7: Logical Shift Left
        btnl = 0; btnc = 1; btnr = 1; // Logical Shift Left operation
        prev_value = 16'h9a54;
        switches = 16'h0004;
        #10;
        if (result != 16'h0540) $display("Test Failed: Logical Shift Left");

        // Test Case 8: Shift Right Arithmetic
        btnl = 0; btnc = 0; btnr = 0; // Shift Right Arithmetic operation
        prev_value = 16'h0540;
        switches = 16'h0001;
        #10;
        if (result != 16'h02a0) $display("Test Failed: Shift Right Arithmetic");

        // Test Case 9: Less Than
        btnl = 1; btnc = 0; btnr = 0; // Less Than operation
        prev_value = 16'h02a0;
        switches = 16'h46ff;
        #10;
        if (result != 16'h0001) $display("Test Failed: Less Than");

        // End of test
        $display("All Tests Completed");
        $finish;
    end



endmodule