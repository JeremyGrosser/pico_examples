.PHONY: deploy build

deploy: bin/spi_loopback.uf2
	@echo "Hold bootsel button on pico while you plug in the USB cable and press any key to continue. You can release the bootsel while Loading into Flash."
	@read anykey
	picotool load bin/spi_loopback.uf2
	@echo "Now reboot the device by replugging the USB cable."

build: bin/spi_loopback

bin/spi_loopback.uf2: bin/spi_loopback
	picotool uf2 convert bin/spi_loopback -t elf bin/spi_loopback.uf2

bin/spi_loopback: src/* *.gpr config/*
	alr build --development
