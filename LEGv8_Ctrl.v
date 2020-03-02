`timescale 1ns / 1ps

// LDUR, STUR, ADD, SUB, AND, ORR, CBZ, B

module LEGv8_Ctrl(
    input        rst,
    input [10:0] Inst,

    output reg        UBranch,
    output reg        Branch,
    output reg        MemRead,
    output reg        MemtoReg,
    output reg [1:0]  ALUop,
    output reg        MemWrite,
    output reg        ALUSrc,
    output reg        RegWrite
    );

    always @(Inst or rst)
        begin
            if(Inst == 11'd1986)                // LDUR
                begin
                    UBranch     <= 1'b0;
                    Branch      <= 1'b0;
                    MemRead     <= 1'b1;
                    MemtoReg    <= 1'b1;
                    ALUop       <= 2'b00;
                    MemWrite    <= 1'b0;
                    ALUSrc      <= 1'b1;
                    RegWrite    <= 1'b1;
                end
            else if (Inst == 11'd1984)          // STUR
                begin
                    UBranch     <= 1'b0;
                    Branch      <= 1'b0;
                    MemRead     <= 1'b0;
                    MemtoReg    <= 1'bx;
                    ALUop       <= 2'b00;
                    MemWrite    <= 1'b1;
                    ALUSrc      <= 1'b1;
                    RegWrite    <= 1'b0;
                end
            else if (Inst[10:3] == 8'd180)      // CBZ
                begin
                    UBranch     <= 1'b0;
                    Branch      <= 1'b1;
                    MemRead     <= 1'b0;
                    MemtoReg    <= 1'bx;
                    ALUop       <= 2'b01;
                    MemWrite    <= 1'b0;
                    ALUSrc      <= 1'b0;
                    RegWrite    <= 1'b0;
                end
            else if (Inst[10:5] == 6'd5)        // B
                begin
                    UBranch     <= 1'b1;
                    Branch      <= 1'bx;
                    MemRead     <= 1'bx;
                    MemtoReg    <= 1'bx;
                    ALUop       <= 2'bxx;
                    MemWrite    <= 1'bx;
                    ALUSrc      <= 1'bx;
                    RegWrite    <= 1'bx;
                end
            else
                begin                           // R-type
                    UBranch     <= 1'b0;
                    Branch      <= 1'b0;
                    MemRead     <= 1'b0;
                    MemtoReg    <= 1'b0;
                    ALUop       <= 2'b10;
                    MemWrite    <= 1'b0;
                    ALUSrc      <= 1'b0;
                    RegWrite    <= 1'b1;
                end
        end

endmodule
