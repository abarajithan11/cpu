# Building a Simple 16-Bit CPU

This project builds a small 16-bit CPU in five incremental stages. Each stage has
its own CPU, self-checking testbench, and Makefile.

Enter the development environment with:

```bash
nix-shell
```

| Stage | Feature |
| --- | --- |
| `1_load_instruction` | Program counter and instruction fetch |
| `2_load_data_into_registers` | Sixteen registers and `LOAD` |
| `3_store_data` | `STORE` |
| `4_move_alu` | `MOVE`, `ADD`, `SUB`, and `MUL` |
| `5_jump` | Immediate-address conditional `JNZ` |

* Check [`common/cpu_types.sv`](common/cpu_types.sv) for instruction format & opcode values.
* Every instruction is 16 bits and is represented by a packed union of two packed structures:

| Instructions | Structure | Bits 15:12 | Bits 11:8 | Bits 7:4 | Bits 3:0 |
| --- | --- | --- | --- | --- | --- |
| `LOAD`, `STORE`, `JNZ` | `a` | `addr[7:4]` | `addr[3:0]` | `rid` | `op` |
| `MOVE`, `ADD`, `SUB`, `MUL` | `r` | `src_2` | `src_1` | `dst` | `op` |

`JNZ` jumps to the `addr` when `regs[rid]` is nonzero.

* The opcode values are `LOAD=0`, `STORE=1`, `MOVE=2`, `ADD=3`, `SUB=4`, `MUL=5`, and `JNZ=6`.

Run any stage with:

```bash
cd 5_jump
make sim
```

Run a complete program from the project root with:

```bash
make sim PROGRAM=factorial
make gtkwave
```

Available programs are `factorial`, `fibonacci`, `sum_to_n`, and `dot_product`.
