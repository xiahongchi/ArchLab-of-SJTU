`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/12 13:26:19
// Design Name: 
// Module Name: ID_EXRegister
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


module ID_EXRegister(
    input [1:0] ID_RegDst,
    input [1:0] ID_ALUSrc1,
    input [1:0] ID_ALUSrc2,
    input ID_MemToReg,
    input ID_RegWrite,
    input ID_MemRead,
    input ID_MemWrite,
    input [1:0] ID_Branch,
    input [3:0] ID_ALUOp,
    input ID_Jump,
    input [1:0] ID_MByte,
    
    input [31:0] ID_CurPC,
    input [31:0] ID_NextSeqPC,
    input [31:0] ID_JumpAddr,
    input [31:0] ID_readData1,
    input [31:0] ID_readData2,
    input [31:0] ID_SignExtImm,
    input [31:0] ID_ZeroExtImm,
    
    input [4:0] ID_rt,
    input [4:0] ID_rd,
    input [4:0] ID_rs,
    
    input [5:0] ID_OpCode,
    input [5:0] ID_Funct,
    
    input Bubble,
    input D_Bubble,
    
    input ID_Predict,
    
    input Clk,
    input reset,
    
    output [1:0] EX_RegDst,
    output [1:0] EX_ALUSrc1,
    output [1:0] EX_ALUSrc2,
    output EX_MemToReg,
    output EX_RegWrite,
    output EX_MemRead,
    output EX_MemWrite,
    output [1:0] EX_Branch,
    output [3:0] EX_ALUOp,
    output EX_Jump,
    output [1:0] EX_MByte,
    
    output [31:0] EX_CurPC,
    output [31:0] EX_NextSeqPC,
    output [31:0] EX_JumpAddr,
    output [31:0] EX_readData1,
    output [31:0] EX_readData2,
    output [31:0] EX_SignExtImm,
    output [31:0] EX_ZeroExtImm,
    
    output [4:0] EX_rt,
    output [4:0] EX_rd,
    output [4:0] EX_rs,
    
    output EX_Predict,
    
    output [5:0] EX_OpCode,
    output [5:0] EX_Funct
    );
    
    reg [1:0] RegDst;
    reg [1:0] ALUSrc1;
    reg [1:0] ALUSrc2;
    reg MemToReg;
    reg RegWrite;
    reg MemRead;
    reg MemWrite;
    reg [1:0] Branch;
    reg [3:0] ALUOp;
    reg Jump;
    reg [1:0] MByte;
    
    reg [31:0] CurPC;
    reg [31:0] NextSeqPC;
    reg [31:0] JumpAddr;
    reg [31:0] readData1;
    reg [31:0] readData2;
    reg [31:0] SignExtImm;
    reg [31:0] ZeroExtImm;
   
    reg [4:0] rd;
    reg [4:0] rt;
    reg [4:0] rs;
    
    reg [5:0] OpCode;
    reg [5:0] Funct;
    
    reg Predict;
    
    always @(negedge Clk)
        begin
            if(Bubble == 1) begin
                RegDst = 0;
                ALUSrc1 = 0;
                ALUSrc2 = 0;
                MemToReg = 0;
                RegWrite = 0;
                MemRead = 0;
                MemWrite = 0;
                Branch = 0;
                ALUOp = 0;
                Jump = 0;
                MByte = 0;
                
                CurPC = 0;
                NextSeqPC = 0;
                JumpAddr = 0;
                readData1 = 0;
                readData2 = 0;
                SignExtImm = 0;
                ZeroExtImm = 0;
               
                rd = 0;
                rt = 0;
                rs = 0;
                
                OpCode = 0;
                Funct = 0;
                
                Predict = 0;
            end
            else begin
                if(D_Bubble == 0) begin
                    RegDst = ID_RegDst;
                    ALUSrc1 = ID_ALUSrc1;
                    ALUSrc2 = ID_ALUSrc2;
                    MemToReg = ID_MemToReg;
                    RegWrite = ID_RegWrite;
                    MemRead = ID_MemRead;
                    MemWrite = ID_MemWrite;
                    Branch = ID_Branch;
                    ALUOp = ID_ALUOp;
                    Jump = ID_Jump;
                    MByte = ID_MByte;
                    
                    readData1 = ID_readData1;
                    readData2 = ID_readData2;
                    SignExtImm = ID_SignExtImm;
                    ZeroExtImm = ID_ZeroExtImm;
                   
                    rd = ID_rd;
                    rt = ID_rt;
                    rs = ID_rs;
                    
                    OpCode = ID_OpCode;
                    Funct = ID_Funct;
                    
                    CurPC = ID_CurPC;
                    NextSeqPC = ID_NextSeqPC;
                    JumpAddr = ID_JumpAddr;
                    
                    Predict = ID_Predict;
                end
                
                else begin
                    RegDst = 0;
                    ALUSrc1 = 0;
                    ALUSrc2 = 0;
                    MemToReg = 0;
                    RegWrite = 0;
                    MemRead = 0;
                    MemWrite = 0;
                    Branch = 0;
                    ALUOp = 0;
                    Jump = 0;
                    MByte = 0;
                    
                    readData1 = 0;
                    readData2 = 0;
                    SignExtImm = 0;
                    ZeroExtImm = 0;
                   
                    rd = 0;
                    rt = 0;
                    rs = 0;
                    
                    OpCode = 0;
                    Funct = 0;
                    
                    CurPC = ID_CurPC;
                    NextSeqPC = ID_NextSeqPC;
                    JumpAddr = ID_JumpAddr;
                    
                    Predict = 0;
                end
            
            end
        end
        
    assign EX_RegDst = RegDst;
    assign EX_ALUSrc1 = ALUSrc1;
    assign EX_ALUSrc2 = ALUSrc2;
    assign EX_MemToReg = MemToReg;
    assign EX_RegWrite = RegWrite;
    assign EX_MemRead = MemRead;
    assign EX_MemWrite = MemWrite;
    assign EX_Branch = Branch;
    assign EX_ALUOp = ALUOp;
    assign EX_Jump = Jump;
    assign EX_MByte = MByte;
    
    assign EX_CurPC = CurPC;
    assign EX_NextSeqPC = NextSeqPC;
    assign EX_JumpAddr = JumpAddr;
    assign EX_readData1 = readData1;
    assign EX_readData2 = readData2;
    assign EX_SignExtImm = SignExtImm;
    assign EX_ZeroExtImm = ZeroExtImm;
   
    assign EX_rd = rd;
    assign EX_rt = rt;
    assign EX_rs = rs;  
    
    assign EX_OpCode = OpCode;
    assign EX_Funct = Funct;  
    assign EX_Predict = Predict;
    
    always @(posedge reset)
        begin
            RegDst = 0;
            ALUSrc1 = 0;
            ALUSrc2 = 0;
            MemToReg = 0;
            RegWrite = 0;
            MemRead = 0;
            MemWrite = 0;
            Branch = 0;
            ALUOp = 0;
            Jump = 0;
            MByte = 0;
            
            CurPC = 0;
            NextSeqPC = 0;
            JumpAddr = 0;
            readData1 = 0;
            readData2 = 0;
            SignExtImm = 0;
            ZeroExtImm = 0;
           
            rd = 0;
            rt = 0;
            rs = 0;
            
            OpCode = 0;
            Funct = 0;
            Predict = 0;
        end
    
endmodule
