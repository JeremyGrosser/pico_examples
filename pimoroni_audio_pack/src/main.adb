--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Interfaces; use Interfaces;
with RP.Device;  use RP.Device;
with RP.GPIO;    use RP.GPIO;
with RP.Clock;
with Pico.Pimoroni.Audio_Pack;
with Pico.Audio_I2S;
with Pico;

with Simple_Synthesizer;
with HAL.Audio;

procedure Main is
   Line_Out : Pico.Audio_I2S.I2S_Device renames Pico.Pimoroni.Audio_Pack.I2S;
   Mute     : RP.GPIO.GPIO_Point renames Pico.Pimoroni.Audio_Pack.MUTE;
   Synth    : Simple_Synthesizer.Synthesizer
      (Stereo    => True,
       Amplitude => Integer (Integer_16'Last / 8));
   Buffer   : HAL.Audio.Audio_Buffer (1 .. 1024);
begin
   RP.Clock.Initialize (Pico.XOSC_Frequency);
   RP.GPIO.Enable;

   Pico.LED.Configure (Output);
   Pico.LED.Clear;

   --  Mute is active-low
   Mute.Configure (Output, Pull_Both);
   Mute.Clear;

   Line_Out.Initialize (HAL.Audio.Audio_Freq_44kHz);
   Synth.Set_Frequency (HAL.Audio.Audio_Freq_44kHz);
   Synth.Set_Note_Frequency (440.0);
   Synth.Receive (Buffer);

   Mute.Set;

   loop
      Line_Out.Transmit (Buffer);
      Pico.LED.Toggle;
   end loop;
end Main;
