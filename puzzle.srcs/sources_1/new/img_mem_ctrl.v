module img_mem_ctrl(
    input I_clk_25M,
    input I_rst_n,
    input I_write_en, //写入数据的使能信号
    input I_read_en, //读取数据的使能信号
    input [7:0] I_write_data, //要写入的数据
    input [17:0] I_read_addr,
    output reg [7:0] O_pixel_data
);
    parameter C_PIC_WIDTH = 480;
    parameter C_PIC_HEIGHT = 480;    
    localparam C_PIC_DEPTH = C_PIC_WIDTH * C_PIC_HEIGHT;

    //写入的地址
    reg [17:0] R_write_addr; 
    always @(posedge I_clk_25M, negedge I_rst_n) begin
        if(!I_rst_n) R_write_addr <= 0;
        else if(I_write_en) begin
            if(R_write_addr == C_PIC_DEPTH - 1) R_write_addr <= 0;
            else R_write_addr <= R_write_addr+1;
        end
    end

    wire [7:0] W_read_data;
    always @(posedge I_clk_25M, negedge I_rst_n) begin
        if(~I_rst_n) 
            O_pixel_data <= 0;
        // else if(~I_read_en)
        //     O_pixel_data <= 0;
        else
            O_pixel_data <= W_read_data;
    end

    img_mem img_mem(
        .clka(I_clk_25M), 
        .addra(R_write_addr),
        .dina(I_write_data),
        .ena(I_write_en),
        .wea(1'b1),

        .clkb(I_clk_25M),
        .addrb(I_read_addr),
        .doutb(W_read_data)
    );
    // blk_mem_gen_0 blk_mem_gen_0(
    //     .clka(I_clk),
    //     .addra(read_addr),
    //     .douta(W_read_data)
    // );
endmodule