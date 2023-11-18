// using RFA rather than CLA to save time. change impl if needed as it doesn't affect main code due to abstractions

module FA_4(input logic [3:0] a, b, output logic [3:0] c, flags);
    logic [3:0] sums;
    logic [4:0] carrys;
    assign carrys[0] = 0;

    generate
        for(genvar i=0; i<4; i++) begin
            RFA ad(a[i], b[i], carrys[i], c[i], carrys[i+1]);
        end
    endgenerate

    assign flags[0] = carrys[4]; //  carry flag
    assign flags[1] = a[3] ^ c[3]; // overflow flag
    assign flags[2] = c[3]; // neg flag
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