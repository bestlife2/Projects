`timescale 100us/10us
module tb;
    wire [3:0]  Hours;
    wire [5:0]  Mins;
    wire [5:0]  Secs;
    wire [9:0]  MSecs;
    wire        AM_PM;
    wire        Alarm;
    wire        SW_Stat;
    reg         Clock_5K;
    reg         Reset;
    reg         Control;
    reg         LoadTime;
    reg         LoadAlm;
    reg         Set_AM_PM;
    reg         Alarm_AM_PM_In;
    reg         AlarmEnable;
    reg [5:0]   SetSecs;
    reg [5:0]   SetMins;
    reg [5:0]   AlarmMinsIn;
    reg [3:0]   SetHours;
    reg [3:0]   AlarmHoursIn;
    reg         Start_S;
    reg         Stop_S;
    reg         Reset_S;

TOP u_TOP (
    .Hours(Hours),
    .Mins(Mins),
    .Secs(Secs),
    .MSecs(MSecs),
    .AM_PM(AM_PM),
    .Alarm(Alarm),
    .SW_State(SW_State),
    .Clock_5K(Clock_5K),
    .Reset(Reset),
    .Control(Control),
    .Start_S(Start_S),
    .Stop_S(Stop_S),
    .Reset_S(Reset_S),
    .LoadTime(LoadTime),
    .LoadAlm(LoadAlm),
    .Set_AM_PM(Set_AM_PM),
    .Alarm_AM_PM_In(Alarm_AM_PM_In),
    .AlarmEnable(AlarmEnable),
    .SetSecs(SetSecs),
    .SetMins(SetMins),
    .AlarmMinsIn(AlarmMinsIn),
    .SetHours(SetHours),
    .AlarmHoursIn(AlarmHoursIn)
);

initial forever #1 Clock_5K = ~Clock_5K;

initial begin
//  Initial Settings
//  Delay           Signal              Value
                    Clock_5K        =   1'b1;
                    Reset           =   1'b1;
                    Control         =   1'b0;
                    LoadTime        =   1'b0;
                    LoadAlm         =   1'b0;
                    Set_AM_PM       =   1'b0;
                    Alarm_AM_PM_In  =   1'b0;
                    AlarmEnable     =   1'b0;
                    SetSecs         =   6'd0;
                    SetMins         =   6'd0;
                    AlarmMinsIn     =   6'd0;
                    SetHours        =   4'd0;
                    AlarmHoursIn    =   4'd0;
                    Start_S         =   1'b0;
                    Stop_S          =   1'b0;
                    Reset_S         =   1'b0;

    #10             Reset           =   1'b0;
    #10             Reset           =   1'b1;
    // Stopwatch Mode Function Check
    #115            Start_S         =   1'b1;
    @(Hours == 1)   Stop_S          =   1'b1;
    #100            Start_S         =   1'b0;
                    Stop_S          =   1'b0;
    #1000           Reset_S         =   1'b1;
    #1000           Start_S         =   1'b1;
                    Reset_S         =   1'b0;
    #1000           Start_S         =   1'b0;
    #1000           Start_S         =   1'b1;
    #100            Reset_S         =   1'b1;
    #100            Reset_S         =   1'b0;
    @(Mins == 40)   Stop_S          =   1'b1;

    // Alarm Clock mode Function Check
                    SetHours        =   4'd11;
                    SetMins         =   6'd59;
                    SetSecs         =   6'd52;
                    Set_AM_PM       =   1'b1;
                    LoadTime        =   1'b1;
                    Alarm_AM_PM_In  =   1'b0;
                    AlarmHoursIn    =   4'd12;
                    AlarmMinsIn     =   6'd3;
                    LoadAlm         =   1'b1;
    #100            Control         =   1'b1;
    @(Secs);
                    LoadTime        =   1'b0;
                    LoadAlm         =   1'b0;
                    AlarmEnable     =   1'b1;
    @(posedge Alarm);
    @(negedge Alarm);
    @(Secs == 5)    $stop;
end

endmodule
