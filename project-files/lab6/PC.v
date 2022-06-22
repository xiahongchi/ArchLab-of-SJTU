`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/29 13:08:32
// Design Name: 
// Module Name: PC
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


module PC(
    input [31:0] NextPC,
    input D_Bubble,
    input Clk,
    input reset,
    output [31:0] CurPC
    );
    reg [31:0] PCReg;
    
    
    always @ (posedge Clk)
        begin
            if(D_Bubble == 0) PCReg = NextPC;
        end
    assign CurPC = PCReg;
    
    always @ (posedge reset)
        begin
            PCReg = 0;
        end
endmodule
