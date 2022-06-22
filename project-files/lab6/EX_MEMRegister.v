`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/12 13:25:22
// Design Name: 
// Module Name: EX_MEMRegister
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


module EX_MEMRegister(
    input EX_MemToReg,
    input EX_RegWrite,
    input [4:0] EX_writeReg,
    
    input EX_MemRead,
    input EX_MemWrite,
    input [1:0] EX_MByte,
    
    input [1:0] EX_Branch,
    input EX_Jump,
    input EX_zero,
    input EX_jr,
    
    input [31:0] EX_readData1,
    input [31:0] EX_NextSeqPC,
    input [31:0] EX_JumpAddr,
    input [31:0] EX_BranchAddr,
    
    input [31:0] EX_ALURes,
    input [31:0] EX_WriteData,
    input EX_Predict,
    
    input Bubble,
    
    input Clk,
    input reset,
    
    output MEM_MemToReg,
    output MEM_RegWrite,
    output [4:0] MEM_writeReg,
    
    output MEM_MemRead,
    output MEM_MemWrite,
    output [1:0] MEM_MByte,
    
    output [1:0] MEM_Branch,
    output MEM_Jump,
    output MEM_zero,
    output MEM_jr,
    
    output [31:0] MEM_readData1,
    output [31:0] MEM_NextSeqPC,
    output [31:0] MEM_JumpAddr,
    output [31:0] MEM_BranchAddr,
    
    output [31:0] MEM_ALURes,
    output [31:0] MEM_WriteData,
    output MEM_Predict
    );
    
    reg MemToReg;
    reg RegWrite;
    reg [5:0] writeReg;
    
    reg MemRead;
    reg MemWrite;
    reg [1:0] MByte;
    
    reg [1:0] Branch;
    reg Jump;
    reg zero;
    reg jr;
    
    reg [31:0] readData1;
    reg [31:0] NextSeqPC;
    reg [31:0] JumpAddr;
    reg [31:0] BranchAddr;
    
    reg [31:0] ALURes;
    reg [31:0] WriteData;
    
    reg Predict;
    
    always @(negedge Clk)
        begin
            if(Bubble == 1) begin
                MemToReg = 0;
                RegWrite = 0;
                writeReg = 0;
        
                MemRead = 0;
                MemWrite = 0;
                MByte = 0;
        
                Branch = 0;
                Jump = 0;
                zero = 0;
                jr = 0;
        
                readData1 = 0;
                NextSeqPC = 0;
                JumpAddr = 0;
                BranchAddr = 0;
        
                ALURes = 0;
                WriteData = 0;
                Predict = 0;
            end
            else begin
                MemToReg = EX_MemToReg;
                RegWrite = EX_RegWrite;
                writeReg = EX_writeReg;
        
                MemRead = EX_MemRead;
                MemWrite = EX_MemWrite;
                MByte = EX_MByte;
        
                Branch = EX_Branch;
                Jump = EX_Jump;
                zero = EX_zero;
                jr = EX_jr;
        
                readData1 = EX_readData1;
                NextSeqPC = EX_NextSeqPC;
                JumpAddr = EX_JumpAddr;
                BranchAddr = EX_BranchAddr;
        
                ALURes = EX_ALURes;
                WriteData = EX_WriteData;
                Predict = EX_Predict;
            end
        end
    
    assign MEM_MemToReg = MemToReg;
    assign MEM_RegWrite = RegWrite;
    assign MEM_writeReg = writeReg;
    
    assign MEM_MemRead = MemRead;
    assign MEM_MemWrite = MemWrite;
    assign MEM_MByte = MByte;
    
    assign MEM_Branch = Branch;
    assign MEM_Jump = Jump;
    assign MEM_zero = zero;
    assign MEM_jr = jr;
    
    assign MEM_readData1 = readData1;
    assign MEM_NextSeqPC = NextSeqPC;
    assign MEM_JumpAddr = JumpAddr;
    assign MEM_BranchAddr = BranchAddr;
    
    assign MEM_ALURes = ALURes;
    assign MEM_WriteData = WriteData;
    
    assign MEM_Predict = Predict;
    
    always @(posedge reset)
        begin
            MemToReg = 0;
            RegWrite = 0;
            writeReg = 0;
    
            MemRead = 0;
            MemWrite = 0;
            MByte = 0;
    
            Branch = 0;
            Jump = 0;
            zero = 0;
            jr = 0;
    
            readData1 = 0;
            NextSeqPC = 0;
            JumpAddr = 0;
            BranchAddr = 0;
    
            ALURes = 0;
            WriteData = 0;
            
            Predict = 0;
        end
    
endmodule
