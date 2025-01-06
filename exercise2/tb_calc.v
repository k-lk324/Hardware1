`timescale 1ns / 1ps

module tb_calc;

    // Inputs for calc
    reg clk;
    reg btnc, btnl, btnu, btnr, btnd;
    reg signed [15:0] sw;

    // Output from calc
    wire [15:0] led;

    // Instantiate calc module
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

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize inputs
        clk = 0;
        btnc = 0; btnl = 0; btnu = 0; btnr = 0; btnd = 0;
        sw = 16'h0000;

        // Reset test
        btnu = 1; // Simulate reset
        #10;
        btnu = 0; // Release reset
        if (led != 16'h0000) $display("Test Failed: Reset");

        // Test Case 1: ADD
        sw = 16'h354a;       // Set switches to 0x354a
        btnc = 1; btnl = 0; btnr = 0; // ADD operation
        #10;
        btnc = 0;
        if (led != 16'h354a) $display("Test Failed: ADD");

        // Test Case 2: SUB
        sw = 16'h1234;       // Set switches to 0x1234
        btnc = 1; btnl = 0; btnr = 1; // SUB operation
        #10;
        btnc = 0;
        if (led != 16'h2316) $display("Test Failed: SUB");

        // Test Case 3: OR
        sw = 16'h1001;       // Set switches to 0x1001
        btnc = 0; btnl = 0; btnr = 1; // OR operation
        #10;
        if (led != 16'h3317) $display("Test Failed: OR");

        // Test Case 4: AND
        sw = 16'h0f0f;       // Set switches to 0x0f0f
        btnc = 0; btnl = 0; btnr = 0; // AND operation
        #10;
        if (led != 16'h3010) $display("Test Failed: AND");

        // Test Case 5: XOR
        sw = 16'h1fa2;       // Set switches to 0x1fa2
        btnc = 1; btnl = 1; btnr = 1; // XOR operation
        #10;
        btnc = 0;
        if (led != 16'h2fb2) $display("Test Failed: XOR");

        // Test Case 6: ADD
        sw = 16'h6aa2;       // Set switches to 0x6aa2
        btnc = 1; btnl = 0; btnr = 0; // ADD operation
        #10;
        btnc = 0;
        if (led != 16'h9a54) $display("Test Failed: ADD");

        // Test Case 7: Logical Shift Left
        sw = 16'h0004;       // Set switches to 0x0004
        btnc = 0; btnl = 1; btnr = 1; // Logical Shift Left operation
        #10;
        if (led != 16'h0540) $display("Test Failed: Logical Shift Left");

        // Test Case 8: Shift Right Arithmetic
        sw = 16'h0001;       // Set switches to 0x0001
        btnc = 0; btnl = 0; btnr = 0; // Shift Right Arithmetic operation
        #10;
        if (led != 16'h02a0) $display("Test Failed: Shift Right Arithmetic");

        // Test Case 9: Less Than
        sw = 16'h46ff;       // Set switches to 0x46ff
        btnc = 1; btnl = 0; btnr = 0; // Less Than operation
        #10;
        btnc = 0;
        if (led != 16'h0001) $display("Test Failed: Less Than");

        // End of test
        $display("All Tests Completed");
        $finish;
    end

endmodule
