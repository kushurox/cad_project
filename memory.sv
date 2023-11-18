module memory(
    input logic write_en, clk,
    input logic [3:0] addr, value,
    output logic [3:0] dout
);

    logic [3:0] mem [100];
    always_ff @(negedge clk) begin
        if(write_en) mem[addr] <= value;
    end

    assign dout = mem[addr];

endmodule