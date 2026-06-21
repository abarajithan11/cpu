STAGES := \
	1_load_instruction \
	2_load_data_into_registers \
	3_store_data \
	4_move_alu \
	5_jump

PROGRAMS := $(basename $(notdir $(wildcard programs/*.sv)))

.PHONY: sim sim_all

sim:
	@test -n "$(PROGRAM)" || { echo "PROGRAM is required (for example: make sim PROGRAM=factorial)"; exit 2; }
	$(MAKE) -C programs sim PROGRAM="$(PROGRAM)"

sim_all:
	@status=0; \
	for stage in $(STAGES); do \
		echo "==> Simulating $$stage"; \
		$(MAKE) -C "$$stage" sim || status=1; \
	done; \
	for program in $(PROGRAMS); do \
		echo "==> Simulating program $$program"; \
		rm -f programs/wave.vcd; \
		$(MAKE) -C programs sim PROGRAM="$$program" || status=1; \
		if test -f programs/wave.vcd; then \
			mv programs/wave.vcd "programs/$$program.vcd"; \
		fi; \
	done; \
	exit $$status
