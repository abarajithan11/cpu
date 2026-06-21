VERILATOR ?= verilator
GTKWAVE ?= gtkwave
BUILD_DIR ?= obj_dir
TOP ?= tb_cpu

.PHONY: sim gtkwave clean

sim:
	$(VERILATOR) --binary --timing --trace -Wall -Wno-fatal -Wno-UNUSEDSIGNAL --top-module $(TOP) \
		--Mdir $(BUILD_DIR) ../common/memory.sv cpu.sv tb_cpu.sv
	./$(BUILD_DIR)/V$(TOP)

gtkwave: wave.vcd
	$(GTKWAVE) wave.vcd

wave.vcd:
	$(MAKE) sim

clean:
	rm -rf $(BUILD_DIR) wave.vcd
