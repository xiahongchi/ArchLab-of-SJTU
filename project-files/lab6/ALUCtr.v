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
    input [3:0] ALUOp,
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
            10'b0000xxxxxx: begin
                aluCtr = 4'b0010;//add
                JR = 0;
                SHIFT = 0;
            end
            10'b0110xxxxxx: begin
                aluCtr = 4'b1001;//addu
                JR = 0;
                SHIFT = 0;
            end
            10'b0001xxxxxx: begin
                aluCtr = 4'b0110;//sub
                JR = 0;
                SHIFT = 0;
            end
            10'b0011xxxxxx: begin
                aluCtr = 4'b0000;//and
                JR = 0;
                SHIFT = 0;
            end
            10'b0100xxxxxx: begin
                aluCtr = 4'b0001;//or
                JR = 0;
                SHIFT = 0;
            end
            10'b0101xxxxxx: begin
                aluCtr = 4'b0111;//slt
                JR = 0;
                SHIFT = 0;
            end
            10'b0111xxxxxx: begin
                aluCtr = 4'b1000;//sltu
                JR = 0;
                SHIFT = 0;
            end
            10'b1000xxxxxx: begin
                aluCtr = 4'b1011;//lui
                JR = 0;
                SHIFT = 0;
            end
            10'b1001xxxxxx: begin
                aluCtr = 4'b1101;//xori
                JR = 0;
                SHIFT = 0;
            end
            //R-type
            10'b0010100000: begin//add
                aluCtr = 4'b0010;//add
                JR = 0;
                SHIFT = 0;
            end
            10'b0010100001: begin//addu
                aluCtr = 4'b1001;//addu
                JR = 0;
                SHIFT = 0;
            end
            10'b0010100010: begin
                aluCtr = 4'b0110;//sub
                JR = 0;
                SHIFT = 0;
            end
            10'b0010100011: begin//subu
                aluCtr = 4'b1010;//subu
                JR = 0;
                SHIFT = 0;
            end
            10'b0010100100: begin
                aluCtr = 4'b0000;//and
                JR = 0;
                SHIFT = 0;
            end
            10'b0010100101: begin
                aluCtr = 4'b0001;//or
                JR = 0;
                SHIFT = 0;
            end
            10'b0010101010: begin
                aluCtr = 4'b0111;//slt
                JR = 0;
                SHIFT = 0;
            end
            10'b0010101011: begin
                aluCtr = 4'b1000;//sltu
                JR = 0;
                SHIFT = 0;
            end
            10'b0010100111: begin
                aluCtr = 4'b1100;//nor
                JR = 0;
                SHIFT = 0;
            end
            10'b0010000000: begin
                aluCtr = 4'b0011;//sll
                JR = 0;
                SHIFT = 1;
            end
            10'b0010000010: begin
                aluCtr = 4'b0100;//srl
                JR = 0;
                SHIFT = 1;
            end
            10'b0010001000: begin 
                aluCtr = 4'b1000;//jr 
                JR = 1;
                SHIFT = 0;
            end
            10'b0010100110: begin
                aluCtr = 4'b1101;//xor
                JR = 0;
                SHIFT = 0;
            end
            10'b0010000011: begin
                aluCtr = 4'b1110;//sra
                JR = 0;
                SHIFT = 1;
            end
            10'b0010000100: begin
                aluCtr = 4'b0011;//sll
                JR = 0;
                SHIFT = 0;
            end
            10'b0010000110: begin
                aluCtr = 4'b0100;//srl
                JR = 0;
                SHIFT = 0;
            end
            10'b0010000111: begin
                aluCtr = 4'b1110;//sra
                JR = 0;
                SHIFT = 0;
            end
            default: aluCtr = 4'b0000;
        endcase
    end
    assign ALUCtr = aluCtr;
    assign jr = JR;
    assign shift = SHIFT;
endmodule
