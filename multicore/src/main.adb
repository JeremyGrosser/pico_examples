--
--  Copyright 2022 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with LED_Control;

procedure Main is
begin
   LED_Control.Initialize;
   LED_Control.Start;
end Main;
