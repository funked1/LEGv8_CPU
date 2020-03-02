`timescale 1ns / 1ps

module LEGv8_Cache_Set(
    input        rst,
    input [4:0]  Index,
    input [56:0] In_Tag,
    input        Write,

    output reg hit_status
    );

    // Internal variables
    reg valid;
    reg [56:0] tag;

    // Cache Memory; 16 lines of 58 bits
    // (Block contents excluded for simulation)
    reg [57:0] C_Mem[0:15];

    always @(*)
        begin
            valid = C_Mem[Index][57];
            tag = C_Mem[Index][56:0];
            case(valid)
            1'bx:
                hit_status <= 1'b0;
            1'b0:
                hit_status <= 1'b0;
            1'b1:
                begin
                    if (tag == In_Tag)
                        hit_status <= 1'b1;
                    else
                        hit_status <= 1'b0;
                end
            endcase

            if (Write === 1'b1)
                begin
                    C_Mem[Index][57] = 1'b1;
                    C_Mem[Index][56:0] = In_Tag;
                end
        end

endmodule
