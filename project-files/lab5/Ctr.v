`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/22 13:11:43
// Design Name: 
// Module Name: Ctr
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


module Ctr(
    input [5:0] OpCode,
    output [1:0] RegDst, //new 00-rt 01-rd 10-31(for jal)
    output [1:0] ALUSrc1, //new 00-rs 01-rt 10-pc
    output [1:0] ALUSrc2, //new 00-rt 01-signext 10-zeroext 11-8
    output MemToReg, 
    output RegWrite,
    output MemRead,
    output MemWrite,
    output Branch,
    output [2:0] ALUOp, //new 000-add 001-sub 010-Rtype 011-and 100-or
    output Jump
    );
    
    reg [1:0] regDst;
    reg [1:0] aluSrc1;
    reg [1:0] aluSrc2;
    reg memtoReg;
    reg regWrite;
    reg memRead;
    reg memWrite;
    reg branch;
    reg [2:0] aluOp;
    reg jump;
    
    always @ (OpCode)
    begin
        case(OpCode)
            6'b000000: //R type
            begin
                regDst = 2'b01;
                aluSrc1 = 2'b00;
                aluSrc2 = 2'b00;
                memtoReg = 0;
                regWrite = 1;
                memRead = 0;
                memWrite = 0;
                branch = 0;
                aluOp = 3'b010;
                jump = 0;
            end
            
            6'b100011: //lw
            begin
                regDst = 2'b00;
                aluSrc1 = 2'b00;
                aluSrc2 = 2'b01;
                memtoReg = 1;
                regWrite = 1;
                memRead = 1;
                memWrite = 0;
                branch = 0;
                aluOp = 3'b000;
                jump = 0;
            end
            
            6'b101011: //sw
            begin
                regDst = 2'b00;
                aluSrc1 = 2'b00;
                aluSrc2 = 2'b01;
                memtoReg = 0;
                regWrite = 0;
                memRead = 0;
                memWrite = 1;
                branch = 0;
                aluOp = 3'b000;
                jump = 0;
            end
            
            6'b000100: //beq
            begin
                regDst = 0;
                aluSrc1 = 2'b00;
                aluSrc2 = 2'b00;
                memtoReg = 0;
                regWrite = 0;
                memRead = 0;
                memWrite = 0;
                branch = 1;
                aluOp = 3'b001;
                jump = 0;
            end
            
            6'b000010: //J
            begin
                regDst = 0;
                aluSrc1 = 0;
                aluSrc2 = 0;
                memtoReg = 0;
                regWrite = 0;
                memRead = 0;
                memWrite = 0;
                branch = 0;
                aluOp = 2'b000;
                jump = 1;
            end
            
            6'b001000://addi
            begin
                regDst = 2'b00;
                aluSrc1 = 2'b00;
                aluSrc2 = 2'b01;
                memtoReg = 0;
                regWrite = 1;
                memRead = 0;
                memWrite = 0;
                branch = 0;
                aluOp = 3'b000;
                jump = 0;
            end
            
            6'b001100://andi
            begin
                regDst = 2'b00;
                aluSrc1 = 2'b00;
                aluSrc2 = 2'b10;
                memtoReg = 0;
                regWrite = 1;
                memRead = 0;
                memWrite = 0;
                branch = 0;
                aluOp = 3'b011;
                jump = 0;
            end
            
            6'b001101://ori
            begin
                regDst = 2'b00;
                aluSrc1 = 2'b00;
                aluSrc2 = 2'b10;
                memtoReg = 0;
                regWrite = 1;
                memRead = 0;
                memWrite = 0;
                branch = 0;
                aluOp = 3'b100;
                jump = 0;
            end
            
            6'b000011://jal
            begin
                regDst = 2'b10;
                aluSrc1 = 2'b10;
                aluSrc2 = 2'b11;
                memtoReg = 0;
                regWrite = 1;
                memRead = 0;
                memWrite = 0;
                branch = 0;
                aluOp = 3'b000;
                jump = 1;
            end
            
            default:
            begin
                regDst = 0;
                aluSrc1 = 0;
                aluSrc2 = 0;
                memtoReg = 0;
                regWrite = 0;
                memRead = 0;
                memWrite = 0;
                branch = 0;
                aluOp = 0;
                jump = 0;
            end
        endcase
    end
   
   assign RegDst = regDst;
   assign ALUSrc1 = aluSrc1;
   assign ALUSrc2 = aluSrc2;
   assign MemToReg = memtoReg;
   assign RegWrite = regWrite;
   assign MemRead = memRead;
   assign MemWrite = memWrite;
   assign Branch = branch;
   assign ALUOp = aluOp;
   assign Jump = jump;
   
endmodule
