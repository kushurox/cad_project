// flags MSB not used.
// flags[0] = CARRY, flags[1] = OVERFLOW, flags[2] = NEG, flags[3] = ZERO

module alu(input logic [7:0] opcode, op1, op2, output logic [7:0] eflags, dout);
    // output mux decides which output to consider
    // one mux for ALU output, another mux for eflags state
    logic [4:0] select_lines;

    logic [7:0] lsh_out, rsh_out, add_out, mul_out;
    logic [7:0] fladd_out, flcmp_out;
    
    FA_8 adder(op1, op2, add_out, fladd_out);
    mul multiplier(op1, op2, mul_out);
    rsh right_shift(op1, op2, rsh_out);
    lsh left_shift(op1, op2, lsh_out);
    cmp comparator(op1, op2, flcmp_out);

    op_decoder decoder(opcode, select_lines);
    always_comb begin
        case(select_lines)
        5'b10000: begin dout = lsh_out; end
        5'b01000: begin dout = rsh_out; end
        5'b00001: begin dout = add_out; eflags = fladd_out; end
        5'b00010: begin dout = mul_out; end
        5'b00100: begin eflags = flcmp_out; end
        default: begin dout=0; end
        endcase
    end
    
    

endmodule

module op_decoder(input logic [7:0] opcode, output logic [4:0] select_lines);
    // have 5 operations that can be performed
    // 0 - add; 1 - mul; 2 - cmp (mag); 3 - rsh; 4- lsh
    // refer ISA for opcode description
    always_comb begin
        case(opcode)
            8'b0000_0001: select_lines = 5'b00001;
            8'b0000_0010: select_lines = 5'b00010;
            8'b0000_0011: select_lines = 5'b00100;
            8'b0000_0100: select_lines = 5'b01000;
            8'b0000_0101: select_lines = 5'b10000;
            default: select_lines = 5'b00000;
        endcase // could have used casex?
    end

endmodule