`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/12 13:26:19
// Design Name: 
// Module Name: 
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: MEM_WBRegister
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MEM_WBRegister(
    input MEM_MemToReg,
    input [4:0] MEM_writeReg,
    input MEM_RegWrite,
    input MEM_jr,
    
    input [31:0] MEM_ALURes,
    input [31:0] MEM_ReadData,
    
    input Clk,
    input reset,
    
    output WB_MemToReg,
    output [4:0] WB_writeReg,
    output WB_RegWrite,
    output WB_jr,
    
    output [31:0] WB_ALURes,
    output [31:0] WB_ReadData
    );
    
    reg MemToReg;
    reg [4:0] writeReg;
    reg RegWrite;
    reg jr;
    
    reg [31:0] ALURes;
    reg [31:0] ReadData;
    
    always @(negedge Clk)
        begin
            MemToReg = MEM_MemToReg;
            writeReg = MEM_writeReg;
            RegWrite = MEM_RegWrite;
            jr = MEM_jr;
    
            ALURes = MEM_ALURes;
            ReadData = MEM_ReadData;
        end
    
    assign WB_MemToReg = MemToReg;
    assign WB_writeReg = writeReg;
    assign WB_RegWrite = RegWrite;
    assign WB_jr = jr;
    assign WB_ALURes = ALURes;
    assign WB_ReadData = ReadData;
    
    always @(posedge reset)
        begin
            MemToReg = 0;
            writeReg = 0;
            RegWrite = 0;
            jr = 0;
            ALURes = 0;
            ReadData = 0;
        end
endmodule
