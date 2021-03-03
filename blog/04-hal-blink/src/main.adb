with Ada.Real_Time; use Ada.Real_Time;
with RP.GPIO; use RP.GPIO;

procedure Main is
    LED        : GPIO_Point := (Pin => 25);
    Next_Blink : Time := Clock;
begin
    LED.Configure (Output);
    loop
       LED.Toggle;
       delay until Next_Blink;
       Next_Blink := Next_Blink + Seconds (1);
    end loop;
end Main;
