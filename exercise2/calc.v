`include "alu.v"
`include "calc_enc.v"

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
    reg signed [15:0] accumulator;

    reg signed [31:0] signal_op1,signal_op2;
    wire [31:0] alu_result;
    wire [3:0] alu_op;
    wire zero;

    alu alu_instance (
        .op1(signal_op1),
        .op2(signal_op2),
        .alu_op(alu_op),
        .zero(zero),
        .result(alu_result)
    );

    calc_enc enc_instance (
        .btnc(btnc),
        .btnr(btnr),
        .btnl(btnl),
        .alu_op(alu_op)
    );

    assign signal_op1 = {{16{accumulator[15]}}, accumulator};
    assign signal_op2 = {{16{sw[15]}}, sw};

    always @(posedge clk) begin 
        if (btnu) begin
          accumulator = 16'b0;         // Reset accumulator
        end
        else if (btnd) begin
            accumulator = alu_result[15:0];            
        end
        led = accumulator;
    end
endmodule