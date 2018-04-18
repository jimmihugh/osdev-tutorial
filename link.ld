OUTPUT_FORMAT("elf32-i386")
ENTRY(start)
phys = 0x00100000;
SECTIONS
{
  .start phys : AT(phys) {
    init = .;
    *(.start)
  }
  .text : AT(phys + (code - init)) {
    code = .;
    *(.text)
    . = ALIGN(4096);
  }
  .data : AT(phys + (data - init))
  {
    data = .;
    *(.data)
    *(.rodata)
    . = ALIGN(4096);
  }
  .bss : AT(phys + (bss - init))
  {
    bss = .;
    *(.bss)
    . = ALIGN(4096);
  }
  end = .;
}