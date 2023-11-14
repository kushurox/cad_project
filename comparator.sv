// performs mag wise comparision
// TODO: implement logic
module cmp(input logic [7:0] op1, op2, output logic [7:0] flags);
    logic [7:0] out;
    FA_8 cmp_fa(op1, op2, out, flags);
endmodule