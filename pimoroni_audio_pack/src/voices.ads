--
--  Copyright 2021-2026 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
--  The oscillator's wavetable is far larger than the environment task's
--  stack, so it is declared at library level.
--
with Pico.Pimoroni.Audio_Pack;
with Synth;

package Voices is
   Sine : Synth.Oscillator (Channels => Pico.Pimoroni.Audio_Pack.I2S.Channels);
end Voices;
