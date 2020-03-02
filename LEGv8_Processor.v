`timescale 1ns / 1ps

module LEGv8_Processor(
    input        clk,
    input        rst,
    input [31:0] inst,
    input [63:0] RD_DM,

    output wire [63:0] PC,
    output reg [63:0] address_DM,
    output reg [63:0] WD_DM,
    output reg        MemRead_DM,
    output reg        MemWrite_DM
    );

    ///// Pipeline Registers ///////
    reg [63:0] IF_PC;
    reg [31:0] IF_inst;

    reg [63:0] ID_RD1;
    reg [63:0] ID_RD2;
    reg [63:0] ID_PC;
    reg [63:0] ID_SE;
    reg        ID_UBranch;
    reg        ID_Branch;
    reg        ID_MemRead;
    reg        ID_MemtoReg;
    reg [1:0]  ID_ALUop;
    reg        ID_MemWrite;
    reg        ID_ALUSrc;
    reg        ID_RegWrite;
    reg [10:0] ID_op_code;
    reg [4:0]  ID_WR;

    reg [63:0] EX_Br_Tar;
    reg        EX_is_zero;
    reg [63:0] EX_ALU_result;
    reg        EX_UBranch;
    reg        EX_Branch;
    reg        EX_MemRead;
    reg        EX_MemtoReg;
    reg        EX_MemWrite;
    reg        EX_RegWrite;
    reg [63:0] EX_WD;
    reg [4:0]  EX_WR;

    reg [63:0] WB_RD_DM;
    reg [63:0] WB_ALU_result;
    reg [4:0]  WB_WR;
    reg        WB_MemtoReg;
    reg        WB_RegWrite;

    ///// Internal Connections /////
    wire        PCSrc;
    wire [63:0] RD1;
    wire [63:0] RD2;
    wire [63:0] SE;
    wire        UBranch;
    wire        Branch;
    wire        MemRead;
    wire        MemtoReg;
    wire [1:0]  ALUop;
    wire        MemWrite;
    wire        ALUSrc;
    wire        RegWrite;
    wire [63:0] Br_Tar;
    wire        is_zero;
    wire [63:0] ALU_result;

    reg [63:0] WriteData;


    ///// Module Declaration ///////
    LEGv8_IF  M0(clk, rst, PCSrc, EX_Br_Tar, PC);
    LEGv8_ID  M1(clk, rst, IF_inst, WB_WR, WriteData,
                 WB_RegWrite, RD1, RD2, SE, UBranch, Branch,
                 MemRead, MemtoReg, ALUop, MemWrite,
                 ALUSrc, RegWrite);
    LEGv8_EX  M2(ID_RD1, ID_RD2, ID_PC, ID_SE, ID_op_code,
                 ID_ALUop, ID_ALUSrc, Br_Tar, is_zero,
                 ALU_result);
    LEGv8_MEM M3(rst, EX_UBranch, EX_Branch, EX_is_zero, PCSrc);

    always @(posedge clk)
        begin
            IF_PC <= PC;
            IF_inst <= inst;

            ID_RD1 <= RD1;
            ID_RD2 <= RD2;
            ID_PC <= IF_PC;
            ID_SE <= SE;
            ID_UBranch <= UBranch;
            ID_Branch <= Branch;
            ID_MemRead <= MemRead;
            ID_MemtoReg <= MemtoReg;
            ID_ALUop <= ALUop;
            ID_MemWrite <= MemWrite;
            ID_ALUSrc <= ALUSrc;
            ID_RegWrite <= RegWrite;
            ID_op_code <= IF_inst[31:21];
            ID_WR <= IF_inst[4:0];

            EX_Br_Tar <= Br_Tar;
            EX_is_zero <= is_zero;
            EX_ALU_result <= ALU_result;
            EX_WD <= ID_RD2;
            EX_WR <= ID_WR;
            EX_UBranch <= ID_UBranch;
            EX_Branch <= ID_Branch;
            EX_MemRead <= ID_MemRead;
            EX_MemtoReg <= ID_MemtoReg;
            EX_MemWrite <= ID_MemWrite;
            EX_RegWrite <= ID_RegWrite;

            WB_RD_DM <= RD_DM;
            WB_ALU_result <= EX_ALU_result;
            WB_WR <= EX_WR;
            WB_MemtoReg <= EX_MemtoReg;
            WB_RegWrite <= EX_RegWrite;
        end

    // Set processor outputs to control data memory
    always @(*)
        begin
            address_DM <= EX_ALU_result;
            WD_DM <= EX_WD;
            MemRead_DM <= EX_MemRead;
            MemWrite_DM <= EX_MemWrite;
        end

    // WriteBack stage
    always @(*)
        begin
        case(WB_MemtoReg)
            1'b0: WriteData <= WB_ALU_result;
            1'b1: WriteData <= WB_RD_DM;
        endcase
        end

endmodule
