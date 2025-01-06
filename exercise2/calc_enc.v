module calc_enc (
    input btnc,
    input btnr,
    input btnl,
    output [3:0] alu_op
);

    wire a00, a01, 
    wire n0;

    wire a10, a11;
    wire n10, n11;

    wire a20, a21, a22;
    wire n20, n21;

    wire a30, a31, a32, a33;
    wire n30, n31;

    // alu_op[0]
    not (n0, btnc);
    and (a00, btnr, n0);
    and (a01, btnl, btnr);
    or (alu_op[0], a00, a01);

    // alu_op[1]
    not (n10, btnl);
    and (a10, n10, btnc);
    not (n11, btnr);
    and (a11, n11, btnc);
    or (alu_op[1], a10, a11);

    // alu_op[2]
    and (a20, btnc, btnr);
    not (n20, btnc);
    not (n21, btnr);
    and (a21, n20, btnl);
    and (a22, a21, n21);
    or (alu_op[2], a21, a22);

    // alu_op[3]
    not (n30, btnc);
    and (a30, n30, btnl);
    and (a31, btnl, btnc);
    not (n31, btnr);
    and (a32, a30, btnr);
    and (a33, a31, n31);

endmodule