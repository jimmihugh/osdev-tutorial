#Single Directory Generic Makefile
#For C and ASM

#Options
EXECUTABLE := kernel.bin

#Tools
CC := i686-elf-gcc
LD := i686-elf-ld
AS := nasm

WARNINGS := -Wall -Wextra -pedantic -Wshadow -Wpointer-arith -Wcast-align \
            -Wwrite-strings -Wmissing-prototypes -Wmissing-declarations \
            -Wredundant-decls -Wnested-externs -Winline -Wno-long-long \
            -Wconversion -Wstrict-prototypes
CFLAGS := -g -std=gnu99 $(WARNINGS)

CSOURCES := $(wildcard *.c)
ASOURCES := $(wildcard *.asm)
COBJECTS := $(CSOURCES:.c=.o)
AOBJECTS := $(ASOURCES:.asm=.o)
DEPS := $(COBJECTS:%.o=%.d)

.PHONY: all rebuild build tidy clean

all: build tidy

rebuild: clean all

build: $(EXECUTABLE)

$(EXECUTABLE): $(AOBJECTS) $(COBJECTS)
	@echo ld -T link.ld -o $@ \*.o
	@$(LD) -T link.ld -o $@ $(AOBJECTS) $(COBJECTS)

$(DEPS): %.d: %.c
	@$(CC) -E -MM -MP -c $< > $@

-include $(DEPS)

$(COBJECTS): %.o: %.c Makefile
	@echo gcc -o $@ -c $<
	@$(CC) -o $@ -c $< $(CFLAGS)

$(AOBJECTS): %.o: %.asm Makefile
	@echo nasm -o $@ $<
	@$(AS) -f elf32 -o $@ $<

tidy:
	@$(RM) *.d

clean: tidy
	@$(RM) *.o
	@$(RM) *.bin

install: tidy
	@mcopy -oi floppy.img kernel.bin ::boot