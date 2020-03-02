`timescale 1ns / 1ps

`define AND 4'b0000
`define OR  4'b0001
`define ADD 4'b0010
`define SUB 4'b0110
`define PIB 4'b0111
`define NOR 4'b1100

module LEGv8_ALU(
    input [3:0]  ALU_ctrl,
    input [63:0] src_1,
    input [63:0] src_2,

    output reg        zero,
    output reg [63:0] ALU_result
    );

    always @(*)
        case(ALU_ctrl)
            `AND: ALU_result <= src_1 & src_2;
            `OR:  ALU_result <= src_1 | src_2;
            `ADD: ALU_result <= src_1 + src_2;
            `SUB: ALU_result <= src_1 - src_2;
            `PIB: ALU_result <= src_2;
            `NOR: ALU_result <= !(src_1 | src_2);
        endcase

    always @(ALU_result)
        if (ALU_result == 0)
            zero <= 1'b1;
        else
            zero <= 1'b0;

endmodule
