// module tb();
//     logic [7:0] op1, op2, opcode, eflags, out;
//     alu al(opcode, op1, op2, eflags, out);
//     initial begin
//         $dumpfile("test.vcd");
//         $dumpvars(0, tb);
//         op1 = 3;
//         op2 = 3;
//         opcode = 1;
//         #5
//         opcode = 2;
//         #5
//         opcode = 4;
//         #5
//         opcode = 5;
//         #5
//         $finish;
//     end
// endmodule

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

// module test_reg();
//     logic [7:0] val;
//     logic [2:0] reg_no;
//     logic [7:0] dout;
//     logic rst, write_en, clk;

//     reg_file registry(write_en, clk, rst, reg_no, val, dout);

//     initial begin
//         clk = 0;
//         forever #5 clk = ~clk;
//     end

//     initial begin
//         $dumpfile("test.vcd");
//         $dumpvars(0, test_reg);
//         write_en = 1;
//         rst = 0;
//         val = 69;
//         reg_no = 0;
//         #10 reg_no = 1;
//         #10 reg_no = 2;
//         #10 reg_no = 3;
//         #10 rst = 1; write_en=0;
//         #10 $finish;
//     end
    
// endmodule

module test_reg();
    logic [7:0] val, maddr, laddr;
    logic [7:0] dout;
    logic write_en, clk;

    memory membl(write_en, clk, maddr, laddr, val, dout);

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, test_reg);
        write_en = 1;
        val = 69;
        maddr = 0;
        laddr = 5;
        #10 write_en = 0; laddr=0;
        #10 laddr = 5;
        #10 $finish;
    end
    
endmodule