`timescale 1ns / 1ps

module Music(input clk, input wire[4:0] mode, output reg[0:0] music = 0, output reg[6:0] O_led);

parameter do_low = 191110;
parameter re_low = 170259;
parameter me_low = 151685;
parameter fa_low = 143172;
parameter so_low = 127554;
parameter la_low = 113636;
parameter si_low = 101239;

parameter do = 93941;
parameter re = 85136;
parameter me = 75838;
parameter fa = 71582;
parameter so = 63776;
parameter la = 56818;
parameter si = 50618;

parameter do_high = 47778;
parameter re_high = 42567;
parameter me_high = 37921;
parameter fa_high = 36498;
parameter so_high = 31888;
parameter la_high = 28409;
parameter si_high = 25309;

parameter beat = 40 * 500000;
parameter gap =  10 * 500000;
parameter index_period = beat + gap;

parameter silence = beat<<9;

/*
0 - silence 
1 - 7 low
8 - 14 meidum
15 - 21 high
*/  
parameter Star = 420'b000000100000000010010000001001000000101000000010100000001011000000101100000011000000001101000000110100000011000000001100000000100000000010000000001001000000101000000010100000001011000000101100000011000000001100000000100100000010100000001010000000101100000010110000001100000000110000000010000000001001000000100100000010100000001010000000101100000010110000001100000000110100000011010000001100000000110000000010000000001000;
parameter Noise = 210'b010000100101001010100101001011010110110001101011010110001100010000100001001010100101001011010110110001100010010101001010010110101101100011000100001001010010101001010010110101101100011010110101100011000100001000;
parameter MerryChristmas = 335'b01111011110111101110100000110101100011001001101111100001000110000000000110001100011010111001111011100000001110011110111101111011000000001111011110111010000011010110001100000000110101111100001000110010100011000100000011000110000000011000111001111100001000110000100000000001101000000000001101011010111001111100000111101111000000110001100;

parameter ST_length = 84;
parameter NO_length = 42;
parameter MC_length = 67;

reg[29:0] freq =  beat;

reg[2000:0] melody = 0;
integer melody_length = 0;

integer frequency_count = 0;      // count1 control frequency
integer index_count = 0;      // count2 control beat;

integer index = 0;       // index control the location music playing

reg [0:0] isSilence = 0; 
reg [0:0] isEnd = 0;
reg [0:0] isPeriodic = 0;

reg[4:0] last_mode = 0;


always @(posedge clk) begin
    
    if(mode != last_mode) begin
        last_mode = mode;
        isEnd = 0;
        index = 0;
        index_count = 0;
        
        if(mode >= 17) isPeriodic = 1;
        else begin isPeriodic = 0; melody_length = 1; end
        
        if(mode == 17) melody_length = MC_length;
        if(mode == 18) melody_length = ST_length;
        if(mode == 19) melody_length = NO_length;
       
        case(mode)
            17: melody = MerryChristmas;
            18: melody = Star;
            19: melody = Noise;
            default : melody = mode;
        endcase
       
    end


    if(frequency_count >= freq) begin
        frequency_count = 0;
        music = ~music;
    end
    else frequency_count = frequency_count + 1;
        
    if(index_count > index_period) begin
        index_count = 0;
        index = index + 1;
        if(index > melody_length && isPeriodic) begin
            isEnd = 0;
            index = 0;
        end
        if(index > melody_length && !isPeriodic) begin
            index = 0;
            isEnd = 1;
        end
    end
    
    index_count = index_count + 1;
    
end



always @ * begin
if(isEnd)
freq = silence;
else
case(melody[index * 5 +4 -:5])
5'd0 : freq = silence;
5'd1 : freq = do_low;
5'd2 : freq = re_low;
5'd3 : freq = me_low;
5'd4 : freq = fa_low;
5'd5 : freq = so_low;
5'd6 : freq = la_low;
5'd7 : freq = si_low;
5'd8 : freq = do;
5'd9 : freq = re;
5'd10 : freq = me;
5'd11: freq = fa;
5'd12 : freq = so;
5'd13 : freq = la;
5'd14 : freq = si;
5'd15 : freq = do_high;
5'd16 : freq = re_high;
5'd17 : freq = me_high;
5'd18 : freq = fa_high;
5'd19 : freq = so_high;
5'd20 : freq = la_high;
5'd21 : freq = si_high;
default : freq = silence;
endcase
end

always @(freq) begin
    case(freq)
    silence : O_led = 7'b0000_000;
    do_low  : O_led = 7'b0000_001;
    re_low  : O_led = 7'b0000_010;
    me_low  : O_led = 7'b0000_100;
    fa_low  : O_led = 7'b0001_000;
    so_low  : O_led = 7'b0010_000;
    la_low  : O_led = 7'b0100_000;
    si_low  : O_led = 7'b1000_000;

    do      : O_led = 7'b0000_001;
    re      : O_led = 7'b0000_010;
    me      : O_led = 7'b0000_100;
    fa      : O_led = 7'b0001_000;
    so      : O_led = 7'b0010_000;
    la      : O_led = 7'b0100_000;
    si      : O_led = 7'b1000_000;
    
    do_high : O_led = 7'b0000_001;
    re_high : O_led = 7'b0000_010;
    me_high : O_led = 7'b0000_100;
    fa_high : O_led = 7'b0001_000;
    so_high : O_led = 7'b0010_000;
    la_high : O_led = 7'b0100_000;
    si_high : O_led = 7'b1000_000;
    default : O_led = 7'b0000_000;
    endcase
end



endmodule

