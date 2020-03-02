`timescale 1ns / 1ps

module LEGv8_I_Mem(
    input      [63:0] PC,
    output reg [31:0] inst
    );

    // Internal Memory Structure
    reg [7:0] I_Mem [255:0];
    
    initial
        begin
            $readmemb("I_Memory.mem", I_Mem);
        end

    // Construct instruction from bytes in Memory every
    // time the PC changes
    always @(PC)
        begin
            inst[7:0]   <= I_Mem[(PC + 2'b11)];
            inst[15:8]  <= I_Mem[(PC + 2'b10)];
            inst[23:16] <= I_Mem[(PC + 2'b01)];
            inst[31:24] <= I_Mem[PC];
        end

endmodule
