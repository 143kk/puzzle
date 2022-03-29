`timescale 1ns / 1ps
module led_music_control(
    input I_clk,
    input I_rst_n,
    input I_black_EN,
    input I_completed,
    input I_unsolvable,
    input I_music_on,
    output reg  O_led_on, 
    output reg  O_dir,
    output reg [4:0] mode   
);


always @(posedge I_clk, negedge I_rst_n) begin
    if((~I_rst_n) | (~I_black_EN)) begin
        mode <= 5'b00000;
        O_dir <= 0;
        O_led_on <= 0;

    end 
    else if((~I_completed) & (~I_unsolvable)) begin //�??启music1 --> 游戏�???
        if(I_music_on) mode <= 5'b10001; //17
        else mode <= 5'b00000;
        O_led_on <= (I_completed) | (I_unsolvable);

    end 
    else if(I_completed) begin //�??启music2 --> 游戏胜利 正向流水�???
        if(I_music_on) mode <= 5'b10010; //18
        else mode <= 5'b00000;
        O_dir <= 1;
        O_led_on <= (I_completed) | (I_unsolvable);

    end 
    else if(I_unsolvable) begin// �??启music3 --> 无解 反向流水�???
        if(I_music_on) mode <= 5'b10011; //19
        else mode <= 5'b00000;
        O_dir <= 0;
        O_led_on <= (I_completed) | (I_unsolvable);

    end
end


endmodule