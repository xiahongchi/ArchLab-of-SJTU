`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/12 13:11:56
// Design Name: 
// Module Name: Top_Pipeline
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


module Top_Pipeline(
    input reset,
    input Clk
    );
    
   
    
    //IF stage:
    
    wire Bubble;
    wire D_Bubble;
    wire [31:0] Correct_Next_PC;
    wire [31:0] Predict_Next_PC;
    wire [1:0] Two_Bit_Predictor;
    wire IF_Predict;
    
    //PC
    wire [31:0] IF_CurPC;
    wire [31:0] IF_NextPC = Bubble? Correct_Next_PC : Predict_Next_PC; //Sequential by default
    PC PC(
        .NextPC(IF_NextPC),
        .Clk(Clk),
        .reset(reset),
        .D_Bubble(D_Bubble),
        .CurPC(IF_CurPC)
    );
    
    //InstrMemory
    wire [31:0] IF_Instr;
    InstrMemory InstrMemory(
        .Address(IF_CurPC),
        .ReadInstr(IF_Instr)
    );
    
    wire [31:0] IF_NextSeqPC = IF_CurPC + 4;

    
    wire [31:0] ID_NextSeqPC;
    wire [31:0] ID_Instr;
    wire [31:0] ID_CurPC;
    wire ID_Predict;
    //IF_IDRegister
    IF_IDRegister IF_IDRegister(
        .IF_CurPC(IF_CurPC),
        .IF_NextSeqPC(IF_NextSeqPC),
        .IF_Instr(IF_Instr),
        .IF_Predict(IF_Predict),
        .Bubble(Bubble),
        .Clk(Clk),
        .reset(reset),
        .D_Bubble(D_Bubble),
        .ID_CurPC(ID_CurPC),
        .ID_NextSeqPC(ID_NextSeqPC),
        .ID_Instr(ID_Instr),
        .ID_Predict(ID_Predict)
    );
    
    //ID stage:
    
    //Ctr
    wire [1:0] ID_RegDst;
    wire [1:0] ID_ALUSrc1;
    wire [1:0] ID_ALUSrc2;
    wire ID_MemToReg;
    wire ID_RegWrite;
    wire ID_MemRead;
    wire ID_MemWrite;
    wire [1:0] ID_Branch; //change here
    wire [3:0] ID_ALUOp;
    wire ID_Jump;
    wire [1:0] ID_MByte;
    Ctr Ctr(
        .OpCode(ID_Instr[31:26]),
        .RegDst(ID_RegDst),
        .ALUSrc1(ID_ALUSrc1),
        .ALUSrc2(ID_ALUSrc2),
        .MemToReg(ID_MemToReg),
        .RegWrite(ID_RegWrite),
        .MemRead(ID_MemRead),
        .MemWrite(ID_MemWrite),
        .Branch(ID_Branch),
        .ALUOp(ID_ALUOp),
        .Jump(ID_Jump),
        .MByte(ID_MByte)
    );
    
    
    //Registers
    wire [4:0] WB_writeReg;      //From WB
    wire [31:0] WB_writeData;   //From WB
    wire [31:0] ID_readData1;
    wire [31:0] ID_readData2;
    wire WB_RegWrite;           //From WB
    wire WB_jr;                 //From WB
    Registers Registers(
        .Clk(Clk),
        .readReg1(ID_Instr[25:21]),
        .readReg2(ID_Instr[20:16]),
        .writeReg(WB_writeReg),
        .writeData(WB_writeData),
        .regWrite(WB_RegWrite),
        .jr(WB_jr), 
        .reset(reset),
        .readData1(ID_readData1),
        .readData2(ID_readData2)
    );
    
    //SignExt
    wire [31:0] ID_SignExtImm;
    SignExt SignExt(
        .Instr(ID_Instr[15:0]),
        .Data(ID_SignExtImm)
    );
    
    //ZeroExt
    wire [31:0] ID_ZeroExtImm;
    ZeroExt ZeroExt(
        .Instr(ID_Instr[15:0]),
        .Data(ID_ZeroExtImm)
    );
    
    wire [31:0] ID_JumpAddr;
    assign ID_JumpAddr[27:0] = ID_Instr[25:0] << 2;
    assign ID_JumpAddr[31:28] = ID_NextSeqPC[31:28];
    
    //ID_EXRegister
    wire [1:0] EX_RegDst;
    wire [1:0] EX_ALUSrc1;
    wire [1:0] EX_ALUSrc2;
    wire EX_MemToReg;
    wire EX_RegWrite;
    wire EX_MemRead;
    wire EX_MemWrite;
    wire [1:0] EX_Branch;
    wire [3:0] EX_ALUOp;
    wire EX_Jump;
    wire [1:0] EX_MByte;
    
    wire [31:0] EX_CurPC;
    wire [31:0] EX_NextSeqPC;
    wire [31:0] EX_JumpAddr;
    wire [31:0] EX_readData1;
    wire [31:0] EX_readData2;
    wire [31:0] EX_SignExtImm;
    wire [31:0] EX_ZeroExtImm;
    
    wire [4:0] EX_rt;
    wire [4:0] EX_rd;
    wire [4:0] EX_rs;
    
    wire [5:0] EX_OpCode;
    wire [5:0] EX_Funct;
    
    wire EX_Predict;
    ID_EXRegister ID_EXRegister(
        .ID_RegDst(ID_RegDst),
        .ID_ALUSrc1(ID_ALUSrc1),
        .ID_ALUSrc2(ID_ALUSrc2),
        .ID_MemToReg(ID_MemToReg),
        .ID_RegWrite(ID_RegWrite),
        .ID_MemRead(ID_MemRead),
        .ID_MemWrite(ID_MemWrite),
        .ID_Branch(ID_Branch),
        .ID_ALUOp(ID_ALUOp),
        .ID_Jump(ID_Jump),
        .ID_MByte(ID_MByte),
        
        .ID_CurPC(ID_CurPC),
        .ID_NextSeqPC(ID_NextSeqPC),
        .ID_JumpAddr(ID_JumpAddr),
        .ID_readData1(ID_readData1),
        .ID_readData2(ID_readData2),
        .ID_SignExtImm(ID_SignExtImm),
        .ID_ZeroExtImm(ID_ZeroExtImm),
        
        .ID_rt(ID_Instr[20:16]),
        .ID_rd(ID_Instr[15:11]),
        .ID_rs(ID_Instr[25:21]),
        
        .ID_OpCode(ID_Instr[31:26]),
        .ID_Funct(ID_Instr[5:0]),
        .ID_Predict(ID_Predict),
        
        .Bubble(Bubble),
        
        .D_Bubble(D_Bubble),
        .Clk(Clk),
        .reset(reset),
        
        .EX_RegDst(EX_RegDst),
        .EX_ALUSrc1(EX_ALUSrc1),
        .EX_ALUSrc2(EX_ALUSrc2),
        .EX_MemToReg(EX_MemToReg),
        .EX_RegWrite(EX_RegWrite),
        .EX_MemRead(EX_MemRead),
        .EX_MemWrite(EX_MemWrite),
        .EX_Branch(EX_Branch),
        .EX_ALUOp(EX_ALUOp),
        .EX_Jump(EX_Jump),
        .EX_MByte(EX_MByte),
        
        .EX_CurPC(EX_CurPC),
        .EX_NextSeqPC(EX_NextSeqPC),
        .EX_JumpAddr(EX_JumpAddr),
        .EX_readData1(EX_readData1),
        .EX_readData2(EX_readData2),
        .EX_SignExtImm(EX_SignExtImm),
        .EX_ZeroExtImm(EX_ZeroExtImm),
        .EX_Predict(EX_Predict),
        
        .EX_rd(EX_rd),
        .EX_rt(EX_rt),
        .EX_rs(EX_rs),
        
        .EX_OpCode(EX_OpCode),
        .EX_Funct(EX_Funct)
    );
    
    //EX stage
    
    wire [1:0] Input1_Sel;
    wire [1:0] Input2_Sel;
    wire [1:0] sw_sel;
    wire [1:0] jr_sel;
    
    reg [31:0] EX_ALU_input1;
    reg [31:0] EX_ALU_input2;
    
    wire [31:0] MEM_ALURes;
    
    //ALUCtr
    wire [3:0] EX_aluCtr;
    wire EX_shift;
    wire EX_jr;
    ALUCtr ALUCtr(
        .ALUOp(EX_ALUOp),
        .Funct(EX_SignExtImm[5:0]),
        .ALUCtr(EX_aluCtr),
        .jr(EX_jr),
        .shift(EX_shift)
    );
    
    reg [31:0] EX_input1;
    reg [31:0] EX_input2;
    
    //ALU INPUT 1
    always @(EX_ALUSrc1 or EX_shift or EX_readData1 or EX_readData2 or EX_CurPC) begin
        case (EX_ALUSrc1)
            2'b00: begin
                if(!EX_shift) EX_input1 = EX_readData1;
                //else EX_input1 = EX_readData2;
                else EX_input1 = EX_SignExtImm[10:6];
            end
            2'b01: EX_input1 = EX_readData2;
            2'b10: EX_input1 = EX_CurPC;
            default: EX_input1 = 0;
        endcase
    end
    
    always @(EX_input1 or Input1_Sel or MEM_ALURes or WB_writeData) begin
        case (Input1_Sel)
            2'b00: EX_ALU_input1 = EX_input1;
            2'b01: EX_ALU_input1 = MEM_ALURes;
            2'b10: EX_ALU_input1 = WB_writeData;
            default: EX_ALU_input1 = EX_input1;
        endcase
        end
    
    //ALU INPUT 2
    always @(EX_ALUSrc2 or EX_shift or EX_readData2 or EX_SignExtImm or EX_ZeroExtImm) begin
        case (EX_ALUSrc2)
            2'b00: begin
                if(!EX_shift) EX_input2 = EX_readData2;
                //else EX_input2 = EX_SignExtImm[10:6];
                else EX_input2 = EX_readData2;
            end
            2'b01: EX_input2 = EX_SignExtImm;
            2'b10: EX_input2 = EX_ZeroExtImm;
            2'b11: EX_input2 = 8;
            default: EX_input2 = 0;
        endcase
    end
    
    always @(EX_input2 or Input2_Sel or MEM_ALURes or WB_writeData) begin
        case (Input2_Sel)
            2'b00: EX_ALU_input2 = EX_input2;
            2'b01: EX_ALU_input2 = MEM_ALURes;
            2'b10: EX_ALU_input2 = WB_writeData;
            default: EX_ALU_input2 = EX_input2;
        endcase
        end
        
    reg [31:0] EX_WriteData;    
    //SW
    always @(EX_MemWrite or sw_sel or EX_readData2 or MEM_ALURes or WB_writeData) begin
        case (sw_sel)
            2'b00: EX_WriteData = EX_readData2;
            2'b01: EX_WriteData = MEM_ALURes;
            2'b10: EX_WriteData = WB_writeData;
            default: EX_WriteData = EX_readData2;
        endcase
    end
    
    reg [31:0] EX_JRValue;
    //JR
    always @(EX_jr or jr_sel or EX_readData1 or MEM_ALURes or WB_writeData) begin
        case (jr_sel)
            2'b00: EX_JRValue = EX_readData1;
            2'b01: EX_JRValue = MEM_ALURes;
            2'b10: EX_JRValue = WB_writeData;
            default: EX_JRValue = EX_readData1;
        endcase
    end
    
    reg [4:0] EX_writeReg;
    always @(EX_RegDst or EX_rt or EX_rd) begin
        case (EX_RegDst)
            2'b00: EX_writeReg = EX_rt;
            2'b01: EX_writeReg = EX_rd;
            2'b10: EX_writeReg = 5'b11111;
            default: EX_writeReg = 0;
        endcase
    end
    
    //ALU
    wire EX_zero;
    wire [31:0] EX_ALURes;
    wire EX_Overflow;
    ALU ALU(
        .input1(EX_ALU_input1),
        .input2(EX_ALU_input2),
        .ALUCtr(EX_aluCtr),
        .zero(EX_zero),
        .overflow(EX_Overflow),
        .ALURes(EX_ALURes)
    );
    
    //PC-EX
    wire [31:0] EX_BranchAddr;
    assign EX_BranchAddr = EX_NextSeqPC + (EX_SignExtImm << 2);
    
    //EX_MEMRegister
    wire MEM_MemToReg;
    wire MEM_RegWrite;
    wire [4:0] MEM_writeReg;
    
    wire MEM_MemRead;
    wire MEM_MemWrite;
    wire [1:0] MEM_MByte;
    
    wire [1:0] MEM_Branch;
    wire MEM_Jump;
    wire MEM_zero;
    wire MEM_jr;
    
    wire [31:0] MEM_readData1;
    wire [31:0] MEM_NextSeqPC;
    wire [31:0] MEM_JumpAddr;
    wire [31:0] MEM_BranchAddr;
    
    
    wire [31:0] MEM_WriteData;
    
    wire MEM_Predict;
    EX_MEMRegister EX_MEMRegister(
        .EX_MemToReg(EX_MemToReg),
        .EX_RegWrite(EX_RegWrite),
        .EX_writeReg(EX_writeReg),
        
        .EX_MemRead(EX_MemRead),
        .EX_MemWrite(EX_MemWrite),
        .EX_MByte(EX_MByte),
        
        .EX_Branch(EX_Branch),
        .EX_Jump(EX_Jump),
        .EX_zero(EX_zero),
        .EX_jr(EX_jr),
        
        .EX_readData1(EX_JRValue),
        .EX_NextSeqPC(EX_NextSeqPC),
        .EX_JumpAddr(EX_JumpAddr),
        .EX_BranchAddr(EX_BranchAddr),
        
        .EX_ALURes(EX_ALURes),
        .EX_WriteData(EX_WriteData),
        
        .EX_Predict(EX_Predict),
        .Bubble(Bubble),
        
        .Clk(Clk),
        .reset(reset),
        
        .MEM_MemToReg(MEM_MemToReg),
        .MEM_RegWrite(MEM_RegWrite),
        .MEM_writeReg(MEM_writeReg),
        
        .MEM_MemRead(MEM_MemRead),
        .MEM_MemWrite(MEM_MemWrite),
        .MEM_MByte(MEM_MByte),
        
        .MEM_Branch(MEM_Branch),
        .MEM_Jump(MEM_Jump),
        .MEM_zero(MEM_zero),
        .MEM_jr(MEM_jr),
        
        .MEM_readData1(MEM_readData1),
        .MEM_NextSeqPC(MEM_NextSeqPC),
        .MEM_JumpAddr(MEM_JumpAddr),
        .MEM_BranchAddr(MEM_BranchAddr),
        
        .MEM_ALURes(MEM_ALURes),
        .MEM_WriteData(MEM_WriteData),
        
        .MEM_Predict(MEM_Predict)
    );
    
    //MEM stage
    
    
    //Apply Cache_Line instead of DataMemory
    wire [31:0] MEM_ReadData;
    Cache_Line Cache_Line(
        .Clk(Clk),
        .reset(reset),
        .Address(MEM_ALURes),
        .WriteData(MEM_WriteData),
        .MemWrite(MEM_MemWrite),
        .MemRead(MEM_MemRead),
        .MByte(MEM_MByte),
        .ReadData(MEM_ReadData)
    );
    
    //MEM-PC
    wire [31:0] MEM_PreNextPC1;
    //assign MEM_PreNextPC1 = (MEM_Branch&&MEM_zero)? MEM_BranchAddr:MEM_NextSeqPC;
    //change here:
    assign MEM_PreNextPC1 = ((!MEM_Branch[1] && MEM_Branch[0] && MEM_zero) //01-eq
                          || (MEM_Branch[1] && (!MEM_Branch[0]) && (!MEM_zero)))? //10-ne
                                MEM_BranchAddr : MEM_NextSeqPC;
    wire [31:0] MEM_PreNextPC2;
    assign MEM_PreNextPC2 = MEM_jr? MEM_readData1:MEM_PreNextPC1;
    wire [31:0] MEM_NextPC;
    assign MEM_NextPC = MEM_Jump? MEM_JumpAddr:MEM_PreNextPC2;
    
    //MEM-Load
    reg [31:0] MEM_LoadData;
    always @(MEM_ReadData or MEM_MByte)begin
        case(MEM_MByte)
            2'b00: MEM_LoadData = MEM_ReadData;
            2'b01: MEM_LoadData = {16'b0, MEM_ReadData[15:0]};
            2'b10: MEM_LoadData = {24'b0, MEM_ReadData[7:0]};
            default: MEM_LoadData = MEM_ReadData;
        endcase
    end
    //MEM_WBRegister
    wire WB_MemToReg;
    
    wire [31:0] WB_ALURes;
    wire [31:0] WB_ReadData;
    MEM_WBRegister MEM_WBRegister(
        .MEM_MemToReg(MEM_MemToReg),
        .MEM_writeReg(MEM_writeReg),
        .MEM_RegWrite(MEM_RegWrite),
        .MEM_jr(MEM_jr),
        
        .MEM_ALURes(MEM_ALURes),
        .MEM_ReadData(MEM_LoadData),
        
        .Clk(Clk),
        .reset(reset),
        
        .WB_MemToReg(WB_MemToReg),
        .WB_writeReg(WB_writeReg),
        .WB_RegWrite(WB_RegWrite),
        .WB_jr(WB_jr),
        
        .WB_ALURes(WB_ALURes),
        .WB_ReadData(WB_ReadData)
    );
    
    //WB stage
    
    assign WB_writeData = WB_MemToReg? WB_ReadData:WB_ALURes;
    
    //For Control Hazard:
    Ctr_Hazard_Handler Ctr_Hazard_Handler(
        .Predict_Next_PC(IF_NextPC),
        .Real_Next_PC(MEM_NextPC),
        .Clk(Clk),
        .reset(reset),
        .Bubble(Bubble),
        .D_Bubble(D_Bubble),
        .MEM_NextSeqPC(MEM_NextSeqPC),
        .MEM_Predict(MEM_Predict),
        .Correct_Next_PC(Correct_Next_PC),
        .Two_Bit_Predictor(Two_Bit_Predictor)
    );
    
    //For Data Hazard:
    Data_Hazard_Handler Data_Hazard_Handler(
        .Clk(Clk),
        .reset(reset),
        
        //Forwarding:
        .EX_OpCode(EX_OpCode),
        .EX_Funct(EX_Funct),
        .MEM_regWrite(MEM_RegWrite),
        .MEM_writeReg(MEM_writeReg),
        .WB_regWrite(WB_RegWrite),
        .WB_writeReg(WB_writeReg),
        .EX_rs(EX_rs),
        
        .Input1_Sel(Input1_Sel),  //00-default 01-EX_MEMaluRes, 10-MEM_WBwriteData
        .Input2_Sel(Input2_Sel),
        .sw_sel(sw_sel), 
        .jr_sel(jr_sel),
        
        //Load-Use Case:
        .EX_MemRead(EX_MemRead),
        .EX_rt(EX_rt),
        .ID_Instr(ID_Instr),
        
        .D_Bubble(D_Bubble)
    );
    
    //Predict_PC
    Predict_PC Predict_PC(
        .Clk(Clk),
        .reset(reset),
        .Instr(IF_Instr),
        .IF_CurPC(IF_CurPC),
        .TwoBitPredictor(Two_Bit_Predictor),
        .Predict_Next_PC(Predict_Next_PC),
        .IF_Predict(IF_Predict)
    );
endmodule
