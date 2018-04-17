#include "heap.h"

void* malloc (size_t size)
{
	return (void*)size;
}

void free (void* ptr)
{
	int* intptr = (int*)ptr;
	*intptr = 0x00000000;
	return;
}