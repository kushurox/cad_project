module test_proc();
    logic [11:0] instruction;
    logic clk, rst;

    logic [3:0] eflags, r2;

    proc processor(instruction, clk, rst, eflags, r2);
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, test_proc);
        rst = 1; #10
        rst = 0;
        instruction = {4'h1, 4'b1101, 4'h4};
        #70 
        $finish;
    end
    
endmodule