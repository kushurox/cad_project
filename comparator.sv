// performs mag wise comparision
// TODO: implement logic
module cmp(input logic [3:0] op1, op2, output logic [3:0] flags);
    logic [3:0] out;
    FA_4 cmp_fa(op1, op2, out, flags);
endmodule