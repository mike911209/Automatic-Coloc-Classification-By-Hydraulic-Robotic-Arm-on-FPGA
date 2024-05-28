module motor_controller (
    input clk,
    input rst,
    input [511:0] key_down,
    input [8:0] last_change,
    input been_ready,
    input [7:0] RxData,
    input switch,
    input sonic_en,
    output reg [1:0] mode1,
    output reg [1:0] mode2,
    output reg [1:0] mode3,
    output reg [1:0] mode4
);

    parameter STOP = 2'b00;
    parameter CLOCKWISE = 2'b01;
    parameter COUNTER_CLOCKWISE = 2'b10;

    reg [1:0] next_mode1, next_mode2, next_mode3, next_mode4;

    reg [20:0] counter1, next_counter1;
    reg [15:0] counter2, next_counter2;
    reg [15:0] counter3, next_counter3;
    reg [15:0] counter4, next_counter4;

    reg [16:0] counter_count, next_counter_count;

    reg [1:0] state, next_state;
    parameter NONE = 2'b00;
    parameter RED = 2'b01;
    parameter BLACK = 2'b10;
    parameter BLUE = 2'b11;

    parameter RED_DATA = 8'h41;
    parameter BLACK_DATA = 8'h42;
    parameter BLUE_DATA = 8'h43;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            mode1 <= 2'b00;
            mode2 <= 2'b00;
            mode3 <= 2'b00;
            mode4 <= 2'b00;
            counter1 <= 0;
            counter2 <= 0;
            counter3 <= 0;
            counter4 <= 0;
            counter_count <= 0;
            state <= NONE;
        end else begin
            mode1 <= next_mode1;
            mode2 <= next_mode2;
            mode3 <= next_mode3;
            mode4 <= next_mode4;
            counter1 <= next_counter1;
            counter2 <= next_counter2;
            counter3 <= next_counter3;
            counter4 <= next_counter4;
            counter_count <= next_counter_count;
            state <= next_state;
        end
    end
    always @(*) begin
        if (switch) begin
            // keyboard control
            next_state = NONE;
            next_counter_count = 0;

            // motor 1
            if (counter1 == 0) begin
                if (been_ready && key_down[9'b0_0001_0101] == 1) begin
                    // press Q
                    next_counter1 = 1;
                    next_mode1 = 2'b01;
                end else if (been_ready && key_down[9'b0_0001_1101] == 1) begin
                    // press W
                    next_counter1 = 1;
                    next_mode1 = 2'b10;
                end else begin
                    next_counter1 = 0;
                    next_mode1 = 2'b00;
                end
            end else begin
                if (counter1[15] == 1) begin
                    if (mode1 == 2'b01 && key_down[9'b0_0001_0101] == 1) begin
                        // press Q
                        next_counter1 = 1;
                        next_mode1 = 2'b01;
                    end else if (mode1 == 2'b10 && key_down[9'b0_0001_1101] == 1) begin
                        // press W
                        next_counter1 = 1;
                        next_mode1 = 2'b10;
                    end else begin
                        next_counter1 = 0;
                        next_mode1 = 2'b00;
                    end
                end else begin
                    next_mode1 = mode1;
                    next_counter1 = counter1 + 1;
                end
            end

            // motor 2
            if (counter2 == 0) begin
                if (been_ready && key_down[9'b0_0001_1100] == 1) begin
                    // press A
                    next_counter2 = 1;
                    next_mode2 = 2'b01;
                end else if (been_ready && key_down[9'b0_0001_1011] == 1) begin
                    // press S
                    next_counter2 = 1;
                    next_mode2 = 2'b10;
                end else begin
                    next_counter2 = 0;
                    next_mode2 = 2'b00;
                end
            end else begin
                if (counter2[15] == 1) begin
                    if (mode2 == 2'b01 && key_down[9'b0_0001_1100] == 1) begin
                        // press A
                        next_counter2 = 1;
                        next_mode2 = 2'b01;
                    end else if (mode2 == 2'b10 && key_down[9'b0_0001_1011] == 1) begin
                        // press S
                        next_counter2 = 1;
                        next_mode2 = 2'b10;
                    end else begin
                        next_counter2 = 0;
                        next_mode2 = 2'b00;
                    end
                end else begin
                    next_mode2 = mode2;
                    next_counter2 = counter2 + 1;
                end
            end

            // motor 3
            if (counter3 == 0) begin
                if (been_ready && key_down[9'b0_0001_1010] == 1) begin
                    // press Z
                    next_counter3 = 1;
                    next_mode3 = 2'b01;
                end else if (been_ready && key_down[9'b0_0010_0010] == 1) begin
                    // press X
                    next_counter3 = 1;
                    next_mode3 = 2'b10;
                end else begin
                    next_counter3 = 0;
                    next_mode3 = 2'b00;
                end
            end else begin
                if (counter3[15] == 1) begin
                    if (mode3 == 2'b01 && key_down[9'b0_0001_1010] == 1) begin
                        // press Z
                        next_counter3 = 1;
                        next_mode3 = 2'b01;
                    end else if (mode3 == 2'b10 && key_down[9'b0_0010_0010] == 1) begin
                        // press X
                        next_counter3 = 1;
                        next_mode3 = 2'b10;
                    end else begin
                        next_counter3 = 0;
                        next_mode3 = 2'b00;
                    end
                end else begin
                    next_mode3 = mode3;
                    next_counter3 = counter3 + 1;
                end
            end

            // motor 4
            if (counter4 == 0) begin
                if (been_ready && key_down[9'b0_0001_0110] == 1) begin
                    // press Z
                    next_counter4 = 1;
                    next_mode4 = 2'b01;
                end else if (been_ready && key_down[9'b0_0001_1110] == 1) begin
                    // press X
                    next_counter4 = 1;
                    next_mode4 = 2'b10;
                end else begin
                    next_counter4 = 0;
                    next_mode4 = 2'b00;
                end
            end else begin
                if (counter4[15] == 1) begin
                    if (mode4 == 2'b01 && key_down[9'b0_0001_0110] == 1) begin
                        // press Z
                        next_counter4 = 1;
                        next_mode4 = 2'b01;
                    end else if (mode4 == 2'b10 && key_down[9'b0_0001_1110] == 1) begin
                        // press X
                        next_counter4 = 1;
                        next_mode4 = 2'b10;
                    end else begin
                        next_counter4 = 0;
                        next_mode4 = 2'b00;
                    end
                end else begin
                    next_mode4 = mode4;
                    next_counter4 = counter4 + 1;
                end
            end
        end else begin
            // Uart control
            next_counter2 = 0;
            next_counter3 = 0;
            next_counter4 = 0;
            next_mode1 = STOP;
            next_mode2 = STOP;
            next_mode3 = STOP;
            next_mode4 = STOP;
            next_counter_count = counter_count;
            
            if (state == NONE) begin
                if (sonic_en && RxData == RED_DATA) begin
                    // red
                    next_state = RED;
                    next_counter1 = 1;
                end else if (sonic_en && RxData == BLACK_DATA) begin
                    // black
                    next_state = BLACK;
                    next_counter1 = 1;
                end else if (sonic_en && RxData == BLUE_DATA) begin
                    // blue
                    next_state = BLUE;
                    next_counter1 = 1;
                end else begin
                    // others
                    next_state = NONE;
                    next_counter1 = 0;
                end
            end else begin
                if (counter1[19] == 1) begin
                    next_counter_count = counter_count + 1;
                    next_counter1 = 0;
                end else begin
                    next_counter_count = counter_count;
                    next_counter1 = counter1 + 1;
                end 
                next_state = state;

                // if (counter_count < 1700) begin
                //     next_mode3 = 2'b10;
                // end else if (counter_count < 15'd4800) begin
                //     next_mode1 = 2'b10;
                // end else if (counter_count < 15'd6500) begin
                //     next_mode3 = 2'b01;
                // end else if (counter_count < 15'd10000) begin
                //     next_mode2 = 2'b10;
                // end else begin
                //     case (state)
                //         RED: begin
                //             if (counter_count < 15'd10100) begin
                //                 next_mode4 = 2'b01;
                //             end else if (counter_count < 15'd13200) begin
                //                 next_mode1 = 2'b01;
                //             end else if (counter_count < 15'd13290) begin
                //                 next_mode4 = 2'b10;
                //             end else if (counter_count < 15'd16790) begin
                //                 next_mode2 = 2'b01;
                //             end else begin
                //                 // reset counter
                //                 next_counter1 = 0;
                //                 next_counter_count = 0;
                //                 // reset state
                //                 next_state = NONE;
                //             end
                //         end
                //         BLACK: begin
                //             if (counter_count < 15'd10250) begin
                //                 next_mode4 = 2'b01;
                //             end else if (counter_count < 15'd13350) begin
                //                 next_mode1 = 2'b01;
                //             end else if (counter_count < 15'd13570) begin
                //                 next_mode4 = 2'b10;
                //             end else if (counter_count < 15'd17070) begin
                //                 next_mode2 = 2'b01;
                //             end else begin
                //                 // reset counter
                //                 next_counter1 = 0;
                //                 next_counter_count = 0;
                //                 // reset state
                //                 next_state = NONE;
                //             end
                //         end
                //         // BLUE: begin
                //         //     if (counter_count < 15'd10180) begin
                //         //         next_mode4 = 2'b01;
                //         //     end else if (counter_count < 15'd13280) begin
                //         //         next_mode1 = 2'b01;
                //         //     end else if (counter_count < 15'd13440) begin
                //         //         next_mode4 = 2'b10;
                //         //     end else if (counter_count < 15'd16940) begin
                //         //         next_mode2 = 2'b01;
                //         //     end else begin
                //         //         // reset counter
                //         //         next_counter1 = 0;
                //         //         next_counter_count = 0;
                //         //         // reset state
                //         //         next_state = NONE;
                //         //     end
                //         // end
                //         default: begin
                //             // reset counter
                //             next_counter1 = 0;
                //             // reset state
                //             next_state = NONE;
                //         end
                //     endcase
                // end

                case (state)
                    RED: begin
                        if (counter_count < 1700) begin
                            next_mode3 = 2'b10;
                        end else if (counter_count < 15'd4800) begin
                            next_mode1 = 2'b10;
                        end else if (counter_count < 15'd6500) begin
                            next_mode3 = 2'b01;
                        end else if (counter_count < 15'd10000) begin
                            next_mode2 = 2'b10;
                        end else if (counter_count < 15'd10100) begin
                            next_mode4 = 2'b01;
                        end else if (counter_count < 15'd13200) begin
                            next_mode1 = 2'b01;
                        end else if (counter_count < 15'd13290) begin
                            next_mode4 = 2'b10;
                        end else if (counter_count < 15'd16790) begin
                            next_mode2 = 2'b01;
                        end else begin
                            // reset counter
                            next_counter1 = 0;
                            next_counter_count = 0;
                            // reset state
                            next_state = NONE;
                        end
                    end
                    BLACK: begin
                        if (counter_count < 1700) begin
                            next_mode3 = 2'b10;
                        end else if (counter_count < 15'd4800) begin
                            next_mode1 = 2'b10;
                        end else if (counter_count < 15'd6500) begin
                            next_mode3 = 2'b01;
                        end else if (counter_count < 15'd10000) begin
                            next_mode2 = 2'b10;
                        end else if (counter_count < 15'd10250) begin
                            next_mode4 = 2'b01;
                        end else if (counter_count < 15'd13350) begin
                            next_mode1 = 2'b01;
                        end else if (counter_count < 15'd13570) begin
                            next_mode4 = 2'b10;
                        end else if (counter_count < 15'd17070) begin
                            next_mode2 = 2'b01;
                        end else begin
                            // reset counter
                            next_counter1 = 0;
                            next_counter_count = 0;
                            // reset state
                            next_state = NONE;
                        end
                    end
                    // BLUE: begin
                    //     if (counter_count < 1700) begin
                    //         next_mode3 = 2'b10;
                    //     end else if (counter_count < 15'd4800) begin
                    //         next_mode1 = 2'b10;
                    //     end else if (counter_count < 15'd6500) begin
                    //         next_mode3 = 2'b01;
                    //     end else if (counter_count < 15'd10000) begin
                    //         next_mode2 = 2'b10;
                    //     end else if (counter_count < 15'd10180) begin
                    //         next_mode4 = 2'b01;
                    //     end else if (counter_count < 15'd13280) begin
                    //         next_mode1 = 2'b01;
                    //     end else if (counter_count < 15'd13440) begin
                    //         next_mode4 = 2'b10;
                    //     end else if (counter_count < 15'd16940) begin
                    //         next_mode2 = 2'b01;
                    //     end else begin
                    //         // reset counter
                    //         next_counter1 = 0;
                    //         next_counter_count = 0;
                    //         // reset state
                    //         next_state = NONE;
                    //     end
                    // end
                    default: begin
                        // reset counter
                        next_counter1 = 0;
                        next_counter_count = 0;
                        // reset state
                        next_state = NONE;
                    end
                endcase
            end
        end
    end
    
endmodule