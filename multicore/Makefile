.PHONY: deploy build

deploy: bin/multicore.uf2
	@echo "Hold bootsel button on pico while you plug in the USB cable and press any key to continue. You can release the bootsel while Loading into Flash."
	@read anykey
	picotool load bin/multicore.uf2
	@echo "Now reboot the device by replugging the USB cable."

build: bin/multicore

bin/multicore.uf2: bin/multicore
	picotool uf2 convert bin/multicore -t elf bin/multicore.uf2

bin/multicore: src/* *.gpr config/*
	alr build --development
