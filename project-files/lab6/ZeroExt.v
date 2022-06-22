`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/29 21:37:04
// Design Name: 
// Module Name: ZeroExt
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


module ZeroExt(
    input [15:0] Instr,
    output [31:0] Data
    );
    assign Data[31:0] = Instr[15:0];
endmodule
