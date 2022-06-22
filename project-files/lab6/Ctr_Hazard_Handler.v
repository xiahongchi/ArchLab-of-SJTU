`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/12 22:44:35
// Design Name: 
// Module Name: Ctr_Hazard_Handler
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


module Ctr_Hazard_Handler(
    input [31:0] Predict_Next_PC,
    input [31:0] Real_Next_PC,
    input [31:0] MEM_NextSeqPC,
    input D_Bubble,
    input MEM_Predict,
    input Clk,
    input reset,
    output Bubble,
    output [31:0] Correct_Next_PC,
    output [1:0] Two_Bit_Predictor
    );
    
    reg [31:0] History_Predict_PC[0:2];
    integer ptr,recover_cycle;
    reg bubble;
    reg [1:0] TwoBitPredictor;
    
    always @(negedge Clk)
     begin
        History_Predict_PC[ptr] = Predict_Next_PC;
        ptr = (ptr + 1) % 3;
        recover_cycle = (recover_cycle > 0)? recover_cycle - 1 : 0;
     end
    
    always @(Real_Next_PC)
        begin
            #1;
            if(Real_Next_PC != History_Predict_PC[ptr] && recover_cycle == 0) begin
                bubble = 1;
                recover_cycle = 4;
                if(MEM_Predict == 1) begin
                    if(Real_Next_PC == MEM_NextSeqPC) begin //predict taken and wrong
                        case(TwoBitPredictor)
                            2'b11: TwoBitPredictor = 2'b10;
                            2'b10: TwoBitPredictor = 2'b01;
                            2'b01: TwoBitPredictor = 2'b00;
                            2'b00: TwoBitPredictor = 2'b00;
                        endcase
                    end
                    else begin //predict not-taken and wrong
                        case(TwoBitPredictor)
                            2'b11: TwoBitPredictor = 2'b11;
                            2'b10: TwoBitPredictor = 2'b11;
                            2'b01: TwoBitPredictor = 2'b10;
                            2'b00: TwoBitPredictor = 2'b01;
                        endcase
                    end
                end
            end
            else begin
                bubble = 0;
                if(MEM_Predict == 1 && recover_cycle == 0) begin
                    if(Real_Next_PC == MEM_NextSeqPC) begin //predict not-taken and right
                        case(TwoBitPredictor)
                            2'b11: TwoBitPredictor = 2'b10;
                            2'b10: TwoBitPredictor = 2'b01;
                            2'b01: TwoBitPredictor = 2'b00;
                            2'b00: TwoBitPredictor = 2'b00;
                        endcase
                    end
                    else begin //predict taken and right
                        case(TwoBitPredictor)
                            2'b11: TwoBitPredictor = 2'b11;
                            2'b10: TwoBitPredictor = 2'b11;
                            2'b01: TwoBitPredictor = 2'b10;
                            2'b00: TwoBitPredictor = 2'b01;
                        endcase
                    end
                end
            end
        end
    
    always @(D_Bubble) begin
        if(D_Bubble == 1) recover_cycle = 2;
    end
    
    assign Bubble = bubble;
    assign Correct_Next_PC = Real_Next_PC;
    assign Two_Bit_Predictor = TwoBitPredictor;
    
    always @(posedge reset)
        begin
            History_Predict_PC[0] = 0;
            History_Predict_PC[1] = 0;
            History_Predict_PC[2] = 0;
            ptr = 0;
            recover_cycle = 4;
            TwoBitPredictor = 0;
        end
endmodule
