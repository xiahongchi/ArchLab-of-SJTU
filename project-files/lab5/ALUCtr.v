`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/22 14:15:35
// Design Name: 
// Module Name: ALUCtr
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALUCtr(
    input [2:0] ALUOp,
    input [5:0] Funct,
    output [3:0] ALUCtr,
    output jr,
    output shift
    );
    reg [3:0] aluCtr;
    reg JR;
    reg SHIFT;
    always @ (ALUOp or Funct)
    begin
        casex ({ALUOp, Funct})
            9'b000xxxxxx: begin
                aluCtr = 4'b0010;//add
                JR = 0;
                SHIFT = 0;
            end
            9'b001xxxxxx: begin
                aluCtr = 4'b0110;//sub
                JR = 0;
                SHIFT = 0;
            end
            9'b011xxxxxx: begin
                aluCtr = 4'b0000;//and
                JR = 0;
                SHIFT = 0;
            end
            9'b100xxxxxx: begin
                aluCtr = 4'b0001;//or
                JR = 0;
                SHIFT = 0;
            end
            //R-type
            9'b010100000: begin
                aluCtr = 4'b0010;//add
                JR = 0;
                SHIFT = 0;
            end
            9'b010100010: begin
                aluCtr = 4'b0110;//sub
                JR = 0;
                SHIFT = 0;
            end
            9'b010100100: begin
                aluCtr = 4'b0000;//and
                JR = 0;
                SHIFT = 0;
            end
            9'b010100101: begin
                aluCtr = 4'b0001;//or
                JR = 0;
                SHIFT = 0;
            end
            9'b010101010: begin
                aluCtr = 4'b0111;//slt
                JR = 0;
                SHIFT = 0;
            end
            9'b010100111: begin
                aluCtr = 4'b1100;//nor
                JR = 0;
                SHIFT = 0;
            end
            9'b010000000: begin
                aluCtr = 4'b0011;//sll
                JR = 0;
                SHIFT = 1;
            end
            9'b010000010: begin
                aluCtr = 4'b0100;//srl
                JR = 0;
                SHIFT = 1;
            end
            9'b010001000: begin 
                aluCtr = 4'b1000;//jr 
                JR = 1;
                SHIFT = 0;
            end
            default: aluCtr = 4'b0000;
        endcase
    end
    assign ALUCtr = aluCtr;
    assign jr = JR;
    assign shift = SHIFT;
endmodule
