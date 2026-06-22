# Building a Simple 16-Bit CPU Incrementally in <50 lines of SystemVerilog

This project builds a small 16-bit CPU in five incremental steps. 
Each step has its own CPU and self-checking testbench.
Programs are written directly in SV testbench.
[Full CPU is here](5_jump/cpu.sv)

## Setup & run

```bash
nix-shell                       # enter the environment with verilator & gtkwave

make sim     STEP=3             # simulate the default TB of step 3
make gtkwave STEP=3             # view waveform

make sim     PROGRAM=factorial  # simulate factorial program with step 5
make gtkwave PROGRAM=factorial  # view waveform
```

Available programs:
* `sum_to_n`
* `dot_product`
* `factorial`
* `fibonacci`


## Incremental evolution

| Level | Feature |
| --- | --- |
| `1_load_instruction` | Just a counter to load instructions (PC) |
| `2_load_data_into_registers` | Sixteen registers and `LOAD` |
| `3_store_data` | `STORE` |
| `4_move_alu` | `MOVE`, `ADD`, `SUB`, and `MUL` |
| `5_jump` | `JNZ`: jump to a given address if a given register is not zero |

## CPU Design

* Only 7 opcodes: `LOAD=0`, `STORE=1`, `MOVE=2`, `ADD=3`, `SUB=4`, `MUL=5`, and `JNZ=6`.
* Two instruction formats:
  * Address type: `LOAD, STORE, JNZ` take an `addr`ess and register index (`rid`)
  * Register type: `MOVE, ADD, SUB, MUL` take indices of three registers. Two source (`src_1, src_2`) and one destination `dst`.
* `JNZ` jumps to the `addr` when `regs[rid]` is nonzero.

<table border="1">
  <tr>
    <th>Instructions</th>
    <th>Format</th>
    <th>4 Bits [15:12]</th>
    <th>4 Bits [11:8]</th>
    <th>4 Bits [7:4]</th>
    <th>4 Bits [3:0]</th>
  </tr>
  <tr>
    <td><code>LOAD</code>, <code>STORE</code>, <code>JNZ</code></td>
    <td>Address</td>
    <td colspan="2" align="center"><code>addr</code></td>
    <td><code>rid</code></td>
    <td><code>op</code></td>
  </tr>
  <tr>
    <td><code>MOVE</code>, <code>ADD</code>, <code>SUB</code>, <code>MUL</code></td>
    <td>Register</td>
    <td><code>src_2</code></td>
    <td><code>src_1</code></td>
    <td><code>dst</code></td>
    <td><code>op</code></td>
  </tr>
</table>

### Reading Instructions

Each instruction field is 4-bits, so it becomes a character when displayed as hex, making it easy to read binary. Read right to left (little endian). e.g.

```
0x 1250 - 0=LOAD: regs[5] <- dmem[0x12]
0x 0123 - 3=ADD : regs[2] <- regs[1] + regs[0]
```
