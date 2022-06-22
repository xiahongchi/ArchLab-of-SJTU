`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/17 08:50:54
// Design Name: 
// Module Name: Cache_Line
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


module Cache_Line(
    input Clk,
    input reset,
    input [31:0] Address,
    input [31:0] WriteData,
    input MemWrite,
    input MemRead,
    input [1:0] MByte,
    output [31:0] ReadData
    );
    
    // Assume that A Cache Block is 8 bytes = 2 words
    // We have 2 blocks in the cached memory
    // The entry of the cache is as followed: totally 69 bits per entry
    // |-----------8 bytes/64 bits(cached data)-----------|----4bits(addr)----|--1bit(valid)--|
    // |0...............................................63|64...............67|.......68......|
    reg [68:0] CacheData [0:1];
    reg [31:0] rd;
    
    // Cache is connected to Main Memory: 
    // We apply *write-through* and *write-allocate* policy
    reg [31:0] Main_Address;
    reg [31:0] Main_MemWriteData;
    wire [31:0] Main_ReadData;
    reg Main_MemWrite;
    reg Main_MemRead;
    reg [1:0] Main_MByte;
    DataMemory DataMemory(
        .Clk(Clk),
        .Address(Main_Address),
        .WriteData(Main_MemWriteData),
        .MemWrite(Main_MemWrite),
        .MemRead(Main_MemRead),
        .MByte(Main_MByte),
        .ReadData(Main_ReadData)
    );
    
    // Read and write cache in the positve edge
    // If substitution is needed, just alternately replace.
    integer ptr;
    always @(posedge Clk) begin
        if(MemRead == 1) begin
            //read hit
            if(CacheData[0][68] == 1 && CacheData[0][67:64] == Address[4:1]) begin
                if(Address[0] == 0) rd = CacheData[0][31:0];
                else if(Address[0] == 1) rd = CacheData[0][63:32];
            end
            else if(CacheData[1][68] == 1 && CacheData[1][67:64] == Address[4:1]) begin
                if(Address[0] == 0) rd = CacheData[1][31:0];
                else if(Address[0] == 1) rd = CacheData[1][63:32];
            end
            //read miss
            else begin
                //cold cache:
                if(CacheData[0][68] == 0) begin
                    CacheData[0][67:64] = Address[4:1];
                    CacheData[0][68] = 1;
                    // Reading from memory:
                    Main_MemRead = 1;
                    Main_Address = {Address[31:1],1'b0};
                    #2;//wait for reading
                    CacheData[0][31:0] = Main_ReadData;
                    Main_Address = {Address[31:1],1'b1};
                    #2;//wait for reading
                    CacheData[0][63:32] = Main_ReadData;
                    Main_MemRead = 0;
                    // read from cache:
                    if(Address[0] == 0) rd = CacheData[0][31:0];
                    else if(Address[0] == 1) rd = CacheData[0][63:32];
                end
                else if(CacheData[1][68] == 0) begin
                    CacheData[1][67:64] = Address[4:1];
                    CacheData[1][68] = 1;
                    // Reading from memory:
                    Main_MemRead = 1;
                    Main_Address = {Address[31:1],1'b0};
                    #2;//wait for reading
                    CacheData[1][31:0] = Main_ReadData;
                    Main_Address = {Address[31:1],1'b1};
                    #2;//wait for reading
                    CacheData[1][63:32] = Main_ReadData;
                    Main_MemRead = 0;
                    // read from cache:
                    if(Address[0] == 0) rd = CacheData[1][31:0];
                    else if(Address[0] == 1) rd = CacheData[1][63:32];
                end
                //after warm-up
                else begin
                    CacheData[ptr][67:64] = Address[4:1];
                    // Reading from memory:
                    Main_MemRead = 1;
                    Main_Address = {Address[31:1],1'b0};
                    #2;//wait for reading
                    CacheData[ptr][31:0] = Main_ReadData;
                    Main_Address = {Address[31:1],1'b1};
                    #2;//wait for reading
                    CacheData[ptr][63:32] = Main_ReadData;
                    Main_MemRead = 0;
                    // read from cache:
                    if(Address[0] == 0) rd = CacheData[ptr][31:0];
                    else if(Address[0] == 1) rd = CacheData[ptr][63:32];
                    //update ptr
                    ptr = (ptr + 1) % 2;
                end
            end
            Main_MemWrite = 0; // Don't write in this cycle.
        end
        else if(MemWrite == 1) begin
            //write hit
            if(CacheData[0][68] == 1 && CacheData[0][67:64] == Address[4:1]) begin
                if(Address[0] == 0) begin
                    case(MByte)
                        2'b00: CacheData[0][31:0] = WriteData;
                        2'b01: CacheData[0][15:0] = WriteData[15:0];
                        2'b10: CacheData[0][7:0] = WriteData[7:0];
                        default: CacheData[0][31:0] = WriteData;
                    endcase 
                end
                else if(Address[0] == 1) begin
                    case(MByte)
                        2'b00: CacheData[0][63:32] = WriteData;
                        2'b01: CacheData[0][47:32] = WriteData[15:0];
                        2'b10: CacheData[0][39:32] = WriteData[7:0];
                        default: CacheData[0][63:32] = WriteData;
                    endcase 
                end
            end
            else if(CacheData[1][68] == 1 && CacheData[1][67:64] == Address[4:1]) begin
                if(Address[0] == 0) begin
                    case(MByte)
                        2'b00: CacheData[1][31:0] = WriteData;
                        2'b01: CacheData[1][15:0] = WriteData[15:0];
                        2'b10: CacheData[1][7:0] = WriteData[7:0];
                        default: CacheData[1][31:0] = WriteData;
                    endcase 
                end
                else if(Address[0] == 1) begin
                    case(MByte)
                        2'b00: CacheData[1][63:32] = WriteData;
                        2'b01: CacheData[1][47:32] = WriteData[15:0];
                        2'b10: CacheData[1][39:32] = WriteData[7:0];
                        default: CacheData[1][63:32] = WriteData;
                    endcase 
                end
            end
            //write miss
            //apply write-allocate
            else begin
                //cold cache:
                if(CacheData[0][68] == 0) begin
                    CacheData[0][67:64] = Address[4:1];
                    CacheData[0][68] = 1;
                    //first read from main memory:
                    Main_MemRead = 1;
                    Main_Address = {Address[31:1],1'b0};
                    #2;//wait for reading
                    CacheData[0][31:0] = Main_ReadData;
                    Main_Address = {Address[31:1],1'b1};
                    #2;//wait for reading
                    CacheData[0][63:32] = Main_ReadData;
                    Main_MemRead = 0;
                    //then write the cache memory:
                    if(Address[0] == 0) begin
                        case(MByte)
                            2'b00: CacheData[0][31:0] = WriteData;
                            2'b01: CacheData[0][15:0] = WriteData[15:0];
                            2'b10: CacheData[0][7:0] = WriteData[7:0];
                            default: CacheData[0][31:0] = WriteData;
                        endcase 
                    end
                    else if(Address[0] == 1) begin
                        case(MByte)
                            2'b00: CacheData[0][63:32] = WriteData;
                            2'b01: CacheData[0][47:32] = WriteData[15:0];
                            2'b10: CacheData[0][39:32] = WriteData[7:0];
                            default: CacheData[0][63:32] = WriteData;
                        endcase 
                    end
                    //finally write to the main memory at the negative edge of clk
                end
                else if(CacheData[1][68] == 0) begin
                    CacheData[1][67:64] = Address[4:1];
                    CacheData[1][68] = 1;
                    //first read from main memory:
                    Main_MemRead = 1;
                    Main_Address = {Address[31:1],1'b0};
                    #2;//wait for reading
                    CacheData[1][31:0] = Main_ReadData;
                    Main_Address = {Address[31:1],1'b1};
                    #2;//wait for reading
                    CacheData[1][63:32] = Main_ReadData;
                    Main_MemRead = 0;
                    //then write the cache memory:
                    if(Address[0] == 0) begin
                        case(MByte)
                            2'b00: CacheData[1][31:0] = WriteData;
                            2'b01: CacheData[1][15:0] = WriteData[15:0];
                            2'b10: CacheData[1][7:0] = WriteData[7:0];
                            default: CacheData[1][31:0] = WriteData;
                        endcase 
                    end
                    else if(Address[0] == 1) begin
                        case(MByte)
                            2'b00: CacheData[1][63:32] = WriteData;
                            2'b01: CacheData[1][47:32] = WriteData[15:0];
                            2'b10: CacheData[1][39:32] = WriteData[7:0];
                            default: CacheData[1][63:32] = WriteData;
                        endcase 
                    end
                    //finally write to the main memory at the negative edge of clk
                end
                //after warm-up
                else begin
                    //substitute
                    CacheData[ptr][67:64] = Address[4:1];
                    // Reading from memory:
                    Main_MemRead = 1;
                    Main_Address = {Address[31:1],1'b0};
                    #2;//wait for reading
                    CacheData[ptr][31:0] = Main_ReadData;
                    Main_Address = {Address[31:1],1'b1};
                    #2;//wait for reading
                    CacheData[ptr][63:32] = Main_ReadData;
                    Main_MemRead = 0;
                    //then write the cache memory:
                    if(Address[0] == 0) begin
                        case(MByte)
                            2'b00: CacheData[ptr][31:0] = WriteData;
                            2'b01: CacheData[ptr][15:0] = WriteData[15:0];
                            2'b10: CacheData[ptr][7:0] = WriteData[7:0];
                            default: CacheData[ptr][31:0] = WriteData;
                        endcase 
                    end
                    else if(Address[0] == 1) begin
                        case(MByte)
                            2'b00: CacheData[ptr][63:32] = WriteData;
                            2'b01: CacheData[ptr][47:32] = WriteData[15:0];
                            2'b10: CacheData[ptr][39:32] = WriteData[7:0];
                            default: CacheData[ptr][63:32] = WriteData;
                        endcase 
                    end
                    //update ptr
                    ptr = (ptr + 1) % 2;
                    //finally write to the main memory at the negative edge of clk
                end
            end
            //write through to main memory at the negative edge of clk
            Main_MemWrite = 1;
            Main_Address = Address;
            Main_MemWriteData = WriteData;
            Main_MByte = MByte;
        end
        else begin
            Main_MemRead = 0;
            Main_MemWrite = 0;
        end
    end
    
    assign ReadData = rd;
    
    // the negative edge
    always @(negedge Clk) begin
        //Main memory is responsible for writing at this time...
    end
    
    always @(posedge reset)
        begin
            CacheData[0] = 0;
            CacheData[1] = 0;
            ptr = 0;
            Main_MemWrite = 0;
            Main_MemRead = 0;
        end
endmodule
