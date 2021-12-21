NAME= boot.bin

ASM= nasm
BUILD_DIR= build
SRC= bootloader_hw.s

.PHONY: all re $(NAME) run fclean clean

all: $(BUILD_DIR)/$(NAME)

$(BUILD_DIR)/$(NAME): bootloader_hw.s 
	@mkdir build 2>/dev/null || true
	$(ASM) $(SRC) -f bin -o $(BUILD_DIR)/$(NAME)

run: $(BUILD_DIR)/$(NAME)
	cp $(BUILD_DIR)/$(NAME) $(BUILD_DIR)/boot.img
	truncate -s 1440k $(BUILD_DIR)/boot.img
	qemu-system-i386 -fda $(BUILD_DIR)/boot.img

re: fclean all

clean:
	rm -rf $(BUILD_DIR)/$(NAME)

fclean: clean
	rm -rf $(BUILD_DIR)
