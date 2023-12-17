# disable default rules and default variables
MAKEFLAGS += --no-builtin-rules --no-builtin-variables

.PHONY: all runall info clean

DEBUG := 1
SRC := src
OBJ := obj
BIN := bin
FC := gfortran
ifeq ($(DEBUG),1)
	DEBUGFLAGS := -Wall -Wextra -Wno-uninitialized -Wno-unused-function -Wno-unused-variable -Wno-unused-dummy-argument -fcheck=all -g
else
	DEBUGFLAGS := -O3
endif
FFLAGS := -J $(OBJ) $(DEBUGFLAGS) -std=f2018
SOURCES := $(sort $(wildcard $(SRC)/*.f90))
OBJECTS := $(SOURCES:$(SRC)/%.f90=$(OBJ)/%.o)
BINARIES := $(sort $(patsubst $(SRC)/%.f90,$(BIN)/%,$(wildcard $(SRC)/*.f90)))

all: $(BINARIES)

runall: $(BINARIES)
	for BINARY in $(BINARIES); do $${BINARY}; done

info:
	@echo 'SOURCES="$(SOURCES)"'
	@echo 'OBJECTS="$(OBJECTS)"'
	@echo 'BINARIES="$(BINARIES)"'

clean:
	rm -f bin/* obj/*

# pattern rules
$(BIN)/%: $(OBJ)/%.o
	$(FC) -o $@ $^

$(OBJ)/%.o: $(SRC)/%.f90
	$(FC) $(FFLAGS) -c -o $@ $<
