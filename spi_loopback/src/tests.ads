--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with RP.SPI; use RP.SPI;

package Tests is

   procedure Test_8
      (Name          : String;
       Master_Config : SPI_Configuration;
       Slave_Config  : SPI_Configuration);

   procedure Test_16
      (Name            : String;
       Master_Config   : SPI_Configuration;
       Slave_Config    : SPI_Configuration;
       Transfer_Length : Positive := 1);

   procedure Test_Slave
      (Name          : String;
       Master_Config : SPI_Configuration;
       Slave_Config  : SPI_Configuration);

   procedure Test_DMA
      (Name          : String;
       Master_Config : SPI_Configuration;
       Slave_Config  : SPI_Configuration);

end Tests;
