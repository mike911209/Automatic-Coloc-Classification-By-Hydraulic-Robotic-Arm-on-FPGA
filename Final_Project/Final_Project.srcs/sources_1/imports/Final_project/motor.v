module Servo_interface (
    input clk,
    input rst,
    input [15:0] sw,
    input [1:0] mode1,
    input [1:0] mode2,
    input [1:0] mode3,
    input [1:0] mode4,
    output PWM1,
    output PWM2,
    output PWM3,
    output PWM4
);

    // control refresh rate
    wire [24:0] counter;

    // control speed of motors
    // wire [3:0] speed1;
    // wire [3:0] speed2;
    // wire [3:0] speed3;
    // wire [3:0] speed4;

    // control duty cycle of motors
    wire [24:0] value1;
    wire [24:0] value2;
    wire [24:0] value3;
    wire [24:0] value4;

    // refresh rate counter
    counter count(
        .clk(clk),
        .rst(rst),
        .counter(counter)
    );
    
    // motor 1
    speed_control control1(
        .mode(mode1),
        .value(value1)
    );
    comparator compare1(
        .value(value1),
        .counter(counter),
        .PWM(PWM1)
    );

    // motor 2
    speed_control control2(
        .mode(mode2),
        .value(value2)
    );
    comparator compare2(
        .value(value2),
        .counter(counter),
        .PWM(PWM2)
    );

    // motor 3
    speed_control control3(
        .mode(mode3),
        .value(value3)
    );
    comparator compare3(
        .value(value3),
        .counter(counter),
        .PWM(PWM3)
    );

    // motor 4
    speed_control_motor4 control4(
        .mode(mode4),
        .value(value4)
    );
    comparator compare4(
        .value(value4),
        .counter(counter),
        .PWM(PWM4)
    );
        
endmodule

// count the refresh rate, current is 20ms
module counter (
    input clk, 
    input rst, 
    output reg [24:0] counter
);
    always @(posedge clk, posedge rst) begin
        if (rst || counter == 25'd200_0000) counter <= 0;
        else counter <= counter + 1;
    end
endmodule

// convert switch to speed
module sw_to_speed (
    input [15:0] sw,
    output reg [3:0] speed
);
    always @(*) begin
        // cloclwise
        if (sw[1] == 1) speed = 1;
        else if (sw[2] == 1) speed = 2;
        else if (sw[3] == 1) speed = 3;
        else if (sw[4] == 1) speed = 4;
        else if (sw[5] == 1) speed = 5;
        // counter clockwise
        else if (sw[6] == 1) speed = 6;
        else if (sw[7] == 1) speed = 7;
        else if (sw[8] == 1) speed = 8;
        else if (sw[9] == 1) speed = 9;
        else if (sw[10] == 1) speed = 10;
        // stop
        else speed = 0;
    end
endmodule

// input 0~15, output the duty cycle of PWM
module speed_control (
    input [1:0] mode,
    // input [3:0] speed,
    output reg [24:0] value
);
    always @(*) begin
        case (mode)
            2'b00: value = 25'd15_0000;
            2'b01: value = 25'd10_0000;
            2'b10: value = 25'd20_0000;
            default: value = 25'd15_0000;
        endcase
    end
endmodule

// same as speed control but slower
module speed_control_motor4 (
    input [1:0] mode,
    // input [3:0] speed,
    output reg [24:0] value
);
    always @(*) begin
        case (mode)
            2'b00: value = 25'd15_0000;
            2'b01: value = 25'd14_0000;
            2'b10: value = 25'd16_0000;
            default: value = 25'd15_0000;
        endcase
    end
endmodule

// compare to output PWM
module comparator (
    input [24:0] value,
    input [24:0] counter,
    output reg PWM
);
    always @(*) begin
        if (counter < value) PWM <= 1;
        else PWM <= 0;
    end
endmodule