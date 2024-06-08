module TOP(
    output wire [3:0]   Hours,
    output wire [5:0]   Mins,
    output wire [5:0]   Secs,
    output wire [9:0]   MSecs,
    output wire         AM_PM,
    output wire         Alarm,
    output reg          SW_State,
    input  wire         Clock_5K,
    input  wire         Reset,
    input  wire         Control,
    input  wire         Start_S,
    input  wire         Stop_S,
    input  wire         Reset_S,
    input  wire         LoadTime,
    input  wire         LoadAlm,
    input  wire         Set_AM_PM,
    input  wire         Alarm_AM_PM_In,
    input  wire         AlarmEnable,
    input  wire [5:0]   SetSecs,
    input  wire [5:0]   SetMins,
    input  wire [5:0]   AlarmMinsIn,
    input  wire [3:0]   SetHours,
    input  wire [3:0]   AlarmHoursIn
);
    // Registers
    reg                 State_Change;
    // Wire for clock_gen
    wire                Clock_1Sec;
    wire                Clock_1MSec;
    // Wire for stop
    wire    [3:0]       Hours_S;
    wire    [5:0]       Mins_S;
    wire    [5:0]       Secs_S;
    wire    [9:0]       MSecs_S;
    // Wire for alarm_clk
    // wire                AM_PM;
    // wire                Alarm;
    wire    [3:0]       Hours_C;
    wire    [5:0]       Mins_C;
    wire    [5:0]       Secs_C;

    assign Hours    = (Control) ? Hours_C   :   Hours_S;
    assign Mins     = (Control) ? Mins_C    :   Mins_S;
    assign Secs     = (Control) ? Secs_C    :   Secs_S;
    assign MSecs    = (Control) ? 10'd0     :   MSecs_S;

    // Clock Generator
    clock_gen u_clock (
        // Output
        .Clock_1Sec     (Clock_1Sec),
        .Clock_1MSec    (Clock_1MSec),
        // Input
        .Clock_5K       (Clock_5K),
        .Reset          (Reset)
    );

    // Stopwatch
    stop u_stop (
        // Output
	    .Hours_S        (Hours_S),
        .Mins_S         (Mins_S),
        .Secs_S         (Secs_S),
        .MSecs_S        (MSecs_S),
        // Input
        .Clock_1MSec    (Clock_1MSec),
        .Reset          (Reset),
        .Start_S        (Start_S),
        .Stop_S         (Stop_S),
        .Reset_S        (Reset_S),
        .Control        (Control)
    );

    // Alarm Clock
    alarm_clk u_alarm_clk (
        // Output
        .AM_PM          (AM_PM),
        .Alarm          (Alarm),
        .Hours_C        (Hours_C),
        .Mins_C         (Mins_C),
        .Secs_C         (Secs_C),
        // Input
        .Clock_1Sec     (Clock_1Sec),
        .Reset          (Reset),
        .LoadTime       (LoadTime),
        .LoadAlm        (LoadAlm),
        .Set_AM_PM      (Set_AM_PM),
        .Alarm_AM_PM_In (Alarm_AM_PM_In),
        .AlarmEnable    (AlarmEnable),
	    .SetSecs        (SetSecs),
        .SetMins        (SetMins),
        .AlarmMinsIn    (AlarmMinsIn),
        .SetHours       (SetHours),
        .AlarmHoursIn   (AlarmHoursIn)
    );

    always @(posedge Clock_5K, negedge Reset) begin
        if (!Reset) SW_State <= 1'b0;
        else begin
            if      (State_Change)  SW_State <= ~SW_State;
            else                    SW_State <= 1'b0;
        end
    end

    always @(Control, negedge SW_State, negedge Reset) begin
        if (!Reset) State_Change <= 1'b0;
        else        State_Change <= ~State_Change;
    end

endmodule
