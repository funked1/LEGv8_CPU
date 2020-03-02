`timescale 1ns / 1ps

module LEGv8_IF(
    input        clk,
    input        rst,
    input        PCSrc,
    input [63:0] Br_Tar,

    output reg [63:0] PC
    );

    // When reset signal changes, set PC value to 0
    always @(rst)
        begin
            PC <= 63'b0;
        end

    // At the positive edge of the clock signal
    // check PCSrc control;
    // Increment PC if PCSrc = 0
    // Set PC to branch target  if PCSrc = 1
    always @(posedge clk)
        case (PCSrc)
        1'b0:
            begin
                PC <= PC + 4;
            end
        1'b1:
            begin
                PC <= Br_Tar;
            end
        endcase

endmodule
