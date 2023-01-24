// Copyright (c) 2022 - present, Austin Annestrand.
// Licensed under the MIT License (see LICENSE file).

`include "types.vh"

module ALU (
  input         [XLEN-1:0]          i_a         /*verilator public*/,
                                    i_b         /*verilator public*/,
  input         [ALU_OP_WIDTH-1:0]  i_op        /*verilator public*/,
  output reg    [XLEN-1:0]          o_result    /*verilator public*/
);
    parameter   XLEN            /*verilator public*/ = 32;
    localparam  ALU_OP_WIDTH    /*verilator public*/ = 5;

    reg  [XLEN-1:0] B_in                /*verilator public*/;
    reg             ALU_SLT             /*verilator public*/;
    reg             SUB                 /*verilator public*/;
    wire            cflag               /*verilator public*/; // Catch unsigned overflow for SLTU/SGTEU cases
    wire [XLEN-1:0] ALU_ADDER_result    /*verilator public*/;
    wire [XLEN-1:0] ALU_XOR_result      /*verilator public*/;
    wire [XLEN-1:0] CONST_4             /*verilator public*/;

    assign ALU_XOR_result   = i_a ^ i_b;
    assign CONST_4          = {{(XLEN-3){1'b0}}, 3'd4};

    // Add/Sub logic
    assign {cflag, ALU_ADDER_result[XLEN-1:0]} = i_a + B_in + {{(XLEN){1'b0}}, SUB};

    always @(*) begin
        // --- ALU internal op setup ---
        case (i_op)
            `ALU_EXEC_SUB   ,
            `ALU_EXEC_SLT   ,
            `ALU_EXEC_SLTU  ,
            `ALU_EXEC_SGTE  ,
            `ALU_EXEC_SGTEU : begin B_in = ~i_b; SUB = 1;       end
            `ALU_EXEC_ADD4A : begin B_in = CONST_4; SUB = 0;    end
            default         : begin B_in = i_b; SUB = 0;        end
        endcase
        // --- SLT setup ---
        case ({i_a[XLEN-1], i_b[XLEN-1]})
            2'b00   : ALU_SLT = ALU_ADDER_result[31];
            2'b01   : ALU_SLT = 1'b0; // a > b since a is pos.
            2'b10   : ALU_SLT = 1'b1; // a < b since a is neg.
            2'b11   : ALU_SLT = ALU_ADDER_result[31];
        endcase
        // --- Main operations ---
        case (i_op)
            default         : o_result = ALU_ADDER_result;
            `ALU_EXEC_AND   : o_result = i_a & i_b;
            `ALU_EXEC_OR    : o_result = i_a | i_b;
            `ALU_EXEC_XOR   : o_result = ALU_XOR_result;
            `ALU_EXEC_SLL   : o_result = i_a << i_b[4:0];
            `ALU_EXEC_SRL   : o_result = i_a >> i_b[4:0];
            `ALU_EXEC_SRA   : o_result = $signed(i_a) >>> i_b[4:0];
            `ALU_EXEC_PASSB : o_result = i_b;
            `ALU_EXEC_EQ    : o_result = {31'd0, ~|ALU_XOR_result};
            `ALU_EXEC_NEQ   : o_result = {31'd0, ~(~|ALU_XOR_result)};
            `ALU_EXEC_SLT   : o_result = {31'd0,  ALU_SLT};
            `ALU_EXEC_SGTE  : o_result = {31'd0, ~ALU_SLT};
            `ALU_EXEC_SLTU  : o_result = {31'd0, ~cflag};
            `ALU_EXEC_SGTEU : o_result = {31'd0,  cflag};
        endcase
    end
endmodule
