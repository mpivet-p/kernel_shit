BOOTLOADER=bootloader.bin
KERNEL=kernel.bin
IMG=boot.img

ASM=nasm

SRC_DIR=srcs/

BOOTLOADER_PATH= bootloader/
BOOTLOADER_FILES= bootloader.s print_hex.s print_string.s
BOOTLOADER_SRCS= $(addprefix $(SRC_DIR), $(addprefix $(BOOTLOADER_PATH), $(BOOTLOADER_FILES)))

KERNEL_PATH= kernel/
KERNEL_FILES= kernel.s
KERNEL_SRCS= $(addprefix $(SRC_DIR), $(addprefix $(KERNEL_PATH), $(KERNEL_FILES)))

BUILD_DIR=build

.PHONY: all bootloader kernel re run clean

all: bootloader kernel

bootloader: always $(BUILD_DIR)/$(BOOTLOADER)
kernel: always $(BUILD_DIR)/$(KERNEL)

$(BUILD_DIR)/$(BOOTLOADER): $(BOOTLOADER_SRCS)
	$(ASM) $(SRC_DIR)/$(BOOTLOADER_PATH)/bootloader.s -f bin -o $(BUILD_DIR)/$(BOOTLOADER)

$(BUILD_DIR)/$(KERNEL): $(KERNEL_SRCS)
	$(ASM) $(KERNEL_SRCS) -f bin -o $(BUILD_DIR)/$(KERNEL)

run: all
	cp $(BUILD_DIR)/$(BOOTLOADER) $(BUILD_DIR)/$(IMG)
	truncate -s 1440k $(BUILD_DIR)/$(IMG)
	qemu-system-i386 -drive  file=$(BUILD_DIR)/$(IMG),format=raw

# Too advanced (need fat file system implementation)
#run: all
#	dd if=/dev/zero of=$(BUILD_DIR)/main_floppy.img bs=512 count=2880
#	mkfs.fat -F 12 -n "NBOS" $(BUILD_DIR)/main_floppy.img
#	dd if=$(BUILD_DIR)/$(BOOTLOADER) of=$(BUILD_DIR)/main_floppy.img conv=notrunc
#	mcopy -i $(BUILD_DIR)/main_floppy.img $(BUILD_DIR)/kernel.bin "::kernel.bin"
#	qemu-system-i386 -fda $(BUILD_DIR)/main_floppy.img

re: fclean all

always:
	@mkdir -p build

clean:
	rm -rf $(BUILD_DIR)
