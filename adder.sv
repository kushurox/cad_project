// using RFA rather than CLA to save time. change impl if needed as it doesn't affect main code due to abstractions

module FA_8(input logic [7:0] a, b, output logic [7:0] c, flags);
    logic [7:0] sums;
    logic [8:0] carrys;
    assign carrys[0] = 0;

    generate
        for(genvar i=0; i<8; i++) begin
            RFA ad(a[i], b[i], carrys[i], c[i], carrys[i+1]);
        end
    endgenerate

    assign flags[0] = carrys[8]; //  carry flag
    assign flags[1] = a[7] ^ c[7]; // overflow flag
    assign flags[2] = c[7]; // neg flag
    assign flags[3] = (c==0); // zero flag

endmodule

module RFA(input logic a, b, cin, output logic sum, cout);
    logic s0, c0, c1;
    always_comb begin
        s0 = a ^ b;
        c0 = a & b;
        sum = s0 ^ cin;
        c1 = s0 & cin;
        cout = c1 | c0;
    end
endmodule