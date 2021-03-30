--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with HAL.Audio; use HAL.Audio;
with Interfaces;

package Synth is
   subtype Sample is Interfaces.Integer_16;

   --  This Sample_Rate is used to set the size of the wavetable buffer. If it
   --  were a variable we would need dynamic memory allocation, which we're
   --  trying to avoid. Curious things may happen if this doesn't match the
   --  output device's sample rate.
   Sample_Rate : constant := 44_100;

   type Oscillator
      (Channels : Positive)
   is tagged private;

   procedure Initialize
      (This      : in out Oscillator;
       Amplitude : Float := 1.0);

   procedure Set_Frequency
      (This      : in out Oscillator;
       Frequency : Positive);

   procedure Receive
      (This   : in out Oscillator;
       Buffer : out Audio_Buffer);

private

   type Oscillator
      (Channels : Positive)
   is tagged record
      Wave      : HAL.Audio.Audio_Buffer (0 .. Sample_Rate);
      Frequency : Positive := 1;
      T         : Natural := 0;
   end record;

end Synth;
