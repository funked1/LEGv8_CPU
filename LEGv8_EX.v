`timescale 1ns / 1ps

module LEGv8_EX(
    input [63:0] RD1,
    input [63:0] RD2,
    input [63:0] PC,
    input [63:0] SE,
    input [10:0] op_code,
    input [1:0]  ALUop,
    input        ALUSrc,

    output reg  [63:0] Br_Tar,
    output wire        is_zero,
    output wire [63:0] ALU_result
    );

    // Internal Connections and registers
    reg  [63:0] src_2;
    reg  [63:0] shift;
    wire [3:0]  ALU_ctrl;

    // Internal module declarations
    LEGv8_ALC ALC_mod(op_code, ALUop, ALU_ctrl);
    LEGv8_ALU ALU_mod(ALU_ctrl, RD1, src_2, is_zero, ALU_result);

    always @(*)
        begin
            case(ALUSrc)
                1'b0: src_2 <= RD2;
                1'b1: src_2 <= SE;
            endcase
        end

    always @(SE)
        begin
            shift <= SE << 2;
        end

    always @(*)
        begin
            Br_Tar <= PC + shift;
        end

endmodule
