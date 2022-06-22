`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/22 16:52:03
// Design Name: 
// Module Name: SignExt
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


module SignExt(
    input [15:0] Instr,
    output [31:0] Data
    );
    assign Data[31:0] ={{16{Instr[15]}},Instr[15:0]};
endmodule
