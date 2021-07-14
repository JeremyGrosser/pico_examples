package Interrupts is

   procedure USBCTRL_Handler
      with Export, External_Name => "isr_irq5";

end Interrupts;
