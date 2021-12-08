# Jigsaw puzzle on FPGA

待完善...

## Functions

- [x] 串口读图

- [x] VGA输出

- [x] 图像分块

- [x] 分块移动
- [x] 拉黑区块
- [x] 完成状态判断

## Future 

- [ ] 算法判断无解
- [ ] 计步器&计时器
- [ ] 区块拓展
- [ ] 防抖
- [ ] 图片画质升级(RGB332 to RGB444)

## Modules

- `top` - 顶层模块，实例化各种下级模块并和开发板端口关联

- `async_receiver` - 串口接收模块

- `vga` - VGA输出模块

- `pixel_ctrl` - 像素管理模块

- `pixel_transformer` - 像素转换模块，将拼图的像素映射到原图的像素

- `game_control` - 游戏模块，负责游戏的各种玩家操作

  ```verilog
  input [4:0] I_num, // a number present the permutation of puzzle blocks
  input I_clk, // clock signal
  input I_rst_n, // global reset signal
  input I_btn_set,  // 置位按钮
  input I_btn_left, // 向左
  input I_btn_right, 
  input I_btn_up, 
  input I_btn_down,
  output reg [1:0] O_pos_a, // a区块的对应的图片块
  output reg [1:0] O_pos_b,
  output reg [1:0] O_pos_c,
  output reg [1:0] O_pos_d,
  input I_black_EN, // 拉黑信号
  output O_completed // 拼图完成信号
  ```

- `permutation` - 拼图状态生成模块，根据数字生成拼图相应的区块排列

- `img_mem_ctrl` - 内存管理模块

### Bugs

- 移动区块的bug, 不好描述，正在修
- 图片分割有瑕疵