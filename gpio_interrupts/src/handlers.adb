with Pico;

package body Handlers is
   procedure Toggle_LED
      (Trigger : Interrupt_Triggers)
   is
      pragma Unreferenced (Trigger);
   begin
      Pico.LED.Toggle;
   end Toggle_LED;
end Handlers;
