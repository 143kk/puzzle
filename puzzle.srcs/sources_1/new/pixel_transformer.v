// 坐标变换

module pixel_transformer(
    // 拼图位置
    input [1:0] I_pos_a,
    input [1:0] I_pos_b,
    input [1:0] I_pos_c,
    input [1:0] I_pos_d,
    input [9:0] I_pixel_x,
    input [9:0] I_pixel_y,
    input I_EN, // high active
    //output [17:0] O_read_addr
    output [9:0] O_pixel_x,
    output [9:0] O_pixel_y
);
parameter C_PIC_WIDTH = 480;
parameter C_PIC_HEIGHT = 480;
parameter C_PIC_WIDTH_HALF = C_PIC_WIDTH / 2;
parameter C_PIC_HEIGHT_HALF = C_PIC_HEIGHT / 2;


assign O_pixel_x = ~I_EN ? 0 : (
    (I_pixel_x < C_PIC_WIDTH_HALF) ? (
        (I_pixel_y < C_PIC_HEIGHT_HALF) ? (
            // pos a
            I_pixel_x + (I_pos_a[0] ? C_PIC_WIDTH_HALF : 0)
        ) : (
            // pos c
            I_pixel_x + (I_pos_c[0] ? C_PIC_WIDTH_HALF : 0)
        )
    ):(
        (I_pixel_y < C_PIC_HEIGHT_HALF) ? (
            // pos b
            I_pixel_x - (I_pos_b[0] ? 0 : C_PIC_WIDTH_HALF)
        ) : (
            // pos d
            I_pixel_x - (I_pos_d[0] ? 0 : C_PIC_WIDTH_HALF)
        )
    )
);

assign O_pixel_y = ~I_EN ? 0 : (
    (I_pixel_x < C_PIC_WIDTH_HALF) ? (
        (I_pixel_y < C_PIC_HEIGHT_HALF) ? (
            // pos a
            (I_pixel_y + (I_pos_a[1] ? C_PIC_HEIGHT_HALF : 0))
        ) : (
            // pos c
            (I_pixel_y - (I_pos_c[1] ? 0 : C_PIC_HEIGHT_HALF))
        )
    ):(
        (I_pixel_y < C_PIC_HEIGHT_HALF) ? (
            // pos b
            (I_pixel_y + (I_pos_b[1] ? C_PIC_HEIGHT_HALF : 0))
        ) : (
            // pos d
            (I_pixel_y - (I_pos_d[1] ? 0 : C_PIC_HEIGHT_HALF))
        )
    )
);

// assign O_read_addr = ~I_EN ? 0 : (
//     (I_pixel_x < C_PIC_WIDTH_HALF) ? (
//         (I_pixel_y < C_PIC_HEIGHT_HALF) ? (
//             // pos a
//             (I_pixel_y + (I_pos_a[1] ? C_PIC_HEIGHT_HALF : 0)) * C_PIC_WIDTH + I_pixel_x + (I_pos_a[0] ? C_PIC_WIDTH_HALF : 0)
//         ) : (
//             // pos c
//             (I_pixel_y - (I_pos_c[1] ? 0 : C_PIC_HEIGHT_HALF)) * C_PIC_WIDTH + I_pixel_x + (I_pos_c[0] ? C_PIC_WIDTH_HALF : 0)
//             //(C_PIC_WIDTH * I_pixel_y) + I_pixel_x
//         )
//     ):(
//         (I_pixel_y < C_PIC_HEIGHT_HALF) ? (
//             // pos b
//             (I_pixel_y + (I_pos_b[1] ? C_PIC_HEIGHT_HALF : 0)) * C_PIC_WIDTH + I_pixel_x - (I_pos_b[0] ? 0 : C_PIC_WIDTH_HALF)
//         ) : (
//             // pos d
//             (I_pixel_y - (I_pos_d[1] ? 0 : C_PIC_HEIGHT_HALF)) * C_PIC_WIDTH + I_pixel_x - (I_pos_d[0] ? 0 : C_PIC_WIDTH_HALF)
//         )
//     )
// );
endmodule
