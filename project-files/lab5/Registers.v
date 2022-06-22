`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/22 15:22:41
// Design Name: 
// Module Name: Registers
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


module Registers(
    input Clk,
    input [25:21] readReg1,
    input [20:16] readReg2,
    input [4:0] writeReg,
    input [31:0] writeData,
    input regWrite,
    input jr,
    input reset,
    output [31:0] readData1,
    output [31:0] readData2
    );
    
    reg [31:0] regFile[0:31];
    reg [31:0] rd1;
    reg [31:0] rd2;
    integer i;
    
    always @(readReg1 or readReg2 or writeReg)
        begin
            rd1 = regFile[readReg1];
            rd2 = regFile[readReg2];
        end
    
    assign readData1 = rd1;
    assign readData2 = rd2;
    
    always @(negedge Clk)
        begin
            if(regWrite&&!jr&&writeReg!=0) regFile[writeReg] = writeData;
        end
        
    always @(posedge reset)
        begin
            for(i=0;i<32;i=i+1) begin
                regFile[i]=0;
            end
        end
    
endmodule
