typedef enum logic [7:0] {IDLE, FETCHING_OP1, FETCHING_OP2, ALU_OUT} processor_state;

module proc(input logic [7:0] instruction, input logic clk, rst);

    processor_state proc_state, next_state;

    logic [7:0] opcode, eflags, aluOut, op1, op2;
    logic [7:0] program_counter;

    logic write_en_reg;
    logic [2:0] reg_no;
    logic [7:0] reg_val, reg_out;

    logic write_en_mem;
    logic [7:0] mem_val, mem_dout, maddr, laddr;


    alu alu1(opcode, op1, op2, eflags, aluOut);
    reg_file registry(write_en_reg, clk, rst, reg_no, reg_val, reg_out);
    memory membl(write_en, clk, maddr, laddr, mem_val, mem_dout);

    always_ff @(posedge clk) begin
        if(rst) begin program_counter <= 0; write_en_reg <= 0; write_en_mem=0; proc_state=IDLE; end
        else begin
            proc_state <= next_state;
        end
    end

    always_comb begin
        if(proc_state == IDLE) begin
            if(instruction[7:6]==2'b00) begin
                opcode = instruction;
                next_state = FETCHING_OP1;
            end
        end
    end

    always_comb begin
        case(proc_state)
            FETCHING_OP1: op1 = reg_out;
            FETCHING_OP2: op2 = reg_out;
            ALU_OUT: reg_val = aluOut;
        endcase
    end

endmodule