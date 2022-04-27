`include "types.vh"
`include "execute.v"

module Alu_tb;
    reg     [31:0]  a, b;
    reg     [3:0]   op;
    wire    [31:0]  result;
    wire            zflag;

    Alu Alu_dut(.*);
    defparam Alu_dut.WIDTH = 32;
    defparam Alu_dut.ALU_OP_COUNT = 16;

`ifdef DUMP_VCD
    initial begin
        $dumpfile("build/alu_tb.vcd");
        $dumpvars(0, Alu_tb);
    end
`endif // DUMP_VCD

    // Test vectors
    reg [67:0]  test_vector         [0:15];
    reg [32:0]  test_gold_vector    [0:15];
    initial begin
        $readmemb("build/alu.mem", test_vector);
        $readmemb("build/alu_gold.mem", test_gold_vector);
    end

    // Test loop
    reg [39:0] resultStr;
    integer i = 0, errs = 0, subfail = 0;
    initial begin
        $display("Running random ALU tests...\n");
        a       = 'd0;
        b       = 'd0;
        op      = 'd0;
        #20;
        for (i=0; i<16; i=i+1) begin
            subfail = 0;
            {a,b,op} = test_vector[i];
            #20;
            if ({$signed(result), zflag} != $signed(test_gold_vector[i]))   resultStr = "ERROR";
            else                                                            resultStr = "PASS ";
            $display("Test[ %2d ]: a = %10d | b = %10d | op = %2d || result = %10d | zflag = %d ... %s",
                i, $signed(a), $signed(b), op, $signed(result), zflag, resultStr
            );
            if (resultStr == "ERROR") errs = errs + 1;
        end
        if (errs > 0)   $display("\nFAILED: %0d", errs);
        else            $display("\nPASSED");
        // TODO: Use VPI to have $myReturn(...) return the "errs" value?
    end

endmodule