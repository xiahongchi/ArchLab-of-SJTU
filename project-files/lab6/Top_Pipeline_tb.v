`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/13 09:27:09
// Design Name: 
// Module Name: Top_Pipeline_tb
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


module Top_Pipeline_tb(

    );
    reg Clk;
    reg reset;
    
    Top_Pipeline Top_Pipeline(
        .Clk(Clk),
        .reset(reset)
    );
    
    always #20 if($time>=200) Clk = !Clk;
    initial begin
        Clk = 1;
        reset = 0;
        $readmemb("Instruction.txt",Top_Pipeline.InstrMemory.MemFile);
        $readmemb("Data.txt",Top_Pipeline.Cache_Line.DataMemory.MemFile);
        #100;
        reset = 1;
        #80;
        reset = 0;
        #20;
    end
endmodule
