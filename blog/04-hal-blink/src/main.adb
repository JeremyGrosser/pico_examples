with Ada.Real_Time; use Ada.Real_Time;
with RP.GPIO; use RP.GPIO;
with RP.Clock;

procedure Main is
    LED        : GPIO_Point := (Pin => 25);
    Next_Blink : Time := Clock;
begin
    RP.Clock.Initialize (XOSC_Frequency => 12_000_000);
    LED.Configure (Output);

    loop
       LED.Toggle;
       delay until Next_Blink;
       Next_Blink := Next_Blink + Seconds (1);
    end loop;
end Main;
