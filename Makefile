CC := i686-elf-gcc
LD := i686-elf-ld

WARNINGS := -Wall -Wextra -pedantic -Wshadow -Wpointer-arith -Wcast-align \
            -Wwrite-strings -Wmissing-prototypes -Wmissing-declarations \
            -Wredundant-decls -Wnested-externs -Winline -Wno-long-long \
            -Wconversion -Wstrict-prototypes
CFLAGS := -g -std=gnu99 $(WARNINGS)

SOURCES := main.c heap.c
OBJECTS = $(SOURCES:.c=.o)
EXECUTABLE := kernel.bin

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	@$(LD) -T link.ld -o $@ $(OBJECTS)

%.o: %.c
	@$(CC) -o $@ -c $< $(CFLAGS)

clean:
	@$(RM) *.o
	@$(RM) *.bin