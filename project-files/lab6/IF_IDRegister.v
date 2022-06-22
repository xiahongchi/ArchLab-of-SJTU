`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/12 13:23:33
// Design Name: 
// Module Name: IF_IDRegister
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


module IF_IDRegister(
    input [31:0] IF_CurPC,
    input [31:0] IF_NextSeqPC,
    input [31:0] IF_Instr,
    input IF_Predict,
    input Bubble,
    input D_Bubble,
    input Clk,
    input reset,
    output [31:0] ID_CurPC,
    output [31:0] ID_NextSeqPC,
    output [31:0] ID_Instr,
    output ID_Predict
    );
    
    reg [31:0] Instr;
    reg [31:0] CurPC;
    reg [31:0] NextSeqPC;
    reg Predict;
    
    always @(negedge Clk)
        begin
            if(D_Bubble == 0) begin
                Instr = IF_Instr;
                CurPC = IF_CurPC;
                NextSeqPC = IF_NextSeqPC;
                Predict = IF_Predict;
            end
        end
    
    assign ID_CurPC = CurPC;
    assign ID_NextSeqPC = NextSeqPC;
    assign ID_Instr = Instr;
    assign ID_Predict = Predict;
    
    always @(posedge reset)
        begin
            Instr = 0;
            CurPC = 0;
            NextSeqPC = 0;
            Predict = 0;
        end
    
endmodule
