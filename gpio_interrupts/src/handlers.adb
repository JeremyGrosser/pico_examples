with Pico;

package body Handlers is
   procedure Toggle_LED
      (Pin     : GPIO_Pin;
       Trigger : Interrupt_Triggers)
   is
      pragma Unreferenced (Pin);
      pragma Unreferenced (Trigger);
   begin
      Pico.LED.Toggle;
   end Toggle_LED;
end Handlers;
