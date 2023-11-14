module memory(
    input logic write_en, clk,
    input logic [7:0] maddr, laddr, value,
    output logic [7:0] dout
);

    logic [7:0] mem [1000]; // thousand bytes of memory
    always_ff @(posedge clk) begin
        if(write_en) mem[{maddr, laddr}] <= value;
    end

    assign dout = mem[{maddr, laddr}];

endmodule