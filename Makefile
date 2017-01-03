BUSYBOX_VERSION=1.25.1
BUSYBOX_BZSOURCE=https://www.busybox.net/downloads/busybox-$(BUSYBOX_VERSION).tar.bz2
CROSS_TRIPLE=x86_64-linux-gnu
CROSSBUILD_IMAGE=multiarch/crossbuild
REGISTER_IMAGE=multiarch/qemu-user-static:register
BUILD_DIR=$(shell pwd)/busybox-build
CONFIG=defstatic

.PHONY: all build config defconfig test source clean distclean register

all: build

build: busybox-$(CROSS_TRIPLE)

busybox-$(CROSS_TRIPLE): source
	docker run --rm -ti -v $(BUILD_DIR):/workdir -e CROSS_TRIPLE=$(CROSS_TRIPLE) $(CROSSBUILD_IMAGE) make
	cp $(BUILD_DIR)/busybox $@
	upx --best --brute $@ || true

# Config

config: source
	docker run --rm -ti -v $(BUILD_DIR):/workdir -e CROSS_TRIPLE=$(CROSS_TRIPLE) $(CROSSBUILD_IMAGE) make config

defconfig: source
	docker run --rm -ti -v $(BUILD_DIR):/workdir -e CROSS_TRIPLE=$(CROSS_TRIPLE) $(CROSSBUILD_IMAGE) make defconfig

copyconfig: source
	cp configs/$(CONFIG) $(BUILD_DIR)/.config

# Tests

test: source
	docker run --rm -ti -v $(BUILD_DIR):/workdir -e CROSS_TRIPLE=$(CROSS_TRIPLE) $(CROSSBUILD_IMAGE) make test

# Fetch Source

source: $(BUILD_DIR)/.source

$(BUILD_DIR)/.source:
	mkdir -p $(BUILD_DIR)
	wget -q $(BUSYBOX_BZSOURCE) -O - | tar -C $(BUILD_DIR) -jxf - --strip 1
	touch $@

# Cleaning

clean:
	docker run --rm -ti -v $(BUILD_DIR):/workdir -e CROSS_TRIPLE=$(CROSS_TRIPLE) $(CROSSBUILD_IMAGE) make clean

distclean: clean
	docker run --rm -ti -v $(BUILD_DIR):/workdir -e CROSS_TRIPLE=$(CROSS_TRIPLE) $(CROSSBUILD_IMAGE) make distclean
	rm -f busybox-$(CROSS_TRIPLE)

# Use register to register the qemu-static programs as binmft_misc hooks

register:
	docker run --rm --privileged $(REGISTER_IMAGE)

