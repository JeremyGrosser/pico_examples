--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with RP.GPIO; use RP.GPIO;
with RP.Clock;
with Pico.Pimoroni.Audio_Pack;
with Pico.Audio_I2S;
with Pico;

with HAL.Audio;
with Synth;

procedure Main is
   Line_Out  : Pico.Audio_I2S.I2S_Device renames Pico.Pimoroni.Audio_Pack.I2S;
   Mute      : RP.GPIO.GPIO_Point renames Pico.Pimoroni.Audio_Pack.MUTE;

   Buffer    : HAL.Audio.Audio_Buffer (1 .. Line_Out.Buffer_Size);
   Sine      : Synth.Oscillator (Channels => Line_Out.Channels);
   Frequency : Positive := 10;
   T         : Natural := 0;
begin
   RP.Clock.Initialize (Pico.XOSC_Frequency);
   RP.GPIO.Enable;

   Pico.LED.Configure (Output);
   Pico.LED.Clear;

   --  Mute is active-low
   Mute.Configure (Output, Pull_Both);
   Mute.Clear;

   Line_Out.Initialize
      (Frequency => HAL.Audio.Audio_Freq_44kHz,
       Channels  => 2);

   --  Generate the sine wavetable
   Sine.Initialize (Amplitude => 0.5);

   Pico.LED.Set;
   Mute.Set;

   loop
      --  Every 1ms, increase the frequency by 100 Hz, keeping it in the range 10 - 2_000 Hz
      if T mod (Synth.Sample_Rate / 1_000) = 0 then
         Frequency := Frequency + 100;
         Sine.Set_Frequency (Frequency);
         if Frequency >= 2_000 then
            Frequency := 10;
         end if;
      end if;
      T := T + Buffer'Length;

      Sine.Receive (Buffer);
      Line_Out.Transmit (Buffer);
   end loop;
end Main;
