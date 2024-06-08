// Module which converts 5kHz Clock into 1Hz and 10Hz Clock.
module clock_gen(
    output reg  Clock_1Sec,
    output reg  Clock_1MSec,
    input       Clock_5K,
    input       Reset
);

reg [2:0] cnt_1;
reg [5:0] cnt_2_0;
reg [5:0] cnt_2_1;

// Using Negative-edge Triggered Asynchronous Reset...
always @(Clock_5K, negedge Reset) begin
    // Reset = 1'b0: Reset clocks
    if (!Reset) begin
        Clock_1MSec <= 1'b0;
        cnt_1       <= 4'h0;
    end
    // Toggle each clock at every positive-edge of Clock_5K.
    else begin
        cnt_1 <= cnt_1 + 1;
        if (cnt_1 == 5)   begin
            Clock_1MSec <= ~Clock_1MSec;
            cnt_1 <= 3'd1;
        end

    end
end

always @(posedge Clock_5K, negedge Reset) begin
    if (!Reset) begin
        Clock_1Sec  <= 1'b0;
        cnt_2_0     <= 6'd0;
        cnt_2_1     <= 6'd1;
    end
    else begin
        cnt_2_0 <= cnt_2_0 + 1;
        if (cnt_2_0 == 50) begin
            cnt_2_1 <= cnt_2_1 + 1;
            cnt_2_0 <= 6'd1;
        end
        if (cnt_2_0 == 50 && cnt_2_1 == 50) begin
            Clock_1Sec <= ~Clock_1Sec;
            cnt_2_1 <= 6'd1;
        end
    end
end

endmodule
