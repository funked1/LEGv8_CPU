`timescale 1ns / 1ps

module LEGv8_MEM(
    input rst,
    input UBranch,
    input Branch,
    input is_zero,

    output reg PCSrc
    );

    reg CBZ;

    always @(rst)
        begin
            PCSrc <= 1'b0;
        end
        
    always @(Branch or is_zero)
        begin
            CBZ <= Branch & is_zero;
        end

    always @(UBranch or CBZ)
        begin
            PCSrc <= UBranch | CBZ;
        end

endmodule
