with RP.GPIO; use RP.GPIO;

package Handlers is
   procedure Toggle_LED
      (Pin     : GPIO_Pin;
       Trigger : Interrupt_Triggers);
end Handlers;
