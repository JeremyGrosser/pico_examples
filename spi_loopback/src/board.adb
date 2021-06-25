--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
package body Board is

   procedure Initialize is
      use RP.GPIO;
   begin
      Master_MISO.Configure (Input, Pull_Up, SPI);
      Master_NSS.Configure (Output, Pull_Up, SPI);
      Master_SCK.Configure (Output, Pull_Up, SPI);
      Master_MOSI.Configure (Output, Pull_Up, SPI);

      Slave_MISO.Configure (Output, Floating, SPI);
      Slave_NSS.Configure (Input, Floating, SPI);
      Slave_SCK.Configure (Input, Floating, SPI);
      Slave_MOSI.Configure (Input, Floating, SPI);
   end Initialize;

end Board;
