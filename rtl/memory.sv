// ------------------------------------------//
// Memory Model
// ------------------------------------------//
// Authors:
// NAME:  Atif Iqbal                           
// NETID: aahangar                             
// SBUID: 111416569                            
// ------------------------------------------//

import defines_pkg::*;

module memory #(parameter WIDTH = 16,
                parameter SIZE  = 64,
                parameter LSIZE = $clog2(SIZE))
(
    input  logic                     clk,
    input  logic                     rst,
    input  logic [WIDTH-1:0]         data_in,
    input  logic [LSIZE-1:0]         wr_addr,
    input  logic [LSIZE-1:0]         rd_addr,
    input  logic                     wr_en,
    output logic [WIDTH-1:0]         data_out
);

    logic [SIZE-1:0][WIDTH-1:0] mem;

    assign data_out = mem[rd_addr];

    always_ff @(posedge clk) begin
        if(rst) begin
            mem <= '{SIZE{'0}};
        end
        else begin
            if(wr_en) begin
                mem[wr_addr] <= data_in;

            end
        end
    end

endmodule
//end of file.
