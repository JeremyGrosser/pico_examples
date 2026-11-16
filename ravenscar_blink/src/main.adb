--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Ada.Real_Time;
with Blinker;
pragma Unreferenced (Blinker);

procedure Main is
begin
   --  The Blinker.Blink task does all the work. The environment task has
   --  nothing left to do, but must not return.
   delay until Ada.Real_Time.Time_Last;
end Main;
