// flags MSB not used.
// flags[0] = CARRY, flags[1] = OVERFLOW, flags[2] = NEG, flags[3] = ZERO

module alu(input logic [3:0] opcode, op1, op2, output logic [3:0] eflags, dout);
    // output mux decides which output to consider
    // one mux for ALU output, another mux for eflags state

    logic [3:0] lsh_out, rsh_out, add_out, mul_out;
    logic [3:0] fladd_out, flcmp_out;
    
    FA_4 adder(op1, op2, add_out, fladd_out);
    mul multiplier(op1, op2, mul_out);
    rsh right_shift(op1, op2, rsh_out);
    lsh left_shift(op1, op2, lsh_out);
    cmp comparator(op1, op2, flcmp_out);

    always_comb begin
        case(opcode)
            4'b0001: begin dout = add_out; eflags = fladd_out; end
            4'b0010: begin dout = mul_out; eflags = 0; end
            4'b0011: begin dout = 0; eflags = flcmp_out; end
            4'b1001: begin dout = 0; eflags = flcmp_out; end // computing cmp even if its je, jg, jl instruction
            4'b1010: begin dout = 0; eflags = flcmp_out; end
            4'b1011: begin dout = 0; eflags = flcmp_out; end
            4'b0100: dout = rsh_out;
            4'b0101: dout = lsh_out;
            default: dout = 0;
        endcase
    end
    
endmodule
