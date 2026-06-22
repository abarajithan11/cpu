VERILATOR ?= verilator
GTKWAVE ?= gtkwave
BUILD_DIR ?= obj_dir
STEP ?= 5

PROGRAMS := $(basename $(notdir $(wildcard programs/*.sv)))
STEP_DIR := $(wildcard $(STEP)_*)

ifeq ($(PROGRAM),)
SIM_DIR := $(STEP_DIR)
SIM_BUILD_DIR := $(BUILD_DIR)/$(STEP_DIR)
TOP := tb_cpu
CPU := $(STEP_DIR)/cpu.sv
TB := $(STEP_DIR)/tb_cpu.sv
WAVE := $(STEP_DIR)/wave.fst
SIM_ARGS := STEP=$(STEP)
else
SIM_DIR := programs
SIM_BUILD_DIR := $(BUILD_DIR)/$(PROGRAM)
TOP := $(PROGRAM)
CPU := 5_jump/cpu.sv
TB := programs/$(PROGRAM).sv
WAVE := programs/$(PROGRAM).fst
SIM_ARGS := PROGRAM=$(PROGRAM)
endif

.PHONY: sim sim_all gtkwave clean

sim:
ifneq ($(PROGRAM),)
	@test -n "$(PROGRAM)" || { echo "PROGRAM is required"; exit 2; }
	@test -f "programs/$(PROGRAM).sv" || { echo "Unknown program: $(PROGRAM)"; exit 2; }
endif
	@mkdir -p "$(SIM_BUILD_DIR)"
	$(VERILATOR) --binary --timing --trace-fst --trace-max-array 256 -Wall -Wno-fatal --top-module "$(TOP)" \
		--Mdir "$(SIM_BUILD_DIR)" common/memory.sv "$(CPU)" "$(TB)"
	@printf '\n\n\n%s\n' "./$(SIM_BUILD_DIR)/V$(TOP)"; \
	cd "$(SIM_DIR)" && ../$(SIM_BUILD_DIR)/V$(TOP); status=$$?; \
	printf '\n\n\n'; \
	exit $$status
ifneq ($(PROGRAM),)
	@if test -f programs/wave.fst; then mv programs/wave.fst "$(WAVE)"; fi
endif

sim_all:
	@status=0; \
	for stage in [0-9]_*; do \
		echo "==> Simulating $$stage"; \
		$(MAKE) sim STEP="$${stage%%_*}" || status=1; \
	done; \
	for program in $(PROGRAMS); do \
		echo "==> Simulating program $$program"; \
		$(MAKE) sim PROGRAM="$$program" || status=1; \
	done; \
	exit $$status

gtkwave:
	@test -f "$(WAVE)" || $(MAKE) sim $(SIM_ARGS)
	$(GTKWAVE) "$(WAVE)" common/wave.gtkw

clean:
	rm -rf $(BUILD_DIR) [0-9]_*/wave.fst programs/*.fst
