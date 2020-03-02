`timescale 1ns / 1ps

// num lines == 16
// num sets == 4

module LEGv8_Cache_Controller(
    input clk,
    input rst,

    // Input from Processor
    input [63:0] PC,

    // Input from Cache_Mem
    input hit_status,

    // Output to Cache
    output reg [4:0]  Index,
    output reg [56:0] Tag,
    output reg        Write0,
    output reg        Write1,
    output reg        Write2,
    output reg        Write3
    );

    // Internal variables
    reg [1:0] FIFO[0:15];

    always @(rst or posedge clk)
        begin
            Index = PC[6:2];
            Tag   = PC[63:7];
            Write0 = 1'b0;
            Write1 = 1'b0;
            Write2 = 1'b0;
            Write3 = 1'b0;
        end

    always @(negedge clk)
        begin
            if(hit_status == 1'b0)
                case(FIFO[Index])
                2'bxx:
                    begin
                        FIFO[Index] = 2'b01;
                        Write0 = 1'b1;
                    end
                2'b00:
                    begin
                        FIFO[Index] = FIFO[Index] + 1'b1;
                        Write0 = 1'b1;
                    end
                2'b01:
                    begin
                        FIFO[Index] = FIFO[Index] + 1'b1;
                        Write1 = 1'b1;
                    end
                2'b10:
                    begin
                        FIFO[Index] <= FIFO[Index] + 1'b1;
                        Write2 = 1'b1;
                    end
                2'b11:
                    begin
                        FIFO[Index] <= FIFO[Index] + 1'b1;
                        Write3 = 1'b1;
                    end
                endcase
        end

endmodule
