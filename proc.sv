typedef enum logic [7:0] {FETCHING_INSTRUCTION, FETCHING_OP1, FETCHING_OP2, DECODE, EXECUTE} processor_state;
typedef enum logic [3:0] {NOP, ADD, MUL, CMP, RSH, LSH, LOAD, STORE, JMP, JE, JG, JL} instructions_t;
typedef enum logic [1:0] {CARRY, OVERFLOW, NEG, ZERO} flag_index;

module proc(input logic [11:0] instruction, input logic clk, rst,
            output logic [3:0] proc_flags, proc_out);

    processor_state proc_state, next_state;
    logic [3:0] op1, op2;

    logic [3:0] opcode, aluOut;
    logic [3:0] program_counter;
    instructions_t inst_reg;

    logic write_en_reg;
    logic [3:0] reg_no;
    logic [3:0] reg_val, reg_out;

    logic write_en_mem;
    logic [3:0] mem_val, mem_out, addr;

    reg_file registry(write_en_reg, clk, rst, reg_no, reg_val, reg_out);
    alu alu1(opcode, op1, op2, proc_flags, aluOut);
    memory membl(write_en_mem, clk, addr, mem_val, mem_out);

    assign op1 = registry.r0;
    assign op2 = registry.r1;
    assign opcode = inst_reg; // since this is a simple processor opcode turns out to be instr itself, however
                              // for a complex processor should use multiple decoder logics

    assign proc_out = registry.r2;

    always_ff @( posedge clk ) begin
        if(rst) begin
            proc_state <= FETCHING_INSTRUCTION;
            next_state <= FETCHING_INSTRUCTION;
            program_counter <= 0;
            write_en_mem <= 0;
            write_en_reg <= 0;
            reg_no <= 0;
            addr <= 0;
            inst_reg <= NOP;
        end
        else proc_state <= next_state;
    end

    always_ff @(posedge clk) begin
        if(proc_state == FETCHING_INSTRUCTION) begin
            // writes operand 1 to r0
            inst_reg <= instruction[11:8];
            write_en_mem <= 0;
            write_en_reg <= 0;
        end
        else if(proc_state == FETCHING_OP1) begin
            // writes instruction to r0, effect takes at negedge
            reg_no <= 0;
            reg_val <= instruction[3:0];
            write_en_reg <= 1;
        end
        else if(proc_state == FETCHING_OP2) begin
            reg_no <= 1;
            reg_val <= instruction[7:4];
            write_en_reg <= 1;
        end
        else if(proc_state == DECODE) begin
            case(inst_reg)
                STORE: begin addr <= op1; mem_val <= reg_out; reg_no <= 2; end
                LOAD: begin reg_no <= 2; reg_val <= mem_val; addr<= op1; end
                default: begin reg_no <= 2; reg_val <= aluOut; write_en_reg <= 1; write_en_mem <= 0; end
            endcase
        end
        else if(proc_state == EXECUTE) begin
            program_counter <= program_counter + 1;
            case(inst_reg)
                JMP: program_counter <= op1;
                JE: program_counter <= (proc_flags[ZERO]?op1:program_counter);
                JG: program_counter <= (proc_flags[CARRY]?op1:program_counter);
                JL: program_counter <= (proc_flags[NEG]?op1:program_counter);
                STORE: begin write_en_mem <= 1; write_en_reg <= 0; end
                LOAD: begin write_en_reg <= 1; write_en_mem <= 0; end
            endcase
        end
    end
    
    always_comb begin
        case(proc_state)
            FETCHING_INSTRUCTION: if(inst_reg==NOP) next_state = FETCHING_INSTRUCTION; else next_state = FETCHING_OP1; // proceed to next stage only if instruction is supplied
            // FETCHING_INSTRUCTION: next_state = FETCHING_OP1;
            FETCHING_OP1: next_state = FETCHING_OP2;
            FETCHING_OP2: next_state = DECODE;
            DECODE: next_state = EXECUTE;
            EXECUTE: next_state = FETCHING_INSTRUCTION;
            default: next_state = FETCHING_INSTRUCTION;
        endcase
    end
endmodule