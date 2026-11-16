with Ada.Interrupts.Names;
with System;
with RP.Device;
with RP.UART;
with HAL.UART;
with HAL;

with Chests.Ring_Buffers;

package body Console is

   package Character_Buffers is new Chests.Ring_Buffers
      (Element_Type => Character,
       Capacity     => 32);

   UART : RP.UART.UART_Port renames RP.Device.UART_0;

   --  The runtime attaches Interrupt to the UART0 interrupt and enables it
   --  during elaboration. Get blocks the calling task until the interrupt
   --  handler has buffered a character.
   protected Receiver
      with Interrupt_Priority => System.Interrupt_Priority'Last
   is
      entry Get
         (Ch : out Character);
      procedure Clear;
   private
      procedure Interrupt
         with Attach_Handler => Ada.Interrupts.Names.UART0_Interrupt_CPU_1;

      Buffer    : Character_Buffers.Ring_Buffer;
      Available : Boolean := False;
   end Receiver;

   protected body Receiver is
      entry Get
         (Ch : out Character)
         when Available
      is
         use Character_Buffers;
      begin
         Ch := First_Element (Buffer);
         Delete_First (Buffer);
         Available := not Is_Empty (Buffer);
      end Get;

      procedure Clear is
      begin
         Character_Buffers.Clear (Buffer);
         Available := False;
      end Clear;

      procedure Interrupt is
         Data   : HAL.UART.UART_Data_8b (1 .. 1);
         Status : HAL.UART.UART_Status;
      begin
         --  Reading the data register clears the receive interrupt. If the
         --  buffer is full, the character is dropped.
         UART.Receive (Data, Status, Timeout => 0);
         if not Character_Buffers.Is_Full (Buffer) then
            Character_Buffers.Append
               (Buffer, Character'Val (Natural (Data (1))));
            Available := True;
         end if;
      end Interrupt;
   end Receiver;

   procedure Configure is
      use RP.UART;
      Config : UART_Configuration := Default_UART_Configuration;
   begin
      Config.Enable_FIFOs := False;
      --  Disable the FIFOs so that we get an interrupt as soon as a byte is
      --  available, rather than waiting for a FIFO level.
      Config.Baud := 9600;

      Receiver.Clear;
      UART.Configure (Config);
      UART.Enable_IRQ (Receive);
   end Configure;

   procedure Get
      (Ch : out Character)
   is
   begin
      Receiver.Get (Ch);
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
