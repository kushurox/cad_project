module tb();
    logic [7:0] op1, op2, opcode, eflags, out;
    alu al(opcode, op1, op2, eflags, out);
    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, tb);
        op1 = 3;
        op2 = -3;
        opcode = 1;
        #5
        opcode = 2;
        #5
        opcode = 4;
        #5
        opcode = 5;
        #5
        $finish;
    end
endmodule

// module test_add();
//     logic [7:0] a, b, c, rdy, flags;
//     FA_8 add(a, b, c, flags, rdy);
//     initial begin
//         $dumpfile("test.vcd");
//         $dumpvars(0, test_add);
//         a = 3;
//         b = 4;
//     end
// endmodule