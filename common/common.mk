VERILATOR ?= verilator
GTKWAVE ?= gtkwave
BUILD_DIR ?= obj_dir
TOP ?= tb_cpu
CPU ?= cpu.sv
TB ?= tb_cpu.sv

.PHONY: sim gtkwave clean

sim:
	@mkdir -p $(BUILD_DIR)
	$(VERILATOR) --binary --timing --trace -Wall -Wno-fatal -Wno-UNUSEDSIGNAL --top-module $(TOP) \
		--Mdir $(BUILD_DIR) ../common/cpu_types.sv ../common/memory.sv $(CPU) $(TB)
	./$(BUILD_DIR)/V$(TOP)

gtkwave: wave.vcd
	$(GTKWAVE) wave.vcd

wave.vcd:
	$(MAKE) sim

clean:
	rm -rf $(BUILD_DIR) wave.vcd
