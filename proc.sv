typedef enum logic [7:0] {IDLE, FETCHING_OP1, FETCHING_OP2, FETCHING_INSTRUCTION, DECODE, EXECUTE} processor_state;
typedef enum logic [3:0] {NOP, ADD, MUL, CMP, RSH, LSH, LOAD, STORE, JMP, JE, JG, JL} instructions_t;

module proc(input logic [11:0] instruction, input logic clk, rst,
            output logic [3:0] proc_flags, proc_out);

    processor_state proc_state, next_state;
    logic [3:0] op1, op2;

    logic [3:0] opcode, aluOut, eflags;
    logic [7:0] program_counter;
    instructions_t inst_reg;

    logic write_en_reg;
    logic [3:0] reg_no;
    logic [3:0] reg_val, reg_out;

    logic write_en_mem;
    logic [3:0] mem_val, mem_out, addr;

    reg_file registry(write_en_reg, clk, rst, reg_no, reg_val, reg_out);
    alu alu1(opcode, op1, op2, eflags, aluOut);
    memory membl(write_en_mem, clk, addr, mem_val, mem_out);

    always_ff @( posedge clk ) begin
        if(rst) begin
            proc_state <= IDLE;
            next_state <= IDLE;
            program_counter <= 0;
            write_en_mem <= 0;
            write_en_reg <= 0;
            reg_no <= 0;
            maddr <= 0;
            laddr <= 0;
            aluOut <= 0;
            inst_reg <= NOP;
        end
        else proc_state <= next_state;
    end

    always_ff @(posedge clk) begin
        if(proc_state == FETCHING_INSTRUCTION) begin
            // writes operand 1 to r0
            inst_reg <= instruction[11:8];
        end
        else if(proc_state == FETCHING_OP1) begin
            // writes instruction to r0, effect takes at negedge
            reg_no <= 0;
            reg_val <= instruction[3:0];
            write_en <= 1;
        end
        else if(proc_state == FETCHING_OP2) begin
            reg_no <= 1;
            reg_val <= instruction[7:4];
            write_en <= 1;
        end
        else if(proc_state == DECODE) begin
            // TODO
        end
    end

    always_ff @(negedge clk) begin
        if(proc_state == FETCHING_OP1) begin
            op1 = reg_out;

        end
        else if(proc_state == FETCHING_OP2) begin
            op2 = reg_out
        end
    end
    
    always_comb begin
        case(proc_state)
            IDLE: next_state = instruction?FETCHING_INSTRUCTION:IDLE; // proceed to next stage only if instruction is supplied
            FETCHING_INSTRUCTION: next_state = FETCHING_OP1;
            FETCHING_OP1: next_state = FETCHING_OP2;
            FETCHING_OP2: next_state = DECODE;
            DECODE: next_state = EXECUTE;
            EXECUTE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end
endmodule