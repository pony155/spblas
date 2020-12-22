#ifndef BLAS_MALLOC_H
#define BLAS_MALLOC_H

#include <stddef.h>

/* stddef is needed for size_t */
void* blas_malloc(size_t size);
void* blas_realloc(void* p, size_t size);
void* blas_calloc(size_t count, size_t size);
void blas_free(void* p);

#endif
