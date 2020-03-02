`timescale 1ns / 1ps

///// LEGv8 OpCodes/////
// STUR: 11111000000
// LDUR: 11111000010
// ADD:  10001011000
// SUB:  11001011000
// AND:  10001010000
// ORR:  10101010000
// CBZ:  10110100
// B:    000101

module LEGv8_SE(
    input        rst,
    input [31:0] inst,

    output reg [63:0] extd
    );

    reg [63:0] temp;

    always @(inst or rst)
        case(inst[31:28])
        // sign-extend 9 bits for loads and stores
        4'b1111:
            begin
                temp = inst[20:12];
                if (inst[20] == 1)
                    extd <= (64'hFFFFFFFFFFFFFE00) | temp;
                else
                    extd <= (64'h00000000000001FF) & temp;
            end

        // sign-extend 19 bits for CBZ
        4'b1011:
            begin
                temp = inst[23:5];
                if (inst[23] == 1)
                    extd <= (64'hFFFFFFFFFFFC0000) | temp;
                else
                    extd <= (64'h000000000003FFFF) & temp;
            end

        // sign-extend 26 bits for B
        4'b0001:
            begin
                temp = inst[25:0];
                if (inst[25] == 1)
                    extd <= (64'hFFFFFFFFFC000000) | temp;
                else
                    extd <= (64'h0000000003FFFFFF) & temp;
            end
        endcase
endmodule
