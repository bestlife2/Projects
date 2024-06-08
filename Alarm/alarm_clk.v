module alarm_clk(
    output reg AM_PM, Alarm,
    output reg [5:0] Secs_C,
    output reg [5:0] Mins_C,
    output reg [3:0] Hours_C,
    input Clock_1Sec, Reset,
    input LoadTime, LoadAlm,
    input Set_AM_PM, Alarm_AM_PM_In, AlarmEnable,
	input [5:0] SetSecs, SetMins, AlarmMinsIn,
    input [3:0] SetHours, AlarmHoursIn
);

    reg [5:0] AlarmMins;
    reg [3:0] AlarmHours;
    reg Alarm_AM_PM;

    always @(posedge Clock_1Sec, negedge Reset) begin
        if (!Reset) begin
            // Initialise output reg
            Secs_C = 6'd0;
            Mins_C = 6'd0;
            Hours_C = 4'd12;
            // Initialise Alarm Time
            AlarmMins = 6'd0;
            AlarmHours = 4'd0;
            Alarm_AM_PM = 1'b0;
            // Initialise others
            AM_PM = 1'b1;
            Alarm = 1'b0;
        end
        else begin
            if (LoadAlm) begin
                    AlarmMins <= AlarmMinsIn;
                    AlarmHours <= AlarmHoursIn;
                    Alarm_AM_PM <= Alarm_AM_PM_In;
            end
            // No operation
            if (LoadTime) begin
                Secs_C <= SetSecs;
                Mins_C <= SetMins;
                Hours_C <= SetHours;
                AM_PM <= Set_AM_PM;
            end
            // Clock operation
            else begin
                Secs_C =   Secs_C + 1;
                if (Secs_C == 6'd60) begin
                    Secs_C = 6'd0;
                    Mins_C = Mins_C + 1;
                end
                if (Mins_C == 6'd60) begin
                    Mins_C = 6'd0;
                    Hours_C = Hours_C + 1;
                end
                if (Hours_C == 4'd12 && Mins_C == 6'd0 && Secs_C == 6'd0) AM_PM = ~AM_PM;
                if (Hours_C == 4'd13) begin
                    Hours_C = 4'd1;
                end
                if (AlarmMins == Mins_C && AlarmHours == Hours_C && Alarm_AM_PM == AM_PM && AlarmEnable) begin
                    Alarm <= 1'b1;
                end
                else Alarm <= 1'b0;

            end
        end
    end

endmodule
