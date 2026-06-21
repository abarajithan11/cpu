# Building a Simple 16-Bit CPU

This project builds a small 16-bit CPU in six incremental stages. Each stage has
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
| `4_move_data_between_registers` | `MOVE` |
| `5_alu` | `ADD`, `SUB`, and `MUL` |
| `6_jump` | Register-indirect conditional `JNZ` |

Every instruction is 16 bits:

```text
15          12 11           8 7            4 3            0
+--------------+---------------+--------------+--------------+
|      op      |     src_1     |    src_2     |     dst      |
+--------------+---------------+--------------+--------------+
```

The opcode values are `MOVE=0`, `LOAD=1`, `STORE=2`, `JNZ=3`, `ADD=4`,
`SUB=5`, and `MUL=6`.

Run any stage with:

```bash
cd 6_jump
make sim
```

The simulation is self-checking and writes `wave.vcd`. Open that waveform with:

```bash
make gtkwave
```