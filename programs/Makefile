CPU := ../5_jump/cpu.sv
TB := $(PROGRAM).sv
BUILD_DIR := obj_dir/$(PROGRAM)
TOP := $(PROGRAM)

include ../common/common.mk

.PHONY: check_program

sim: check_program

check_program:
	@test -n "$(PROGRAM)" || { echo "PROGRAM is required"; exit 2; }
	@test -f "$(PROGRAM).sv" || { echo "Unknown program: $(PROGRAM)"; exit 2; }
