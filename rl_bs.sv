// barrel shifter right and left

module rsh(input logic [7:0] din, mag, output logic [7:0] val);
    assign val = din >> mag;
endmodule

module lsh(input logic [7:0] din, mag, output logic [7:0] val);
    assign val = din << mag;
endmodule