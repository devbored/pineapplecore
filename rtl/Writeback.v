`include "types.vh"

module Writeback (
    input       [2:0]       i_funct3,
    input       [XLEN-1:0]  i_dataIn,
    output reg  [XLEN-1:0]  o_dataOut
);
    parameter XLEN = 32;

    // Just output load-type (w/ - w/o sign-ext) for now
    always @(*) begin
        case (i_funct3)
            `LS_B_OP    : o_dataOut = {{24{i_dataIn[31]}}, i_dataIn[7:0]};
            `LS_H_OP    : o_dataOut = {{16{i_dataIn[31]}}, i_dataIn[15:0]};
            `LS_W_OP    : o_dataOut = i_dataIn;
            `LS_BU_OP   : o_dataOut = {24'd0, i_dataIn[7:0]};
            `LS_HU_OP   : o_dataOut = {16'd0, i_dataIn[15:0]};
            default     : o_dataOut = i_dataIn;
        endcase
    end
endmodule