`timescale 1ns / 1ps

module LEGv8_RegFile(
    input        clk,
    input        rst,
    input        RegWrite,
    input [4:0]  RR1,
    input [4:0]  RR2,
    input [4:0]  WR,
    input [63:0] WD,

    output reg [63:0] RD1,
    output reg [63:0] RD2
    );

    // Declaration of Registers
    reg [63:0] RegFile [31:0];

    always @(rst)
        begin
            RegFile[31] <= 64'h0000000000000000;
        end
        

    // Update output when RR signals change
    always @(RR1 or RR2)
        begin
            RD1 <= RegFile[RR1];
            RD2 <= RegFile[RR2];
        end

    // Check RegWrite at positive edge of clock
    // Write to WR register if RegWrite is asserted
    always @(posedge clk)
        begin
            if(RegWrite == 1'b1)
                begin
                    RegFile[WR] <= WD;
                end
        end

endmodule
