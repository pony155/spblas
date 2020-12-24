/**
    BLAS-specific memory allocation routines.  These can
    be modified for other memory allocators, or for managing
    memory in embedded systems.

    The default implementation simply calls the ANSI C memory
    manager.

*/
#include <malloc.h>
#include "blas_malloc.h"

void* blas_malloc(size_t size)
{
    return malloc(size);
}

void* blas_realloc(void* p, size_t size)
{
    return realloc(p, size);
}

void* blas_calloc(size_t count, size_t size)
{
    return calloc(count, size);
}

void blas_free(void* p)
{
    free(p);
}
