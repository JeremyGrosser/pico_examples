.PHONY: deploy build

deploy: bin/pimoroni_audio_pack.uf2
	@echo "Hold bootsel button on pico while you plug in the USB cable and press any key to continue. You can release the bootsel while Loading into Flash."
	@read anykey
	picotool load bin/pimoroni_audio_pack.uf2
	@echo "Now reboot the device by replugging the USB cable."

build: bin/pimoroni_audio_pack

bin/pimoroni_audio_pack.uf2: bin/pimoroni_audio_pack
	picotool uf2 convert bin/pimoroni_audio_pack -t elf bin/pimoroni_audio_pack.uf2

bin/pimoroni_audio_pack: src/* *.gpr config/*
	alr build --development
