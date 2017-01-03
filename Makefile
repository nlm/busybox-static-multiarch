BUSYBOX_VERSION=1.26.1
BUSYBOX_BZSOURCE=https://dl.xephon.org/busybox/busybox-$(BUSYBOX_VERSION).tar.bz2
CROSS_TRIPLE=x86_64-linux-gnu
CROSSBUILD_IMAGE=multiarch/crossbuild
REGISTER_IMAGE=multiarch/qemu-user-static:register
BUILD_DIR=$(shell pwd)/busybox-build

.PHONY: all build config defconfig test source clean distclean register

all: build

build: busybox-$(CROSS_TRIPLE)

busybox-$(CROSS_TRIPLE): source
	docker run --rm -ti -v $(BUILD_DIR):/workdir -e CROSS_TRIPLE=$(CROSS_TRIPLE) $(CROSSBUILD_IMAGE) make
	cp $(BUILD_DIR)/busybox $@

# Config

#$(BUILD_DIR)/.config: source
#	echo $@
#	file $@
#	touch $@
#	@echo you must configure busybox build first
#	@echo -- - run 'make config' for interactive configuration
#	@echo -- - run 'make defconfig' for default configuration
#	@echo -- - run 'make copyconfig' to copy 'config' file from current directory

config: source
	docker run --rm -ti -v $(BUILD_DIR):/workdir -e CROSS_TRIPLE=$(CROSS_TRIPLE) $(CROSSBUILD_IMAGE) make config

defconfig: source
	docker run --rm -ti -v $(BUILD_DIR):/workdir -e CROSS_TRIPLE=$(CROSS_TRIPLE) $(CROSSBUILD_IMAGE) make defconfig

copyconfig: source
	cp config $(BUILD_DIR)/.config

# Tests

test: source
	docker run --rm -ti -v $(BUILD_DIR):/workdir -e CROSS_TRIPLE=$(CROSS_TRIPLE) $(CROSSBUILD_IMAGE) make test

# Get Source

source: $(BUILD_DIR)/.source

$(BUILD_DIR)/.source:
	mkdir -p $(BUILD_DIR)
	wget -q $(BUSYBOX_BZSOURCE) -O - | tar -C $(BUILD_DIR) -jxf - --strip 1
	touch $@

# Cleaning

clean:
	rm -fr $(BUILD_DIR)

distclean: clean
	rm -f busybox-$(CROSS_TRIPLE)

# Use register to register the qemu-static programs as binmft_misc hooks

register:
	docker run --rm --privileged $(REGISTER_IMAGE)

