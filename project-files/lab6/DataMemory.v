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
    input [1:0] MByte,
    output [31:0] ReadData
    );
    
    reg [31:0] MemFile[0:63];
    reg [31:0] rd;
    
    always @ (Address or MemFile[Address])
        begin
            rd = 0;
            if(MemRead==1)
                rd = MemFile[Address];
        end
        
    assign ReadData = rd;
    
    always @ (negedge Clk)
        begin
            if(MemWrite==1) begin
                case(MByte)
                    2'b00: MemFile[Address] <= WriteData;
                    2'b01: MemFile[Address][15:0] <= WriteData[15:0];
                    2'b10: MemFile[Address][7:0] <= WriteData[7:0];
                    default: MemFile[Address] <= WriteData;
                endcase 
            end
        end
endmodule
