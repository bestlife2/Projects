// Module which works as a Stopwatch
module stop (
	output reg  [3:0]   Hours_S,
    output reg  [5:0]   Mins_S,
    output reg  [5:0]   Secs_S,
    output reg  [9:0]   MSecs_S,
    input  wire         Clock_1MSec,
    input  wire         Reset,
    input  wire         Start_S,
    input  wire         Stop_S,
    input  wire         Reset_S,
    input  wire         Control
);

reg [1:0] state;    // Current State
reg Start;

// State parameters
localparam READY = 2'b00;    // Ready to start
localparam START = 2'b01;    // Start measuring
localparam ENDED = 2'b11;    // End measuring

always @(posedge Clock_1MSec, negedge Reset) begin
    if (!Reset) Start <= 1'b0;
    else begin
        if (Start_S) Start <= 1'b1;
        else Start <= 1'b0;
    end
end

// How works in each state
always @(posedge Clock_1MSec, negedge Reset) begin
    if (!Reset) begin
        Hours_S =    4'd0;
        Mins_S  =    6'd0;
        Secs_S  =    6'd0;
        MSecs_S =   10'd0;
    end
    else begin
        if (!Control) begin
            case (state)
                // Initialise settings
                READY   : begin
                    Hours_S =    4'd0;
                    Mins_S  =    6'd0;
                    Secs_S  =    6'd0;
                    MSecs_S =   10'd0;
                end
                // Start measure
                START   : begin
                    if (Start && !Stop_S) begin
                        MSecs_S =   MSecs_S + 1;
                        if (MSecs_S == 10'd1000) begin
                            MSecs_S = 10'd0;
                            Secs_S = Secs_S + 1;
                        end
                        if (Secs_S == 6'd60) begin
                            Secs_S = 6'd0;
                            Mins_S = Mins_S + 1;
                        end
                        if (Mins_S == 6'd60) begin
                            Mins_S = 6'd0;
                            Hours_S = Hours_S + 1;
                        end
                        if (Hours_S == 4'd12) begin
                            Hours_S = 4'd0;
                        end
                    end
                end
                ENDED   :   begin
                    if (Reset_S) begin
                        Hours_S =    4'd0;
                        Mins_S  =    6'd0;
                        Secs_S  =    6'd0;
                        MSecs_S =   10'd0;
                    end
                end
            endcase
        end
    end
end

// State update
always @(posedge Clock_1MSec, negedge Reset) begin
    if (!Reset)                         state <= READY;
    else if (Reset_S && state == ENDED) state <= READY;
    else if (Start_S && state == READY && !Reset_S) state <= START;
    else if (Stop_S && state == START)  state <= ENDED;
end

endmodule
