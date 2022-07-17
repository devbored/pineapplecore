`include "Hazard.v"

module Hazard_tb;
    // Forwarding
    reg           MEM_rd_reg_write, WB_rd_reg_write;
    reg   [4:0]   EXEC_rs1, EXEC_rs2, MEM_rd, WB_rd, WB_rd_skid;
    wire  [1:0]   FWD_rs1, FWD_rs2;
    wire          FWD_rs1_fetch, FWD_rs2_fetch;
    // Stall and Flush
    reg           BRA, JMP, FETCH_valid, MEM_valid, EXEC_mem2reg;
    reg   [4:0]   FETCH_rs1, FETCH_rs2, EXEC_rd;
    wire          FETCH_stall, EXEC_stall, EXEC_flush, MEM_flush;

    Hazard Hazard_dut(.*);

`ifdef DUMP_VCD
    initial begin
        $dumpfile("out/Hazard.vcd");
        $dumpvars(0, Hazard_tb);
    end
`endif // DUMP_VCD

    // Test vectors
    reg [46:0]  test_fwd_vector         [0:31];
    reg [46:0]  test_hzd_vector         [0:31];
    reg [9:0]   test_gold_fwd_vector    [0:31];
    reg [9:0]   test_gold_hzd_vector    [0:31];
    initial begin
        $readmemb("out/unit_Hazard_fwd.mem", test_fwd_vector);
        $readmemb("out/unit_Hazard_fwd_gold.mem", test_gold_fwd_vector);
        $readmemb("out/unit_Hazard_hzd.mem", test_hzd_vector);
        $readmemb("out/unit_Hazard_hzd_gold.mem", test_gold_hzd_vector);
    end

    // Test loop
    reg [39:0] resultStr;
    integer i = 0, errs = 0, subfail = 0;
    initial begin
        MEM_rd_reg_write    = 'd0;
        WB_rd_reg_write     = 'd0;
        EXEC_rs1            = 'd0;
        EXEC_rs2            = 'd0;
        MEM_rd              = 'd0;
        WB_rd               = 'd0;
        WB_rd_skid          = 'd0;
        BRA                 = 'd0;
        JMP                 = 'd0;
        FETCH_valid         = 'd0;
        MEM_valid           = 'd0;
        EXEC_mem2reg        = 'd0;
        FETCH_rs1           = 'd0;
        FETCH_rs2           = 'd0;
        EXEC_rd             = 'd0;
        $display("\n=== Running random Hazard (FWD) tests... =========================================");
        #20;
        $display("INPUTS : MEM_rd_reg_write, WB_rd_reg_write,");
        $display("         EXEC_rs1, EXEC_rs2, MEM_rd, WB_rd, WB_rd_skid, FETCH_rs1, FETCH_rs2");
        $display("OUTPUTS: FWD_rs1, FWD_rs2,");
        $display("         FWD_rs1_fetch, FWD_rs2_fetch");
        $display("");
        for (i=0; i<32; i=i+1) begin
            subfail = 0;
            {
                MEM_rd_reg_write,
                WB_rd_reg_write,
                EXEC_rs1,
                EXEC_rs2,
                MEM_rd,
                WB_rd,
                WB_rd_skid,
                BRA,
                JMP,
                FETCH_valid,
                MEM_valid,
                EXEC_mem2reg,
                FETCH_rs1,
                FETCH_rs2,
                EXEC_rd
            } = test_fwd_vector[i];
            #20;
            if ({FWD_rs1, FWD_rs2, FWD_rs1_fetch, FWD_rs2_fetch} != test_gold_fwd_vector[i][9:4]) resultStr = "ERROR";
            else                                                                                  resultStr = "PASS ";
            $display("Test[ %2d ]: %b_%b_%b_%b_%b_%b_%b_%b_%b || %b_%b_%b_%b ... %s",
                i,
                MEM_rd_reg_write,
                WB_rd_reg_write,
                EXEC_rs1,
                EXEC_rs2,
                MEM_rd,
                WB_rd,
                WB_rd_skid,
                FETCH_rs1,
                FETCH_rs2,
                FWD_rs1,
                FWD_rs2,
                FWD_rs1_fetch,
                FWD_rs2_fetch,
                resultStr
            );
            if (resultStr == "ERROR") errs = errs + 1;
        end
        if (errs > 0)   $display("\nFAILED: %0d", errs);
        else            $display("\nPASSED");
        // TODO: Use VPI to have $myReturn(...) return the "errs" value?

        $display("\n=== Running random Hazard (HZD) tests... =========================================");
        $display("INPUTS : BRA, JMP, FETCH_valid, MEM_valid, EXEC_mem2reg, FETCH_rs1, FETCH_rs2, EXEC_rd");
        $display("OUTPUTS: FETCH_stall, EXEC_stall, EXEC_flush, MEM_flush");
        $display("");
        for (i=0; i<32; i=i+1) begin
            subfail = 0;
            {
                MEM_rd_reg_write,
                WB_rd_reg_write,
                EXEC_rs1,
                EXEC_rs2,
                MEM_rd,
                WB_rd,
                WB_rd_skid,
                BRA,
                JMP,
                FETCH_valid,
                MEM_valid,
                EXEC_mem2reg,
                FETCH_rs1,
                FETCH_rs2,
                EXEC_rd
            } = test_hzd_vector[i];
            #20;
            if ({FETCH_stall, EXEC_stall, EXEC_flush, MEM_flush} != test_gold_hzd_vector[i][3:0]) resultStr = "ERROR";
            else                                                                                  resultStr = "PASS ";
            $display("Test[ %2d ]: %b_%b_%b_%b_%b_%b_%b_%b || %b_%b_%b_%b ... %s",
                i,
                BRA,
                JMP,
                FETCH_valid,
                MEM_valid,
                EXEC_mem2reg,
                FETCH_rs1,
                FETCH_rs2,
                EXEC_rd,
                FETCH_stall, EXEC_stall, EXEC_flush, MEM_flush,
                resultStr
            );
            if (resultStr == "ERROR") errs = errs + 1;
        end
        if (errs > 0)   $display("\nFAILED: %0d", errs);
        else            $display("\nPASSED");
        // TODO: Use VPI to have $myReturn(...) return the "errs" value?
    end

endmodule