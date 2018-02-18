// ------------------------------------------//
// Buffer Controller
// ------------------------------------------//
// Authors:
// NAME:  Atif Iqbal                           
// NETID: aahangar                             
// SBUID: 111416569                            
// ------------------------------------------//

import defines_pkg::*;

module buff_controller #(parameter WIDTH = 16,
                         parameter SIZE  = 64,
                         parameter LSIZE = $clog2(SIZE))
(
    input  logic                     clk,
    input  logic                     rst,
    input  logic                     wr_toggle,
    input  logic                     rd_toggle,
    input  logic [WIDTH-1:0]         data_in,
    output logic [WIDTH-1:0]         data_out
);

    logic [LSIZE-1:0]  wr_cntr;
    logic [LSIZE-1:0]  rd_cntr;
    logic              wr_en_int;
    logic              rd_en_int;
    logic              wr_en;
    logic              rd_en;

    assign wr_en = (~wr_en_int & wr_toggle) | wr_en_int;
    assign rd_en = (~rd_en_int & rd_toggle) | rd_en_int;

    memory #(
        .WIDTH    ( WIDTH    ),
        .SIZE     ( SIZE     ))
    u_mem (
        .clk      ( clk      ),
        .wr_addr  ( wr_cntr  ),
        .rd_addr  ( rd_addr  ),
        .data_in  ( data_in  ),
        .data_out ( data_out ),
        .wr_en    ( wr_en    ));

    always_ff @(posedge clk) begin
        if(rst) begin
            wr_en_int <= 'd0;
        end
        else begin
            if(wr_toggle) begin
                wr_en_int <= ~wr_en_int; 
            end
        end
    end

    always_ff @(posedge clk) begin
        if(rst) begin
            rd_en_int <= 'd0;
        end
        else begin
            if(rd_toggle) begin
                rd_en_int <= ~rd_en_int; 
            end
        end
    end

    always_ff @(posedge clk) begin
        if(rst) begin
            wr_cntr <= 'd0;
        end
        else begin
            if (wr_en) begin
                wr_cntr <= (wr_cntr == SIZE-1) ? 'd0 : wr_cntr + 1'b1;
            end
        end
    end

    always_ff @(posedge clk) begin
        if(rst) begin
            rd_cntr <= 'd0;
        end
        else begin
            if (rd_en) begin
                rd_cntr <= (rd_cntr == SIZE-1) ? 'd0 : rd_cntr + 1'b1;
            end
        end
    end

endmodule
//end of file.
