--
--  Copyright 2021-2026 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Ada.Numerics.Elementary_Functions;

package body Synth is

   procedure Initialize
      (This      : in out Oscillator;
       Amplitude : Float := 1.0)
   is
      use Ada.Numerics.Elementary_Functions;

      Pi        : constant := 3.14159;  --  probably enough digits
      W         : constant := 2.0 * Pi; --  angular velocity
      Gain      : Float;
      Period    : Float;                --  time per sample (seconds)
      F         : Float;
   begin
      Gain := Float (Interfaces.Integer_16'Last) * Amplitude;
      Period := 1.0 / Float (This.Wave'Length);
      for T in This.Wave'Range loop
         --  F := Sin (2.0 * Pi * T * (1.0 / Sample_Rate));
         F := Float (T);
         F := F * Period;
         F := F * W;
         F := Sin (F);
         F := F * Gain;
         This.Wave (T) := Interfaces.Integer_16 (F);
      end loop;
   end Initialize;

   procedure Set_Frequency
      (This      : in out Oscillator;
       Frequency : Positive)
   is
   begin
      This.Frequency := Frequency;
   end Set_Frequency;

   procedure Receive
      (This   : in out Oscillator;
       Buffer : out Audio_Buffer)
   is
      I : Integer := Buffer'First;
   begin
      while I < Buffer'Last loop
         for Channel in 1 .. This.Channels loop
            Buffer (I) := This.Wave (This.T);
            I := I + 1;
         end loop;

         This.T := (This.T + This.Frequency) mod This.Wave'Length;
      end loop;
   end Receive;

end Synth;
