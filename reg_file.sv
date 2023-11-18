module reg_file(
    input logic write_en, clk, rst,
    input logic [3:0] reg_no, 
    input logic [3:0] val, 
    output logic [3:0] dout
    );
    logic [3:0] r0, r1, r2, eflags;
    always_ff @(negedge clk) begin
        if(rst) begin
            r0 <= 0;
            r1 <= 0;
            r2 <= 0;
            eflags <= 0;
        end
        else if(write_en) begin
            case(reg_no)
                0: r0 <= val;
                1: r1 <= val;
                2: r2 <= val;
                3: eflags <= val;
                default: r0 <= r0;
            endcase
        end
    end
    always_comb begin
        case(reg_no)
            0: dout = r0;
            1: dout = r1;
            2: dout = r2;
            3: dout = eflags;
            default: dout = 0;
        endcase
    end

endmodule