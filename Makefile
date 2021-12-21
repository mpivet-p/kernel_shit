NAME= boot.bin

ASM= nasm
BUILD_DIR= build
SRC= bootloader_hw.s

all: $(NAME)

$(NAME): $(SRC)
	@mkdir build 2>/dev/null || true
	$(ASM) $(SRC) -f bin -o $(BUILD_DIR)/$(NAME)
	cp $(BUILD_DIR)/$(NAME) $(BUILD_DIR)/boot.img
	truncate -s 1440k $(BUILD_DIR)/boot.img

run: $(NAME)
	qemu-system-i386 -fda $(BUILD_DIR)/boot.img

clean:
	@rm -rf $(BUILD_DIR)/$(NAME)

fclean: clean
	@rm -rf $(BUILD_DIR)
