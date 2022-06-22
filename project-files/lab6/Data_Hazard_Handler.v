`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/13 18:35:51
// Design Name: 
// Module Name: Data_Hazard_Handler
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


module Data_Hazard_Handler(

    input Clk,
    input reset,
    
    //Forwarding:
    input [5:0] EX_OpCode,
    input [5:0] EX_Funct,
    input MEM_regWrite,
    input [4:0] MEM_writeReg,
    input WB_regWrite,
    input [4:0] WB_writeReg,
    input [4:0] EX_rs,
    
    output [1:0] Input1_Sel,  //00-default 01-EX_MEMaluRes, 10-MEM_WBwriteData
    output [1:0] Input2_Sel,
    output [1:0] sw_sel, 
    output [1:0] jr_sel,
    
    //Load-Use Case:
    input EX_MemRead,
    input [4:0] EX_rt,
    input [31:0] ID_Instr,
    
    output D_Bubble
    );
    
    reg d_bubble;
    
    assign D_Bubble = d_bubble;
    
    //Load-Use Case:
    always @(ID_Instr or EX_MemRead or EX_rt)
        begin
            if(EX_MemRead == 1 && EX_rt != 0)begin
                casex({ID_Instr[31:26],ID_Instr[5:0]})
                    12'b100011xxxxxx: //lw
                    begin 
                        //rs
                        if(ID_Instr[25:21] == EX_rt) d_bubble = 1;
                        else d_bubble = 0;
                    end
                    12'b100100xxxxxx: //lbu
                    begin 
                        //rs
                        if(ID_Instr[25:21] == EX_rt) d_bubble = 1;
                        else d_bubble = 0;
                    end
                    12'b100101xxxxxx: //lhu
                    begin 
                        //rs
                        if(ID_Instr[25:21] == EX_rt) d_bubble = 1;
                        else d_bubble = 0;
                    end
                    12'b101011xxxxxx: //sw
                    begin
                        //rs rt
                        if(ID_Instr[25:21] == EX_rt || ID_Instr[20:16] == EX_rt) d_bubble = 1;
                        else d_bubble = 0;
                    end
                    12'b101000xxxxxx: //sb
                    begin
                        //rs rt
                        if(ID_Instr[25:21] == EX_rt || ID_Instr[20:16] == EX_rt) d_bubble = 1;
                        else d_bubble = 0;
                    end
                    12'b101001xxxxxx: //sh
                    begin
                        //rs rt
                        if(ID_Instr[25:21] == EX_rt || ID_Instr[20:16] == EX_rt) d_bubble = 1;
                        else d_bubble = 0;
                    end
                    12'b000100xxxxxx: //beq
                    begin
                        //rs rt
                        if(ID_Instr[25:21] == EX_rt || ID_Instr[20:16] == EX_rt) d_bubble = 1;
                        else d_bubble = 0;
                    end
                    12'b000101xxxxxx: //bne new
                    begin
                        //rs rt
                        if(ID_Instr[25:21] == EX_rt || ID_Instr[20:16] == EX_rt) d_bubble = 1;
                        else d_bubble = 0;
                    end
                    12'b000000000000: //sll
                    begin
                        //rt
                        if(ID_Instr[20:16] == EX_rt) d_bubble = 1;
                        else d_bubble = 0;
                    end
                    12'b000000000010: //srl
                    begin
                        //rt
                        if(ID_Instr[20:16] == EX_rt) d_bubble = 1;
                        else d_bubble = 0;
                    end
                    12'b000000000011: //sra
                    begin
                        //rt
                        if(ID_Instr[20:16] == EX_rt) d_bubble = 1;
                        else d_bubble = 0;
                    end
                    12'b000000001000: //jr
                    begin
                        //rs
                        if(ID_Instr[25:21] == EX_rt) d_bubble = 1;
                        else d_bubble = 0;
                    end
                    12'b000000xxxxxx: //remaining r-type
                    begin
                        //rs rt
                        if(ID_Instr[25:21] == EX_rt || ID_Instr[20:16] == EX_rt) d_bubble = 1;
                        else d_bubble = 0;
                    end
                    12'b001000xxxxxx: //addi
                    begin
                        //rs
                        if(ID_Instr[25:21] == EX_rt) d_bubble = 1;
                        else d_bubble = 0;
                    end
                    12'b001001xxxxxx: //addiu new
                    begin
                        //rs
                        if(ID_Instr[25:21] == EX_rt) d_bubble = 1;
                        else d_bubble = 0;
                    end
                    12'b001111xxxxxx: //lui new
                    begin
                        d_bubble = 0;
                    end
                    12'b001010xxxxxx: //slti new
                    begin
                        //rs
                        if(ID_Instr[25:21] == EX_rt) d_bubble = 1;
                        else d_bubble = 0;
                    end
                    12'b001011xxxxxx: //sltiu new
                    begin
                        //rs
                        if(ID_Instr[25:21] == EX_rt) d_bubble = 1;
                        else d_bubble = 0;
                    end
                    12'b001100xxxxxx: //andi
                    begin
                        //rs
                        if(ID_Instr[25:21] == EX_rt) d_bubble = 1;
                        else d_bubble = 0;
                    end
                    12'b001101xxxxxx: //ori
                    begin
                        //rs
                        if(ID_Instr[25:21] == EX_rt) d_bubble = 1;
                        else d_bubble = 0;
                    end
                    12'b001110xxxxxx: //xori
                    begin
                        //rs
                        if(ID_Instr[25:21] == EX_rt) d_bubble = 1;
                        else d_bubble = 0;
                    end
                    12'b000011xxxxxx: //jal
                    begin
                        d_bubble = 0;
                    end
                    12'b000010xxxxxx: //j
                    begin
                        d_bubble = 0;
                    end
                    default:
                        d_bubble = 0;
                endcase
            end
            else d_bubble = 0;
        end
    
    reg [1:0] input1_sel;
    reg [1:0] input2_sel;
    reg [1:0] sw_sel_reg;
    reg [1:0] jr_sel_reg;
    
    assign Input1_Sel = input1_sel;  //00-default 01-EX_MEMaluRes, 10-MEM_WBwriteData
    assign Input2_Sel = input2_sel;
    assign sw_sel = sw_sel_reg;
    assign jr_sel = jr_sel_reg;
    
    //Forwarding:
    always @(EX_OpCode, EX_Funct, EX_rs, EX_rt, MEM_regWrite, 
        MEM_writeReg, WB_regWrite, WB_writeReg) 
        begin
            
            casex({EX_OpCode,EX_Funct}) 
                12'b100011xxxxxx: //lw
                begin 
                    //rs
                    if(EX_rs == MEM_writeReg && MEM_regWrite == 1 && MEM_writeReg != 0) begin
                        input1_sel = 2'b01;
                    end
                    else if(EX_rs == WB_writeReg && WB_regWrite == 1 && WB_writeReg != 0) begin
                        input1_sel = 2'b10;
                    end
                    else begin
                        input1_sel = 2'b00;
                    end
                    input2_sel = 2'b00;
                    sw_sel_reg = 2'b00;
                    jr_sel_reg = 2'b00;
                end
                12'b100100xxxxxx: //lbu
                begin 
                    //rs
                    if(EX_rs == MEM_writeReg && MEM_regWrite == 1 && MEM_writeReg != 0) begin
                        input1_sel = 2'b01;
                    end
                    else if(EX_rs == WB_writeReg && WB_regWrite == 1 && WB_writeReg != 0) begin
                        input1_sel = 2'b10;
                    end
                    else begin
                        input1_sel = 2'b00;
                    end
                    input2_sel = 2'b00;
                    sw_sel_reg = 2'b00;
                    jr_sel_reg = 2'b00;
                end
                12'b100101xxxxxx: //lhu
                begin 
                    //rs
                    if(EX_rs == MEM_writeReg && MEM_regWrite == 1 && MEM_writeReg != 0) begin
                        input1_sel = 2'b01;
                    end
                    else if(EX_rs == WB_writeReg && WB_regWrite == 1 && WB_writeReg != 0) begin
                        input1_sel = 2'b10;
                    end
                    else begin
                        input1_sel = 2'b00;
                    end
                    input2_sel = 2'b00;
                    sw_sel_reg = 2'b00;
                    jr_sel_reg = 2'b00;
                end
                12'b101011xxxxxx: //sw
                begin
                    //rs rt
                    //rs
                    if(EX_rs == MEM_writeReg && MEM_regWrite == 1 && MEM_writeReg != 0) begin
                        input1_sel = 2'b01;
                    end
                    else if(EX_rs == WB_writeReg && WB_regWrite == 1 && WB_writeReg != 0) begin
                        input1_sel = 2'b10;
                    end
                    else begin
                        input1_sel = 2'b00;
                    end
                    //rt-sw
                    if(EX_rt == MEM_writeReg && MEM_regWrite == 1 && MEM_writeReg != 0) begin
                        sw_sel_reg = 2'b01;
                    end
                    else if(EX_rt == WB_writeReg && WB_regWrite == 1 && WB_writeReg != 0) begin
                        sw_sel_reg = 2'b10;
                    end
                    else begin
                        sw_sel_reg = 2'b00;
                    end
                    input2_sel = 2'b00;
                    jr_sel_reg = 2'b00;
                end
                12'b101000xxxxxx: //sb
                begin
                    //rs rt
                    //rs
                    if(EX_rs == MEM_writeReg && MEM_regWrite == 1 && MEM_writeReg != 0) begin
                        input1_sel = 2'b01;
                    end
                    else if(EX_rs == WB_writeReg && WB_regWrite == 1 && WB_writeReg != 0) begin
                        input1_sel = 2'b10;
                    end
                    else begin
                        input1_sel = 2'b00;
                    end
                    //rt-sw
                    if(EX_rt == MEM_writeReg && MEM_regWrite == 1 && MEM_writeReg != 0) begin
                        sw_sel_reg = 2'b01;
                    end
                    else if(EX_rt == WB_writeReg && WB_regWrite == 1 && WB_writeReg != 0) begin
                        sw_sel_reg = 2'b10;
                    end
                    else begin
                        sw_sel_reg = 2'b00;
                    end
                    input2_sel = 2'b00;
                    jr_sel_reg = 2'b00;
                end
                12'b101001xxxxxx: //sh
                begin
                    //rs rt
                    //rs
                    if(EX_rs == MEM_writeReg && MEM_regWrite == 1 && MEM_writeReg != 0) begin
                        input1_sel = 2'b01;
                    end
                    else if(EX_rs == WB_writeReg && WB_regWrite == 1 && WB_writeReg != 0) begin
                        input1_sel = 2'b10;
                    end
                    else begin
                        input1_sel = 2'b00;
                    end
                    //rt-sw
                    if(EX_rt == MEM_writeReg && MEM_regWrite == 1 && MEM_writeReg != 0) begin
                        sw_sel_reg = 2'b01;
                    end
                    else if(EX_rt == WB_writeReg && WB_regWrite == 1 && WB_writeReg != 0) begin
                        sw_sel_reg = 2'b10;
                    end
                    else begin
                        sw_sel_reg = 2'b00;
                    end
                    input2_sel = 2'b00;
                    jr_sel_reg = 2'b00;
                end
                12'b000100xxxxxx: //beq
                begin
                    //rs rt
                    //rs
                    if(EX_rs == MEM_writeReg && MEM_regWrite == 1 && MEM_writeReg != 0) begin
                        input1_sel = 2'b01;
                    end
                    else if(EX_rs == WB_writeReg && WB_regWrite == 1 && WB_writeReg != 0) begin
                        input1_sel = 2'b10;
                    end
                    else begin
                        input1_sel = 2'b00;
                    end
                    //rt
                    if(EX_rt == MEM_writeReg && MEM_regWrite == 1 && MEM_writeReg != 0) begin
                        input2_sel = 2'b01;
                    end
                    else if(EX_rt == WB_writeReg && WB_regWrite == 1 && WB_writeReg != 0) begin
                        input2_sel = 2'b10;
                    end
                    else begin
                        input2_sel = 2'b00;
                    end
                    sw_sel_reg = 2'b00;
                    jr_sel_reg = 2'b00;
                end
                12'b000101xxxxxx: //bne new
                begin
                    //rs rt
                    //rs
                    if(EX_rs == MEM_writeReg && MEM_regWrite == 1 && MEM_writeReg != 0) begin
                        input1_sel = 2'b01;
                    end
                    else if(EX_rs == WB_writeReg && WB_regWrite == 1 && WB_writeReg != 0) begin
                        input1_sel = 2'b10;
                    end
                    else begin
                        input1_sel = 2'b00;
                    end
                    //rt
                    if(EX_rt == MEM_writeReg && MEM_regWrite == 1 && MEM_writeReg != 0) begin
                        input2_sel = 2'b01;
                    end
                    else if(EX_rt == WB_writeReg && WB_regWrite == 1 && WB_writeReg != 0) begin
                        input2_sel = 2'b10;
                    end
                    else begin
                        input2_sel = 2'b00;
                    end
                    sw_sel_reg = 2'b00;
                    jr_sel_reg = 2'b00;
                end
                12'b000000000000: //sll
                begin
                    //rt
                    if(EX_rt == MEM_writeReg && MEM_regWrite == 1 && MEM_writeReg != 0) begin
                        input2_sel = 2'b01;
                    end
                    else if(EX_rt == WB_writeReg && WB_regWrite == 1 && WB_writeReg != 0) begin
                        input2_sel = 2'b10;
                    end
                    else begin
                        input2_sel = 2'b00;
                    end
                    input1_sel = 2'b00;
                    sw_sel_reg = 2'b00;
                    jr_sel_reg = 2'b00;
                end
                12'b000000000010: //srl
                begin
                    //rt
                    if(EX_rt == MEM_writeReg && MEM_regWrite == 1 && MEM_writeReg != 0) begin
                        input2_sel = 2'b01;
                    end
                    else if(EX_rt == WB_writeReg && WB_regWrite == 1 && WB_writeReg != 0) begin
                        input2_sel = 2'b10;
                    end
                    else begin
                        input2_sel = 2'b00;
                    end
                    input1_sel = 2'b00;
                    sw_sel_reg = 2'b00;
                    jr_sel_reg = 2'b00;
                end
                12'b000000000011: //sra
                begin
                    //rt
                    if(EX_rt == MEM_writeReg && MEM_regWrite == 1 && MEM_writeReg != 0) begin
                        input2_sel = 2'b01;
                    end
                    else if(EX_rt == WB_writeReg && WB_regWrite == 1 && WB_writeReg != 0) begin
                        input2_sel = 2'b10;
                    end
                    else begin
                        input2_sel = 2'b00;
                    end
                    input1_sel = 2'b00;
                    sw_sel_reg = 2'b00;
                    jr_sel_reg = 2'b00;
                end
                12'b000000001000: //jr
                begin
                    //rs
                    if(EX_rs == MEM_writeReg && MEM_regWrite == 1 && MEM_writeReg != 0) begin
                        jr_sel_reg = 2'b01;
                    end
                    else if(EX_rs == WB_writeReg && WB_regWrite == 1 && WB_writeReg != 0) begin
                        jr_sel_reg = 2'b10;
                    end
                    else begin
                        jr_sel_reg = 2'b00;
                    end
                    input1_sel = 2'b00;
                    input2_sel = 2'b00;
                    sw_sel_reg = 2'b00;
                end
                12'b000000xxxxxx: //remaining r-type
                begin
                    //rs rt
                    //rs
                    if(EX_rs == MEM_writeReg && MEM_regWrite == 1 && MEM_writeReg != 0) begin
                        input1_sel = 2'b01;
                    end
                    else if(EX_rs == WB_writeReg && WB_regWrite == 1 && WB_writeReg != 0) begin
                        input1_sel = 2'b10;
                    end
                    else begin
                        input1_sel = 2'b00;
                    end
                    //rt
                    if(EX_rt == MEM_writeReg && MEM_regWrite == 1 && MEM_writeReg != 0) begin
                        input2_sel = 2'b01;
                    end
                    else if(EX_rt == WB_writeReg && WB_regWrite == 1 && WB_writeReg != 0) begin
                        input2_sel = 2'b10;
                    end
                    else begin
                        input2_sel = 2'b00;
                    end
                    sw_sel_reg = 2'b00;
                    jr_sel_reg = 2'b00;
                end
                12'b001000xxxxxx: //addi
                begin
                    //rs
                    if(EX_rs == MEM_writeReg && MEM_regWrite == 1 && MEM_writeReg != 0) begin
                        input1_sel = 2'b01;
                    end
                    else if(EX_rs == WB_writeReg && WB_regWrite == 1 && WB_writeReg != 0) begin
                        input1_sel = 2'b10;
                    end
                    else begin
                        input1_sel = 2'b00;
                    end
                    input2_sel = 2'b00;
                    sw_sel_reg = 2'b00;
                    jr_sel_reg = 2'b00;
                end
                12'b001001xxxxxx: //addiu new
                begin
                    //rs
                    if(EX_rs == MEM_writeReg && MEM_regWrite == 1 && MEM_writeReg != 0) begin
                        input1_sel = 2'b01;
                    end
                    else if(EX_rs == WB_writeReg && WB_regWrite == 1 && WB_writeReg != 0) begin
                        input1_sel = 2'b10;
                    end
                    else begin
                        input1_sel = 2'b00;
                    end
                    input2_sel = 2'b00;
                    sw_sel_reg = 2'b00;
                    jr_sel_reg = 2'b00;
                end
                12'b001111xxxxxx: //lui
                begin
                    input1_sel = 2'b00;
                    input2_sel = 2'b00;
                    sw_sel_reg = 2'b00;
                    jr_sel_reg = 2'b00;
                end
                12'b001010xxxxxx: //slti
                begin
                    //rs
                    if(EX_rs == MEM_writeReg && MEM_regWrite == 1 && MEM_writeReg != 0) begin
                        input1_sel = 2'b01;
                    end
                    else if(EX_rs == WB_writeReg && WB_regWrite == 1 && WB_writeReg != 0) begin
                        input1_sel = 2'b10;
                    end
                    else begin
                        input1_sel = 2'b00;
                    end
                    input2_sel = 2'b00;
                    sw_sel_reg = 2'b00;
                    jr_sel_reg = 2'b00;
                end
                12'b001011xxxxxx: //sltiu
                begin
                    //rs
                    if(EX_rs == MEM_writeReg && MEM_regWrite == 1 && MEM_writeReg != 0) begin
                        input1_sel = 2'b01;
                    end
                    else if(EX_rs == WB_writeReg && WB_regWrite == 1 && WB_writeReg != 0) begin
                        input1_sel = 2'b10;
                    end
                    else begin
                        input1_sel = 2'b00;
                    end
                    input2_sel = 2'b00;
                    sw_sel_reg = 2'b00;
                    jr_sel_reg = 2'b00;
                end
                12'b001100xxxxxx: //andi
                begin
                    //rs
                    if(EX_rs == MEM_writeReg && MEM_regWrite == 1 && MEM_writeReg != 0) begin
                        input1_sel = 2'b01;
                    end
                    else if(EX_rs == WB_writeReg && WB_regWrite == 1 && WB_writeReg != 0) begin
                        input1_sel = 2'b10;
                    end
                    else begin
                        input1_sel = 2'b00;
                    end
                    input2_sel = 2'b00;
                    sw_sel_reg = 2'b00;
                    jr_sel_reg = 2'b00;
                end
                12'b001101xxxxxx: //ori
                begin
                    //rs
                    if(EX_rs == MEM_writeReg && MEM_regWrite == 1 && MEM_writeReg != 0) begin
                        input1_sel = 2'b01;
                    end
                    else if(EX_rs == WB_writeReg && WB_regWrite == 1 && WB_writeReg != 0) begin
                        input1_sel = 2'b10;
                    end
                    else begin
                        input1_sel = 2'b00;
                    end
                    input2_sel = 2'b00;
                    sw_sel_reg = 2'b00;
                    jr_sel_reg = 2'b00;
                end
                12'b001110xxxxxx: //xori
                begin
                    //rs
                    if(EX_rs == MEM_writeReg && MEM_regWrite == 1 && MEM_writeReg != 0) begin
                        input1_sel = 2'b01;
                    end
                    else if(EX_rs == WB_writeReg && WB_regWrite == 1 && WB_writeReg != 0) begin
                        input1_sel = 2'b10;
                    end
                    else begin
                        input1_sel = 2'b00;
                    end
                    input2_sel = 2'b00;
                    sw_sel_reg = 2'b00;
                    jr_sel_reg = 2'b00;
                end
                12'b000011xxxxxx: //jal
                begin
                    input1_sel = 2'b00;
                    input2_sel = 2'b00;
                    sw_sel_reg = 2'b00;
                    jr_sel_reg = 2'b00;
                end
                12'b000010xxxxxx: //j
                begin
                    input1_sel = 2'b00;
                    input2_sel = 2'b00;
                    sw_sel_reg = 2'b00;
                    jr_sel_reg = 2'b00;
                end
                default:
                begin
                    input1_sel = 2'b00;
                    input2_sel = 2'b00;
                    sw_sel_reg = 2'b00;
                    jr_sel_reg = 2'b00;
                end
            endcase
        end
        
endmodule
