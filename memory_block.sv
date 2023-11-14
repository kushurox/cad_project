
logic [7:0] memory [65536];

module write_mem(input logic [7:0] msb_addr, lsb_addr, val, input logic clk, rst, en);
    // 16KiB addressable memory
    always_ff @( posedge clk ) begin
        if(rst)
            for(int i=0; i<65536; i++) memory[i] <= 0;
        else if(en)
            memory[{msb_addr, lsb_addr}] <= val;
    end
endmodule

module read_mem(input logic [7:0] msb_addr, lsb_addr, input logic clk, output logic [7:0] val);
    always_ff @(posedge clk) begin
        val <= memory[{msb_addr, lsb_addr}];
    end
endmodule