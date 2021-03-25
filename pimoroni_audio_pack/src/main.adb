--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with RP.Device;    use RP.Device;
with RP.GPIO;      use RP.GPIO;
with Pico.Pimoroni.Audio_Pack;
with Pico.Audio_I2S;
with Pico;

with Simple_Synthesizer;
with HAL.Audio;

procedure Main is
   Line_Out  : Pico.Audio_I2S.I2S_Device renames Pico.Pimoroni.Audio_Pack.I2S;
   Mute      : RP.GPIO.GPIO_Point renames Pico.Pimoroni.Audio_Pack.MUTE;

   Synth : Simple_Synthesizer.Synthesizer
      (Stereo    => True,
       Amplitude => 1000);

   Sample_Rate : constant HAL.Audio.Audio_Frequency := HAL.Audio.Audio_Freq_44kHz;
   Buffer      : HAL.Audio.Audio_Buffer
      (1 .. HAL.Audio.Audio_Frequency'Enum_Rep (Sample_Rate) / 10);
begin
   RP.GPIO.Enable;

   Pico.LED.Configure (Output);
   Pico.LED.Clear;

   --  Mute is active-low
   Mute.Configure (Output, Pull_Both);
   Mute.Clear;

   Line_Out.Initialize (Sample_Rate);
   Synth.Set_Frequency (Sample_Rate);
   Synth.Set_Note_Frequency (440.0);
   Synth.Receive (Buffer);

   Mute.Set;

   loop
      Line_Out.Transmit (Buffer);
   end loop;
end Main;
