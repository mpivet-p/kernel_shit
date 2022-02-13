BOOTLOADER=bootloader.bin
KERNEL=kernel.bin
IMG=boot.img

ASM=nasm
CC=gcc

SRC_DIR=srcs/

BOOTLOADER_PATH= bootloader/
BOOTLOADER_FILES= bootloader.s print_hex.s print_string.s
BOOTLOADER_SRCS= $(addprefix $(SRC_DIR), $(addprefix $(BOOTLOADER_PATH), $(BOOTLOADER_FILES)))

KERNEL_PATH= kernel/
KERNEL_FILES= kernel.c idt.c
KERNEL_SRCS= $(addprefix $(SRC_DIR), $(addprefix $(KERNEL_PATH), $(KERNEL_FILES)))

BUILD_DIR=build

.PHONY: all bootloader kernel re run clean

all: bootloader kernel

bootloader: always $(BUILD_DIR)/$(BOOTLOADER)
kernel: always $(BUILD_DIR)/$(KERNEL)

$(BUILD_DIR)/$(BOOTLOADER): $(BOOTLOADER_SRCS)
	$(ASM) $(SRC_DIR)/$(BOOTLOADER_PATH)bootloader.s -f bin -o $(BUILD_DIR)/$(BOOTLOADER)

$(BUILD_DIR)/$(KERNEL): $(KERNEL_SRCS)
	$(CC) -m32 -fno-pie -ffreestanding -c $(SRC_DIR)$(KERNEL_PATH)/kernel.c -o $(BUILD_DIR)/kernel.o
	$(CC) -m32 -fno-pie -ffreestanding -c $(SRC_DIR)$(KERNEL_PATH)/interrupts.c -o $(BUILD_DIR)/interrupts.o
	$(CC) -m32 -fno-pie -ffreestanding -c $(SRC_DIR)$(KERNEL_PATH)/io.c -o $(BUILD_DIR)/io.o
	$(CC) -m32 -fno-pie -ffreestanding -c $(SRC_DIR)$(KERNEL_PATH)/keyboard.c -o $(BUILD_DIR)/keyboard.o
	$(CC) -m32 -fno-pie -ffreestanding -c $(SRC_DIR)$(KERNEL_PATH)/pic_ack.c -o $(BUILD_DIR)/pick_ack.o
	$(ASM) srcs/kernel/kernel_entry.s -f elf -o $(BUILD_DIR)/kernel_entry.o
	$(ASM) srcs/kernel/load_idt.s -f elf -o $(BUILD_DIR)/load_idt.o
	$(ASM) srcs/kernel/interrupt_handler.s -f elf -o $(BUILD_DIR)/interrupt_handler.o
	ld -m elf_i386 -o $(BUILD_DIR)/$(KERNEL) -Ttext 0x1000 $(BUILD_DIR)/kernel_entry.o $(BUILD_DIR)/kernel.o $(BUILD_DIR)/interrupts.o $(BUILD_DIR)/io.o $(BUILD_DIR)/keyboard.o $(BUILD_DIR)/pic_ack.o $(BUILD_DIR)/load_idt.o $(BUILD_DIR)/interrupt_handler.o --oformat=binary

run: all
	cat $(BUILD_DIR)/$(BOOTLOADER) $(BUILD_DIR)/$(KERNEL) > $(BUILD_DIR)/$(IMG)
	truncate -s 1440k $(BUILD_DIR)/$(IMG)
	qemu-system-i386 -drive  file=$(BUILD_DIR)/$(IMG),format=raw

# Too advanced (need fat file system implementation)
#run: all
#	dd if=/dev/zero of=$(BUILD_DIR)/main_floppy.img bs=512 count=2880
#	mkfs.fat -F 12 -n "NBOS" $(BUILD_DIR)/main_floppy.img
#	dd if=$(BUILD_DIR)/$(BOOTLOADER) of=$(BUILD_DIR)/main_floppy.img conv=notrunc
#	mcopy -i $(BUILD_DIR)/main_floppy.img $(BUILD_DIR)/kernel.bin "::kernel.bin"
#	qemu-system-i386 -fda $(BUILD_DIR)/main_floppy.img

re: clean run

always:
	@mkdir -p build

clean:
	rm -rf $(BUILD_DIR)
