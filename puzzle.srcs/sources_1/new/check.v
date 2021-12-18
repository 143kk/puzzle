`timescale 1ns / 1ps
module check (
    input [1:0] IA,
    input [1:0] IB,
    input [1:0] IC,
    input [1:0] ID,
    input I_clk,
    input I_black_EN,
    input I_rst_n,
    output reg O_hasSolution
);

always @(posedge I_clk,negedge I_rst_n) begin
    if(~I_rst_n) begin
        O_hasSolution <= 1'b0;
    end
    else if(I_black_EN) begin
        case ({IA,IB,IC,ID})
            8'b10_00_11_01 : O_hasSolution <= 1'b1;
            8'b11_10_01_00 : O_hasSolution <= 1'b1;
            8'b01_11_00_10 : O_hasSolution <= 1'b1;
            default: O_hasSolution <= 1'b0;
        endcase
        
    end
    else  O_hasSolution <= 1'b0;
end
    
endmodule