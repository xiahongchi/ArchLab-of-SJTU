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
    output overflow, //new
    output [31:0] ALURes
    );
    
    reg Zero;
    reg Overflow;
    reg [31:0] alures;
    reg signed [31:0] signed_input1;
    reg signed [31:0] signed_input2;
    reg signed [31:0] signed_result;
    
    //0000-and 0001-or 0010-add 0011-sll
    //0100-srl 0101-jr 0110-sub 0111-slt
    //1000-sltu 1001-addu 1010-subu 1011-lui
    //1100-nor 1101-xor 1110-sra 1111-
    
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
                Overflow = 0;
            end
            
            4'b0001: //or
            begin
                alures = input1 | input2;
                if(alures == 0)
                    Zero = 1;
                else
                    Zero = 0;
                Overflow = 0;
            end
            
            4'b0010: //add
            begin
                alures = input1 + input2;
                if(alures == 0)
                    Zero = 1;
                else
                    Zero = 0;
                signed_input1 = input1;
                signed_input2 = input2;
                signed_result = alures;
                if(signed_input1 > 0 && signed_input2 > 0 && signed_result < 0
                || signed_input1 < 0 && signed_input2 < 0 && signed_result > 0) begin
                    Overflow = 1;
                end
                else begin
                    Overflow = 0;
                end
            end
            
            4'b1001: //addu
            begin
                alures = input1 + input2;
                if(alures == 0)
                    Zero = 1;
                else
                    Zero = 0;
                Overflow = 0;
            end
            
            4'b0110: //sub
            begin
                alures = input1 - input2;
                if(alures == 0)
                    Zero = 1;
                else
                    Zero = 0;
                signed_input1 = input1;
                signed_input2 = input2;
                signed_result = alures;
                if(signed_input1 > 0 && signed_input2 < 0 && signed_result < 0
                || signed_input1 < 0 && signed_input2 > 0 && signed_result > 0) begin
                    Overflow = 1;
                end
                else begin
                    Overflow = 0;
                end
            end
            
            4'b1010: //subu
            begin
                alures = input1 - input2;
                if(alures == 0)
                    Zero = 1;
                else
                    Zero = 0;
                Overflow = 0;
            end
            
            4'b1000: //sltu
            begin
                if(input1 < input2)
                    alures = 1;
                else
                    alures = 0;
                if(alures == 0)
                    Zero = 1;
                else
                    Zero = 0;
                Overflow = 0;
            end
            
            4'b0111: //slt
            begin
                signed_input1 = input1;
                signed_input2 = input2;
                if(signed_input1 < signed_input2)
                    alures = 1;
                else
                    alures = 0;
                if(alures == 0)
                    Zero = 1;
                else
                    Zero = 0;
                Overflow = 0;
            end
            
            4'b1100: //nor
            begin
                alures = ~(input1 | input2);
                if(alures == 0)
                    Zero = 1;
                else
                    Zero = 0;
                Overflow = 0;
            end
            
            4'b0011://sll
            begin
                alures = input2 << input1[4:0];
                if(alures == 0)
                    Zero = 1;
                else
                    Zero = 0;
                Overflow = 0;
            end
            
            4'b0100://srl
            begin
                alures = input2 >> input1[4:0];
                if(alures == 0)
                    Zero = 1;
                else
                    Zero = 0;
                Overflow = 0;
            end
            
            4'b0101://jr
            begin
                alures = 0;
                Zero = 1;
                Overflow = 0;
            end
            
            4'b1011://lui
            begin
                alures = {{input2[15:0]},16'b0};
                if(alures == 0)
                    Zero = 1;
                else
                    Zero = 0;
                Overflow = 0;
            end
            
            4'b1101://xor
            begin
                alures = input1 ^ input2;
                if(alures == 0)
                    Zero = 1;
                else
                    Zero = 0;
                Overflow = 0;
            end
            
            4'b1110://sra
            begin
                signed_input2 = input2;
                alures = signed_input2 >>> input1[4:0];
                if(alures == 0)
                    Zero = 1;
                else
                    Zero = 0;
                Overflow = 0;
            end
            
            default:
            begin
                alures = 0;
                Zero = 1;
                Overflow = 0;
            end
        endcase
    end
    assign ALURes = alures;
    assign zero = Zero;
    assign overflow = Overflow;
    
endmodule
