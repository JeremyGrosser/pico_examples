--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with HAL.GPIO;   use HAL.GPIO;
with HAL.UART;   use HAL.UART;
with RP.Device;  use RP.Device;
with RP.GPIO;    use RP.GPIO;
with RP.UART;
with RP.Clock;
with Pico;

procedure Main is
   UART    : RP.UART.UART_Port renames RP.Device.UART_0;
   UART_TX : RP.GPIO.GPIO_Point renames Pico.GP12;
   UART_RX : RP.GPIO.GPIO_Point renames Pico.GP13;
   Buffer  : UART_Data_8b (1 .. 1);
   Status  : UART_Status;
begin
   RP.Clock.Initialize (Pico.XOSC_Frequency);
   RP.GPIO.Enable;
   Pico.LED.Configure (Output);
   Pico.LED.Set;

   UART_TX.Configure (Output, Pull_Up, RP.GPIO.UART);
   UART_RX.Configure (Output, Pull_Up, RP.GPIO.UART);
   UART.Enable (115_200);

   declare
      Hello       : constant String := "Hello, Pico!" & ASCII.CR & ASCII.LF;
      Hello_Bytes : UART_Data_8b (1 .. Hello'Length);
   begin
      for I in Hello'Range loop
         Hello_Bytes (I) := Character'Pos (Hello (I));
      end loop;
      UART.Transmit (Hello_Bytes, Status);
   end;

   loop
      UART.Receive (Buffer, Status);
      if Status = Ok then
         UART.Transmit (Buffer, Status);
         Pico.LED.Toggle;
      end if;
   end loop;
end Main;
