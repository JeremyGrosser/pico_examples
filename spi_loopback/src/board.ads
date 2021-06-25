--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with RP.Device;
with RP.GPIO;
with RP.SPI;
with Pico;

package Board is

   SPI_Master  : RP.SPI.SPI_Port renames RP.Device.SPI_0;
   SPI_Slave   : RP.SPI.SPI_Port renames RP.Device.SPI_1;

   Master_MISO : RP.GPIO.GPIO_Point renames Pico.GP0;
   Master_NSS  : RP.GPIO.GPIO_Point renames Pico.GP1;
   Master_SCK  : RP.GPIO.GPIO_Point renames Pico.GP2;
   Master_MOSI : RP.GPIO.GPIO_Point renames Pico.GP3;

   Slave_MISO  : RP.GPIO.GPIO_Point renames Pico.GP11;
   Slave_NSS   : RP.GPIO.GPIO_Point renames Pico.GP9;
   Slave_SCK   : RP.GPIO.GPIO_Point renames Pico.GP10;
   Slave_MOSI  : RP.GPIO.GPIO_Point renames Pico.GP12;

   procedure Initialize;

end Board;
