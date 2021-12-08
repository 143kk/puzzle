module tb_mem_ctrl();

reg clk, reset;
initial begin
    clk = 10;
    reset = 0;
    #10 reset = 1;
    forever #5 clk = ~clk;
end

wire [7:0] pixel_data;
reg [9:0] pixel_x;
reg [9:0] pixel_y;


reg rx_data_ready;
reg [7:0] rx_datax;

reg read_en;

reg [17:0] cnt;

initial begin
    rx_datax = 8'b11111111;
    rx_data_ready = 1;
end

initial begin
    #3000
    read_en = 1;
    pixel_x = 0;
    pixel_y = 0;
    while(pixel_y < 10'd480) begin
        pixel_x = 0;
        while(pixel_x < 10'd480) begin
            #5 pixel_x = pixel_x + 1;
        end
        pixel_y = pixel_y + 1;
    end
    $finish();
end


img_mem_ctrl imc_inst(
    .I_clk(clk),
    .I_rst_n(reset),
    .I_vga_clk(clk),
    .I_read_en(read_en),
    .I_pixel_x(pixel_x),
    .I_pixel_y(pixel_y),
    .O_pixel_data(pixel_data),
    .I_write_en(rx_data_ready),
    .I_write_data(rx_datax)
);

endmodule