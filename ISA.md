# Instruction Format (12-bit)
    - [3:0] op1
    - [7:4] op2
    - [11:8] opcode


# Instruction Cycle
    1. Fetch
        - Fetch instruction
        - Fetch op1
        - Fetch op2
    2. Decode
    3. Execute

Note: Since this is being emulated on an fpga (basys3), the instruction would be supplied as input via dip switches rather than being read from memory pointed by program counter

Note: Due to limitations on bit-width, r0 and r1 are fixed to be operands op1 and op2 for any type of processing and r2 to be output operand

Note: Although the purpose of Program counter is redundant as I am supplying instructions myself, It will be implemented for the sake of correctness (?)


# Instructions:
    - add <op1> <op2>     | 0x1
    - mul <op1> <op2>     | 0x2
    - cmp <op1> <op2>     | 0x3
    - rsh (right shift)   | 0x4
    - lsh (left shift)    | 0x5
    - load <dest> <src>   | 0x6
    - store <dest> <src>  | 0x7
    - jmp <maddr> <laddr> | 0x8
    - je <maddr> <laddr>  | 0x9
    - jg <maddr> <laddr>  | 0xA
    - jl <maddr> <laddr>  | 0xB

Note: Uses 8-bit address lines broken into two 4-bit operands.
    - maddr represents top  4 bits of address [7:4]
    - laddr represents last 4 bits of address [3:0]
