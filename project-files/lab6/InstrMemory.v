`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/29 13:03:09
// Design Name: 
// Module Name: InstrMemory
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


module InstrMemory(
    input [31:0] Address,
    output [31:0] ReadInstr
    );
    reg [31:0] MemFile[0:63];
    reg [31:0] rd;
    always @ (Address)
        begin
           rd = MemFile[Address>>2];
        end
        
    assign ReadInstr = rd;
    
endmodule
