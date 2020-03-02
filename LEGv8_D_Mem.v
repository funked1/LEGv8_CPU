`timescale 1ns / 1ps

module LEGv8_D_Mem(
    input        clk,
    input        rst,
    input [63:0] address,
    input [63:0] WD,
    input        MemRead,
    input        MemWrite,

    output reg [63:0] RD
    );

    // Internal Memory Structure
    reg [7:0] D_Mem [0:255];

    // Place initial data into memory
    initial
        begin
            $readmemb("DataMemory.mem", D_Mem);
        end

    always @(address or MemRead or rst)
        begin
            if (MemRead == 1'b1)
                begin
                    RD[63:56] <= D_Mem[address];
                    RD[55:48] <= D_Mem[address + 3'd1];
                    RD[47:40] <= D_Mem[address + 3'd2];
                    RD[39:32] <= D_Mem[address + 3'd3];
                    RD[31:24] <= D_Mem[address + 3'd4];
                    RD[23:16] <= D_Mem[address + 3'd5];
                    RD[15:8]  <= D_Mem[address + 3'd6];
                    RD[7:0]   <= D_Mem[address + 3'd7];
                end
            end

    always @(posedge clk)
        begin
            if (MemWrite == 1'b1)
                begin
                    D_Mem[address]        <= WD[63:56];
                    D_Mem[address + 3'd1] <= WD[55:48];
                    D_Mem[address + 3'd2] <= WD[47:40];
                    D_Mem[address + 3'd3] <= WD[39:32];
                    D_Mem[address + 3'd4] <= WD[31:24];
                    D_Mem[address + 3'd5] <= WD[23:16];
                    D_Mem[address + 3'd6] <= WD[15:8];
                    D_Mem[address + 3'd7] <= WD[7:0];
                end
        end


endmodule
