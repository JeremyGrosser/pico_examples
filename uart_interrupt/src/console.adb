with RP2040_SVD.Interrupts;
with RP2040_SVD.UART;
with RP_Interrupts;
with RP.UART;
with HAL.UART;
with HAL;

with Chests.Ring_Buffers;

package body Console is

   package Character_Buffers is new Chests.Ring_Buffers
      (Element_Type => Character,
       Capacity     => 32);
   Buffer : Character_Buffers.Ring_Buffer;

   UART : aliased RP.UART.UART_Port (0, RP2040_SVD.UART.UART0_Periph'Access);

   procedure Configure is
      use RP.UART;
      Config : UART_Configuration := Default_UART_Configuration;
   begin
      Config.Enable_FIFOs := False;
      --  Disable the FIFOs so that we get an interrupt as soon as a byte is
      --  available, rather than waiting for a FIFO level.
      Config.Baud := 9600;

      UART.Configure (Config);
      UART.Enable_IRQ (Receive);

      Character_Buffers.Clear (Buffer);

      RP_Interrupts.Attach_Handler
         (Handler => Interrupt'Access,
          Id     => RP2040_SVD.Interrupts.UART0_Interrupt,
          Prio   => RP_Interrupts.Interrupt_Priority'First);
   end Configure;

   procedure Interrupt
      (Id : RP_Interrupts.Interrupt_ID)
   is
      Data   : HAL.UART.UART_Data_8b (1 .. 1);
      Status : HAL.UART.UART_Status;
      Ch     : Character;
   begin
      if not Character_Buffers.Is_Full (Buffer) then
         UART.Receive (Data, Status, Timeout => 0);
         Ch := Character'Val (Natural (Data (1)));
         Character_Buffers.Append (Buffer, Ch);
      end if;
   end Interrupt;

   procedure Get
      (Ch : out Character)
   is
      use Character_Buffers;
   begin
      while Is_Empty (Buffer) loop
         null;
      end loop;

      Ch := First_Element (Buffer);
      Delete_First (Buffer);
   end Get;

   procedure Put
      (Ch : Character)
   is
      Data   : constant HAL.UART.UART_Data_8b (1 .. 1) :=
         (1 => HAL.UInt8 (Character'Pos (Ch)));
      Status : HAL.UART.UART_Status;
   begin
      UART.Transmit (Data, Status, Timeout => 0);
   end Put;

end Console;
