--
--  Copyright 2022-2026 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with LED_Control;

procedure Multicore is
begin
   LED_Control.Initialize;
   LED_Control.Run;
end Multicore;
