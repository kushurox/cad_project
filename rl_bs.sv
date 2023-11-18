// barrel shifter right and left

module rsh(input logic [3:0] din, mag, output logic [3:0] val);
    assign val = din >> mag;
endmodule

module lsh(input logic [3:0] din, mag, output logic [3:0] val);
    assign val = din << mag;
endmodule