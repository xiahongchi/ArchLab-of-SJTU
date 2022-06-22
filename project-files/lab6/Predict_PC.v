`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/17 22:02:24
// Design Name: 
// Module Name: Predict_PC
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


module Predict_PC(
    input Clk,
    input reset,
    input [31:0] Instr,
    input [31:0] IF_CurPC,
    input [1:0] TwoBitPredictor,
    output [31:0] Predict_Next_PC,
    output IF_Predict
    );
    
    reg [31:0] pre_next_pc;
    reg if_predict;
    
    always @(IF_CurPC or Instr or TwoBitPredictor) begin
        
        
        case(Instr[31:26])
            6'b000010: begin //j
                pre_next_pc = {IF_CurPC[31:28],Instr[25:0],2'b00};
                if_predict = 0;
            end
            6'b000011: begin //jal
                pre_next_pc = {IF_CurPC[31:28],Instr[25:0],2'b00};
                if_predict = 0;
            end
            6'b000100: begin //beq
                if(TwoBitPredictor > 1) begin
                    pre_next_pc = IF_CurPC + 4 + {{14{Instr[15]}},Instr[15:0],2'b00};
                end
                else begin
                    pre_next_pc = IF_CurPC + 4;
                end
                if_predict = 1;
            end
            6'b000101: begin //bne
                if(TwoBitPredictor > 1) begin
                    pre_next_pc = IF_CurPC + 4 + {{14{Instr[15]}},Instr[15:0],2'b00};
                end
                else begin
                    pre_next_pc = IF_CurPC + 4;
                end
                if_predict = 1;
            end
            6'b000000: begin
                if(Instr[5:0] == 6'b001000) begin //jr
                    pre_next_pc = IF_CurPC + 4;
                    if_predict = 0;
                    //to be done...
                end
                else begin
                    pre_next_pc = IF_CurPC + 4;
                    if_predict = 0;
                end
            end
            default: begin
                pre_next_pc = IF_CurPC + 4;
                if_predict = 0;
            end
        endcase
    end
    
    assign Predict_Next_PC = pre_next_pc;
    assign IF_Predict = if_predict;
    always @(posedge reset) begin
        
    end
    
endmodule
