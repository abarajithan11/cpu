`timescale 1ns/1ps

package cpu_types;

    typedef enum logic [3:0] {
        LOAD, STORE, MOVE, ADD, SUB, MUL, JNZ
    } op_t;

    typedef union packed {
        struct packed {
            logic [3:0] src_2;
            logic [3:0] src_1;
            logic [3:0] dst;
            op_t        op;
        } rtype;
        struct packed {
            logic [7:0] addr;
            logic [3:0] reg_idx;
            op_t        op;
        } atype;
        logic [15:0] bits;
    } instruction_t;

endpackage
