module Final(
    input clk,
    input rst,
    inout PS2_DATA,
    inout PS2_CLK,
    input [15:0] sw,
    input RxD,
    input echo,
    output PWM1,
    output PWM2,
    output PWM3,
    output PWM4,
    output reg [15:0] _led,
    output trig
);

    // motor's mode
    wire [1:0] mode1, mode2, mode3, mode4;

    // keyboard
    wire [511:0] key_down;
    wire [8:0] last_change;
    wire been_ready;

    // Receiver
    wire [7:0] RxData;
    wire ack;

    // led
    reg [15:0] next_led;

    // sonic
    wire [9:0] distance;
    assign sonic_en = (distance < 12) ? 1 : 0;
    wire [7:0] RxData_motor;
    assign RxData_motor = (ack) ? RxData : 8'b0;

    KeyboardDecoder key_de (
        .key_down(key_down),
        .last_change(last_change),
        .key_valid(been_ready),
        .PS2_DATA(PS2_DATA),
        .PS2_CLK(PS2_CLK),
        .rst(rst),
        .clk(clk)
    );

    Servo_interface A(
        .clk(clk),
        .rst(rst),
        .sw(sw),
        .mode1(mode1),
        .mode2(mode2),
        .mode3(mode3),
        .mode4(mode4),
        .PWM1(PWM1),
        .PWM2(PWM2),
        .PWM3(PWM3),
        .PWM4(PWM4)
        // .led(_led)
    );

    motor_controller B(
        .clk(clk),
        .rst(rst),
        .key_down(key_down),
        .last_change(last_change),
        .been_ready(been_ready),
        .RxData(RxData_motor),
        .switch(sw[15]),
        .sonic_en(sonic_en),
        .mode1(mode1),
        .mode2(mode2),
        .mode3(mode3),
        .mode4(mode4)
    );

    receiver C(
        .clk(clk),
        .rst(rst), 
        .RxD(RxD),
        .ack(ack),
        .RxData(RxData)
    );

    sonic_top D(
        .clk(clk),
        .rst(rst),
        .Echo(echo),
        .Trig(trig),
        .distance(distance)
    );
    
    // led
    always @(posedge clk) begin
        _led[15] <= next_led[15];
        _led[14] <= next_led[14];
        _led[7:0] <= next_led[7:0];
    end
    always @(*) begin
        // Uart signal
        if (ack) next_led[7:0] = RxData;
        else next_led[7:0] = _led[7:0];

        // keyboard control
        next_led[15] = sw[15];

        // sonic check
        next_led[14] = sonic_en;
    end

endmodule