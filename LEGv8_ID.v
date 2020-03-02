`timescale 1ns / 1ps

module LEGv8_ID(
    input        clk,
    input        rst,
    input [31:0] inst,
    input [4:0]  WR,
    input [63:0] WD,
    input        RegWrite,

    output wire [63:0] RD1,
    output wire [63:0] RD2,
    output wire [63:0] SE,
    output wire        UBranch,
    output wire        Branch,
    output wire        MemRead,
    output wire        MemtoReg,
    output wire [1:0]  ALUop,
    output wire        MemWrite,
    output wire        ALUSrc,
    output wire        RegWrite_c
    );

    // Internal variable declaration
    reg Reg2Loc;
    reg [10:0] opcode;
    reg [4:0]  RR1;
    reg [4:0]  RR2;

    // Internal module declaration
    LEGv8_RegFile RF_mod(clk, rst, RegWrite, RR1, RR2, WR, WD, RD1, RD2);
    LEGv8_SE      SE_mod(rst, inst, SE);
    LEGv8_Ctrl    CT_mod(rst, opcode, UBranch, Branch, MemRead, MemtoReg,
                         ALUop, MemWrite, ALUSrc, RegWrite_c);

    always @(inst or rst)
        begin
            Reg2Loc = inst[28];
            opcode  <= inst[31:21];
            RR1     <= inst[9:5];
            case(Reg2Loc)
            1'b0:
                begin
                    RR2 <= inst[20:16];
                end
            1'b1:
                begin
                    RR2 <= inst[4:0];
                end
            endcase
        end

endmodule
