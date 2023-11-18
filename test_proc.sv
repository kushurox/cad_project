module test_proc();
    logic [11:0] instruction
    logic clk, rst;

    logic [3:0] eflags, r2;

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, test_reg);
        write_en = 1;
        val = 69;
        #10 write_en = 0; laddr=0;
        #10 laddr = 5;
        #10 $finish;
    end
    
endmodule