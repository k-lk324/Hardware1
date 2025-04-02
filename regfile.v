module regfile #(parameter DATAWIDTH = 32)(
    input clk,
    input [4:0] readReg1,
    input [4:0] readReg2,
    input [4:0] writeReg,
    input [DATAWIDTH-1:0] writeData,
    input write,
    output reg [DATAWIDTH-1:0] readData1,
    output reg [DATAWIDTH-1:0] readData2
);

    reg [DATAWIDTH-1:0] regtable [31:0];
    integer i;

    // Initialize the registers to zero
    initial 
    begin
        for (i = 0; i < DATAWIDTH; i = i + 1) begin
            regtable[i] = 0;
        end
    end

    always @(posedge clk) begin
        if (write) begin
            regtable[writeReg] <= writeData;
        end

        readData1 <= regtable[readReg1];
        readData2 <= regtable[readReg2];

        // Give priority to the written data
        if (write && writeReg == readReg1) 
        begin
            readData1 <= writeData;
        end
        if (write && writeReg == readReg2) 
        begin
            readData2 <= writeData;
        end
    end

endmodule