#
#  -DBLAS_ERRORS_ARE_FATAL  Will stop execution of program
#                           otherwise, blas routines just return error code
#                           as described by the standard.
#                              

define create_directory
	@echo "Create directory $(1) ..."
	@test -d $(1) && echo "Directory already exists" || mkdir -p $(1)
endef

define remove_directory
	@echo "Remove directory $(1) ..."
	@test -d $(1) && rmdir -p $(1) || echo "Directory doesn't exist"
endef

define make_static_library
	@echo "[AR] $(2)"
	@$(AR) rcs $(2) $(1)
	@echo "[RANLIB] $(2)"
	@$(RANLIB) $(2)
endef

define make_shared_library
	@echo "[DYLIB] $(2)"
	@$(LD) -shared $(1) -o $(2)
	@echo "[STRIP] $(2)"
	@$(STRIP) $(2)
endef

CROSS_COMPILE :=
CC       := $(CROSS_COMPILE)gcc
CPP      := $(CROSS_COMPILE)g++
LD       := $(CROSS_COMPILE)g++
AS       := $(CROSS_COMPILE)as
AR       := $(CROSS_COMPILE)ar
RANLIB   := $(CROSS_COMPILE)ranlib
STRIP    := $(CROSS_COMPILE)strip

CFLAGS = -O3 -DBLAS_ERRORS_ARE_FATAL

SPARSE_BLAS_A = libsparseblas.a


SPVEC = spvec_double.o
CSR = csr_double.o $(SPVEC)
SPBLASI_MATRIX = spblasi_matrix.o spblasi_matrix_double.o \
                 spblasi_matrix_prop.o $(CSR)  microblas_double.o
SPBLASI_TABLE = spblasi_table.o table.o
BLAS_MALLOC = blas_malloc.o

SPARSE_BLAS_OBJ = blas_sparse_handle.o blas_sparse_L1_double.o $(MVIO)  \
                  blas_sparse_L23_double.o $(SPBLASI_TABLE) $(SPBLASI_MATRIX) $(BLAS_MALLOC)

.PHONY: clean distclean

all: lib

lib: $(SPARSE_BLAS_A)

$(SPARSE_BLAS_A) : $(SPARSE_BLAS_OBJ)
	@$(call make_static_library, $^, $@)

clean:
	rm -f $(SPARSE_BLAS_OBJ)

distclean:
	rm -f $(SPARSE_BLAS_OBJ) $(SPARSE_BLAS_A)

blas_malloc.o: blas_malloc.c blas_malloc.h
blas_sparse_handle.o: blas_sparse_handle.c blas_sparse.h blas_enum.h \
                      blas_sparse_proto.h spblasi_error.h spblasi_matrix.h \
                      spblasi_matrix_prop.h spblasi_matrix_state.h spblasi_table.h
blas_sparse_L1_double.o: blas_sparse_L1_double.c blas_sparse.h \
                         blas_enum.h blas_sparse_proto.h spblasi_error.h
blas_sparse_L23_double.o: blas_sparse_L23_double.c blas_malloc.h \
                          blas_sparse.h blas_enum.h blas_sparse_proto.h spblasi_error.h \
                          spblasi_matrix_prop.h spblasi_matrix_double.h spblasi_matrix.h \
                          spblasi_matrix_state.h csr_double.h spvec_double.h spblasi_table.h
csr_double.o: csr_double.c blas.h blas_dense.h blas_enum.h \
              blas_dense_proto.h blas_sparse.h blas_sparse_proto.h blas_extended.h \
              blas_extended_proto.h spblasi_error.h blas_malloc.h csr_double.h \
              spvec_double.h
microblas_double.o: microblas_double.c microblas_double.h
spblasi_matrix.o: spblasi_matrix.c blas_malloc.h spblasi_matrix.h \
                  spblasi_matrix_prop.h spblasi_matrix_state.h spblasi_matrix_double.h \
                  blas_enum.h csr_double.h spvec_double.h spblasi_error.h
spblasi_matrix_double.o: spblasi_matrix_double.c blas_malloc.h \
                         spblasi_matrix.h spblasi_matrix_prop.h spblasi_matrix_state.h \
                         spblasi_matrix_double.h blas_enum.h csr_double.h spvec_double.h \
                         spblasi_error.h microblas_double.h
spblasi_matrix_prop.o: spblasi_matrix_prop.c spblasi_matrix_prop.h
spblasi_table_1.o: spblasi_table_1.c blas_malloc.h spblasi_matrix.h \
                   spblasi_matrix_prop.h spblasi_matrix_state.h spblasi_table.h
spblasi_table.o: spblasi_table.c blas_malloc.h spblasi_matrix.h \
                 spblasi_matrix_prop.h spblasi_matrix_state.h table.h
spvec_double.o: spvec_double.c blas_malloc.h spblasi_error.h \
                spvec_double.h
table.o: table.c table.h
