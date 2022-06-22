`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/29 21:38:43
// Design Name: 
// Module Name: ZeroExt_tb
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


module ZeroExt_tb(

    );
    reg [15:0] Instr;
    wire [31:0] Data;
    ZeroExt ZeroExt(
        .Instr(Instr),
        .Data(Data)
    );
    initial begin
        Instr = 4;
        #100;
        Instr = -4;
        #100;
        Instr = 7;
        #100;
        Instr = -9;
        #100;
        Instr = 10;
        #100;
        Instr = -32;
        #100;
        Instr = 6;
        #100;
    end
endmodule
