`timescale 1ns / 1ps

// num lines == 16
// num sets == 4

module LEGv8_Cache_Mem(
    input        rst,
    input [4:0]  Index,
    input [56:0] Tag,
    input        Write0,
    input        Write1,
    input        Write2,
    input        Write3,

    output reg   hit_status
    );

    // Internal Connections
    wire hit_0;
    wire hit_1;
    wire hit_2;
    wire hit_3;

    // Module Declaration
    LEGv8_Cache_Set S0(rst, Index, Tag, Write0, hit_0);
    LEGv8_Cache_Set S1(rst, Index, Tag, Write1, hit_1);
    LEGv8_Cache_Set S2(rst, Index, Tag, Write2, hit_2);
    LEGv8_Cache_Set S3(rst, Index, Tag, Write3, hit_3);

    always @(*)
        begin
            hit_status <= (hit_0 || hit_1 || hit_2 || hit_3);
        end

endmodule
