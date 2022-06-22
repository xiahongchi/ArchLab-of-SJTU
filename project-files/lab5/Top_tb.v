`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/29 14:54:32
// Design Name: 
// Module Name: Top_tb
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


module Top_tb(

    );
    reg Clk;
    reg reset;
    Top Top(
        .Clk(Clk),
        .reset(reset)
    );
    
    always #20 if($time>=200) Clk = !Clk;
    initial begin
        Clk = 1;
        reset = 0;
        $readmemb("Instruction1.txt",Top.InstrMemory.MemFile);
        $readmemb("Data.txt",Top.DataMemory.MemFile);
        #100;
        reset = 1;
        #80;
        reset = 0;
        #20;
    end
endmodule
