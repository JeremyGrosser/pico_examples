.PHONY: deploy build

deploy: bin/rtc.uf2
	@echo "Hold bootsel button on pico while you plug in the USB cable and press any key to continue. You can release the bootsel while Loading into Flash."
	@read anykey
	picotool load bin/rtc.uf2
	@echo "Now reboot the device by replugging the USB cable."

build: bin/rtc

bin/rtc.uf2: bin/rtc
	picotool uf2 convert bin/rtc -t elf bin/rtc.uf2

bin/rtc: src/* *.gpr config/*
	alr build --development
