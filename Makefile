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
EXECUTABLE := kernel.bin

all: build tidy

build: $(EXECUTABLE)

$(EXECUTABLE): $(AOBJECTS) $(COBJECTS)
	$(LD) -T link.ld -o $@ $(AOBJECTS) $(COBJECTS)

$(DEPS): %.d: %.c
	@$(CC) -E -MM -MP -c $< > $@

-include $(DEPS)

$(COBJECTS): %.o: %.c
	$(CC) -MMD -MP -o $@ -c $< $(CFLAGS)

$(AOBJECTS): %.o: %.asm
	$(AS) -f elf32 -o $@ $<

tidy:
	@$(RM) *.d

clean: tidy
	@$(RM) *.o
	@$(RM) *.bin