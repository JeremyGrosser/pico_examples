with USB.HAL.Device;
with RP.Device;

with Ada.Text_IO; use Ada.Text_IO;

package body Interrupts is

   procedure USBCTRL_Handler is
      Event : USB.HAL.Device.UDC_Event := RP.Device.UDC.Poll;
   begin
      Put_Line ("USB event " & Event.Kind'Image);
   end USBCTRL_Handler;

end Interrupts;
