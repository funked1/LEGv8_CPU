`timescale 1ns / 1ps

module LEGv8_ALC(
    input [10:0] op_code,
    input [1:0]  ALUOp,

    output reg [3:0] ALU_ctrl
    );

    always @(*)
        begin
            case(ALUOp)
            2'b00:
                ALU_ctrl <= 4'b0010;
            2'b01:
                ALU_ctrl <= 4'b0111;
            2'b10:
                // ADD
                if (op_code == 11'b10001011000)
                    ALU_ctrl <= 4'b0010;
                //SUB
                else if (op_code == 11'b11001011000)
                    ALU_ctrl <= 4'b0110;
                // AND
                else if (op_code == 11'b10001010000)
                    ALU_ctrl <= 4'b0000;
                // ORR
                else if (op_code == 11'b10101010000)
                    ALU_ctrl <= 4'b0001;
            endcase
        end

endmodule
