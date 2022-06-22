`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/22 16:17:10
// Design Name: 
// Module Name: DataMemory
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


module DataMemory(
    input Clk,
    input [31:0] Address,
    input [31:0] WriteData,
    input MemWrite,
    input MemRead,
    output [31:0] ReadData
    );
    
    reg [31:0] MemFile[0:63];
    reg [31:0] rd;
    
    always @ (Address)
        begin
            rd = 0;
            if(MemRead==1)
                rd = MemFile[Address];
        end
        
    assign ReadData = rd;
    
    always @ (negedge Clk)
        begin
            if(MemWrite==1)
                MemFile[Address] <= WriteData;
        end
endmodule
