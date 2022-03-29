    `timescale 1ns / 1ps
    module check (
        input [3:0] IA,
        input [3:0] IB,
        input [3:0] IC,
        input [3:0] ID,
        //是否开启3*3
        input hard,
        input I_clk,
        input I_black_EN,
        input I_rst_n,
        output reg O_hasSolution
    );

    always @(posedge I_clk,negedge I_rst_n) begin
        if(~I_rst_n) begin
            O_hasSolution <= 1'b0;
        end
        else if(hard) begin
            O_hasSolution <= 1'b1;
        end
        else if(I_black_EN) begin
            case ({IA[1:0],IB[1:0],IC[1:0],ID[1:0]})
                16'b00_01_10_11 : O_hasSolution <= 1'b1;//1234
                16'b10_00_11_01 : O_hasSolution <= 1'b1;//3142
                16'b11_00_10_01 : O_hasSolution <= 1'b1;//4132
                16'b00_01_11_10 : O_hasSolution <= 1'b1;//1243
                16'b00_10_11_01 : O_hasSolution <= 1'b1;//1342
                16'b11_00_01_10 : O_hasSolution <= 1'b1;//4123
                16'b01_11_10_00 : O_hasSolution <= 1'b1;//2431
                16'b10_11_01_00 : O_hasSolution <= 1'b1;//3421
                16'b11_10_01_00 : O_hasSolution <= 1'b1;//4321
                16'b01_11_00_10 : O_hasSolution <= 1'b1;//2413
                16'b01_10_00_11 : O_hasSolution <= 1'b1;//2314
                16'b10_01_00_11 : O_hasSolution <= 1'b1;//3214

                default: O_hasSolution <= 1'b0;
            endcase
            
        end
        else  O_hasSolution <= 1'b0;
    end
        
    endmodule