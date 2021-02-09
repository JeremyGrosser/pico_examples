with HAL;        use HAL;
with HAL.GPIO;   use HAL.GPIO;
with RP.Device;  use RP.Device;
with RP.GPIO;    use RP.GPIO;
with RP.Clock;
with Pico;
with Pico.Pimoroni.RGB_Keypad;

procedure Main is
   Count : UInt8 := 0;
begin
   RP.Clock.Initialize (Pico.XOSC_Frequency);
   RP.GPIO.Enable;

   Pico.Pimoroni.RGB_Keypad.Initialize;

   Pico.LED.Configure (Output);
   Pico.LED.Set;

   SysTick.Enable;

   loop
      for P in Pico.Pimoroni.RGB_Keypad.Pad loop
         Pico.Pimoroni.RGB_Keypad.Set_HSV
           (P,
            H          => Count,
            S          => 255,
            V          => 50,
            Brightness => 5);

         Pico.Pimoroni.RGB_Keypad.Update;

         Count := Count + 1;

         Pico.LED.Toggle;
         SysTick.Delay_Milliseconds (25);
      end loop;
   end loop;
end Main;
