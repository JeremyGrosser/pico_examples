.PHONY: deploy build

deploy: bin/timer.uf2
	@echo "Hold bootsel button on pico while you plug in the USB cable and press any key to continue. You can release the bootsel while Loading into Flash."
	@read anykey
	picotool load bin/timer.uf2
	@echo "Now reboot the device by replugging the USB cable."

build: bin/timer

bin/timer.uf2: bin/timer
	picotool uf2 convert bin/timer -t elf bin/timer.uf2

bin/timer: src/* *.gpr config/*
	alr build --development
