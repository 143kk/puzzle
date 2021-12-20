// RGB444

module vga(
    input I_clk_25M,
    input I_rst_n,
    output reg [3:0] O_red,
    output reg [3:0] O_green,
    output reg [3:0] O_blue,
    output O_hs,
    output O_vs,

    input [11:0] I_pixel_data,
    output [9:0] O_pixel_x,
    output [9:0] O_pixel_y,
    output O_pixel_valid
    
);
    parameter   C_H_SYNC_PULSE      =   10'd96  , 
                C_H_BACK_PORCH      =   10'd48  ,
                C_H_ACTIVE_TIME     =   10'd640 ,
                C_H_FRONT_PORCH     =   10'd16  ,
                C_H_LINE_PERIOD     =   10'd800 ;
                
    parameter   C_V_SYNC_PULSE      =   10'd2   , 
                C_V_BACK_PORCH      =   10'd33  ,
                C_V_ACTIVE_TIME     =   10'd480 ,
                C_V_FRONT_PORCH     =   10'd10  ,
                C_V_FRAME_PERIOD    =   10'd525 ;

    reg [9:0] R_h_cnt;
    reg [9:0] R_v_cnt;

    wire W_active_flag;

    //行时序
    always @(posedge I_clk_25M or negedge I_rst_n) begin
        if(!I_rst_n) R_h_cnt <= 10'd0;
        else if(R_h_cnt == C_H_LINE_PERIOD - 1) R_h_cnt <= 10'd0;
        else R_h_cnt <= R_h_cnt + 1;
    end

    //场时序
    always @(posedge I_clk_25M or negedge I_rst_n) begin
        if(!I_rst_n) R_v_cnt <= 10'd0;
        else if (R_v_cnt == C_V_FRAME_PERIOD - 1) R_v_cnt <= 10'd0;
        else if (R_h_cnt == C_H_LINE_PERIOD - 1) R_v_cnt <= R_v_cnt + 1;
        else R_v_cnt <= R_v_cnt;
    end

    //行同步信号 & 场同步信号 低电平有效
    assign O_hs = (R_h_cnt < C_H_SYNC_PULSE) ? 1'b0 : 1'b1;
    assign O_vs = (R_v_cnt < C_V_SYNC_PULSE) ? 1'b0 : 1'b1;

    assign W_active_flag = (R_h_cnt >= (C_H_SYNC_PULSE + C_H_BACK_PORCH)) &&
                           (R_h_cnt < (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_H_ACTIVE_TIME)) &&
                           (R_v_cnt >= (C_V_SYNC_PULSE + C_V_BACK_PORCH)) &&
                           (R_v_cnt < (C_V_SYNC_PULSE + C_V_BACK_PORCH + C_V_ACTIVE_TIME));


    assign O_pixel_x = (R_h_cnt >= C_H_SYNC_PULSE + C_H_BACK_PORCH) ? (R_h_cnt - C_H_SYNC_PULSE - C_H_BACK_PORCH) : 0;
    assign O_pixel_y = (R_v_cnt >= C_V_SYNC_PULSE + C_V_BACK_PORCH) ? (R_v_cnt - C_V_SYNC_PULSE - C_V_BACK_PORCH) : 0;
    assign O_pixel_valid = W_active_flag;
    

    always @(posedge I_clk_25M, negedge I_rst_n) begin
        if(!I_rst_n) begin
            O_red <= 4'b0;
            O_green <= 4'b0;
            O_blue <= 4'b0;
        end
        else if(W_active_flag) begin
            O_blue <= I_pixel_data[3:0];
            O_green <= I_pixel_data[7:4];
            O_red <= I_pixel_data[11:8];                        
        end
        else begin
            O_red <= 4'b0;
            O_green <= 4'b0;
            O_blue <= 4'b0;
        end
    end

endmodule

