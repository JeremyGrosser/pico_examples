with Pico.Pimoroni.RGB_Keypad; use Pico.Pimoroni.RGB_Keypad;

package body Demo is
   procedure Initialize is
   begin
      Pico.Pimoroni.RGB_Keypad.Initialize;

      for P in Pad loop
         Set (P, 0, 0, 0, 0);
      end loop;
      Update;

      Attach (Pad_Changed'Access);
   end Initialize;

   procedure Pad_Changed is
   begin
      Update;
      for P in Pad loop
         if Pressed (P) then
            Set (P, 255, 255, 255);
         else
            Set (P, 0, 0, 0);
         end if;
      end loop;
      Update;
   end Pad_Changed;
end Demo;
