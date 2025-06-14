.PHONY: deploy build

deploy: bin/ws2812_demo.uf2
	@echo "Hold bootsel button on pico while you plug in the USB cable and press any key to continue. You can release the bootsel while Loading into Flash."
	@read anykey
	picotool load bin/ws2812_demo.uf2
	@echo "Now reboot the device by replugging the USB cable."

build: bin/ws2812_demo

bin/ws2812_demo.uf2: bin/ws2812_demo
	picotool uf2 convert bin/ws2812_demo -t elf bin/ws2812_demo.uf2

bin/ws2812_demo: src/* *.gpr config/*
	alr build --development
