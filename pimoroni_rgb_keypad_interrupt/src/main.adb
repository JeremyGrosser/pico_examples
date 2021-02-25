with HAL;        use HAL;
with HAL.GPIO;   use HAL.GPIO;
with RP.GPIO;    use RP.GPIO;
with RP.Clock;
with RP.Device;
with Pico;
with Pico.Pimoroni.RGB_Keypad;

with Demo;

procedure Main is
begin
   RP.Clock.Initialize (Pico.XOSC_Frequency);
   RP.GPIO.Enable;

   Pico.LED.Configure (Output);
   Pico.LED.Set;

   Demo.Initialize;

   RP.Device.Timer.Enable;
   loop
      RP.Device.Timer.Delay_Milliseconds (100);
      Pico.LED.Toggle;
   end loop;
end Main;
