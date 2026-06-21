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
		--Mdir $(BUILD_DIR) ../common/memory.sv $(CPU) $(TB)
	@printf '\n\n\n%s\n' "./$(BUILD_DIR)/V$(TOP)"; \
	./$(BUILD_DIR)/V$(TOP); status=$$?; \
	printf '\n\n\n'; \
	exit $$status

gtkwave: wave.vcd
	$(GTKWAVE) wave.vcd

wave.vcd:
	$(MAKE) sim

clean:
	rm -rf $(BUILD_DIR) wave.vcd
