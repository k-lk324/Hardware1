`include  "../exercise/alu.v"

module calc (
    input clk,
    input btnc,
    input btnl,
    input btnu,
    input btnr,
    input btnd, 
    input signed [15:0] sw,
    output reg [15:0] led
);
    reg [15:0] accumulator;

    reg signed [31:0] signal_op1,signal_op2;
    wire [31:0] alu_result;
    wire [3:0] alu_op;

    alu alu_instance (
        .op1(signal_op1),
        .op2(signal_op2),
        .alu_op(alu_op),
        .result(alu_result)
    );



    always @(signal btnd or posedge clk  or signal btnu) begin 
    if (btnu) begin
        accumulator=16'b0;
        led=accumulator;
    end
    else if (btnd) begin
        accumulator = alu_result[15:0];
        led=accumulator;
    end
    else
        led=accumulator;       
        
    end

    always @()

    
    
endmodule