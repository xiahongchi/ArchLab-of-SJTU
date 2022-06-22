`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/22 14:48:37
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [31:0] input1,
    input [31:0] input2,
    input [3:0] ALUCtr,
    output zero,
    output [31:0] ALURes
    );
    
    reg Zero;
    reg [31:0] alures;
    reg signed [31:0] slt_input1;
    reg signed [31:0] slt_input2;
    
    always @ (input1 or input2 or ALUCtr)
    begin
        case(ALUCtr)
            4'b0000: //and
            begin
                alures = input1 & input2;
                if(alures == 0)
                    Zero = 1;
                else
                    Zero = 0;
            end
            
            4'b0001: //or
            begin
                alures = input1 | input2;
                if(alures == 0)
                    Zero = 1;
                else
                    Zero = 0;
            end
            
            4'b0010: //add
            begin
                alures = input1 + input2;
                if(alures == 0)
                    Zero = 1;
                else
                    Zero = 0;
            end
            
            4'b0110: //sub
            begin
                alures = input1 - input2;
                if(alures == 0)
                    Zero = 1;
                else
                    Zero = 0;
            end
            
            4'b0111: //slt
            begin
                slt_input1 = input1;
                slt_input2 = input2;
                if(slt_input1 < slt_input2)
                    alures = 1;
                else
                    alures = 0;
                if(alures == 0)
                    Zero = 1;
                else
                    Zero = 0;
            end
            
            4'b1100: //nor
            begin
                alures = ~(input1 | input2);
                if(alures == 0)
                    Zero = 1;
                else
                    Zero = 0;
            end
            
            4'b0011://sll
            begin
                alures = input1 << input2[4:0];
                if(alures == 0)
                    Zero = 1;
                else
                    Zero = 0;
            end
            
            4'b0100://srl
            begin
                alures = input1 >> input2[4:0];
                if(alures == 0)
                    Zero = 1;
                else
                    Zero = 0;
            end
            
            4'b0101://jr
            begin
                alures = 0;
                Zero = 1;
            end
            
            default:
            begin
                alures = 0;
                Zero = 1;
            end
        endcase
    end
    assign ALURes = alures;
    assign zero = Zero;
endmodule
