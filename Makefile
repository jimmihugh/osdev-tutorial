#Single Layer Generic Makefile
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

SRCDIR := src
OBJDIR := build
INCDIR := include

CSOURCES := $(wildcard $(SRCDIR)/*.c)
ASOURCES := $(wildcard $(SRCDIR)/*.asm)
COBJECTS := $(CSOURCES:$(SRCDIR)/%.c=$(OBJDIR)/%.o)
AOBJECTS := $(ASOURCES:$(SRCDIR)/%.asm=$(OBJDIR)/%.o)
DEPS := $(COBJECTS:$(OBJDIR)/%.o=%.d)

.PHONY: all rebuild build tidy clean

all: build tidy

rebuild: clean all

build: $(EXECUTABLE)

$(EXECUTABLE): $(AOBJECTS) $(COBJECTS)
	@echo ld -T link.ld -o $@ \*.o
	@$(LD) -T link.ld -o $@ $(AOBJECTS) $(COBJECTS)

$(DEPS): %.d: $(SRCDIR)/%.c
	@$(CC) -E -MM -MP -c $< -I $(INCDIR) > $@

-include $(DEPS)

$(AOBJECTS): $(OBJDIR)/%.o: $(SRCDIR)/%.asm Makefile
	@echo nasm -o $@ $<
	@$(AS) -f elf32 -o $@ $<

$(COBJECTS): $(OBJDIR)/%.o: $(SRCDIR)/%.c Makefile
	@echo gcc -o $@ -c $<
	@$(CC) -o $@ -c $< -I $(INCDIR) $(CFLAGS)

tidy:
	@$(RM) *.d

clean: tidy
	@$(RM) $(OBJDIR)/*.o
	@$(RM) *.bin

#OSDev specific
.PHONY: install

install: tidy
	@mcopy -oi floppy.img kernel.bin ::boot