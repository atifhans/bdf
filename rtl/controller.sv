// ------------------------------------------//
// 
// ------------------------------------------//
// Authors:
// NAME:  Atif Iqbal                           
// NETID: aahangar                             
// SBUID: 111416569                            
// ------------------------------------------//

import defines_pkg::*;

module controller #(parameter CTRL_WIDTH = 24,  //No. of buffers*2
                    parameter CTRL_DEPTH = 48,  //Iteration period
                    parameter LSIZE      = $clog2(CTRL_WIDTH))
(
    input  logic                  clk,
    input  logic                  rst,
    input  logic [CTRL_WIDTH-1:0] ctrl_in,
    input  logic                  load_ctrl,
    input  logic                  start_ctrl,
    input  logic                  stop_ctrl,
    output logic                  buff_wr_toggle[CTRL_WIDTH/2],
    output logic                  buff_rd_toggle[CTRL_WIDTH/2]
);

    logic [LSIZE-1:0]      wr_addr;
    logic [LSIZE-1:0]      rd_addr;
    logic                  wr_en;
    logic                  rd_en;
    logic [CTRL_WIDTH-1:0] ctrl_word;
    logic                  ctrl_active;

    assign wr_en = load_ctrl;
    assign rd_en = (start_ctrl | ctrl_active);

    always_comb begin
        for(int i = 0; i < CTRL_WIDTH; i+=2) begin
            buff_wr_toggle[i] = ctrl_word[i];
            buff_rd_toggle[i] = ctrl_word[i+1];
        end
    end

    memory #(
        .WIDTH    ( CTRL_WIDTH  ),
        .SIZE     ( CTRL_SIZE   ))
    u_ctrl_mem (
        .clk      ( clk       ),
        .wr_addr  ( wr_cntr   ),
        .rd_addr  ( rd_addr   ),
        .data_in  ( ctrl_in   ),
        .data_out ( ctrl_word ),
        .wr_en    ( wr_en    ));

    always_ff @(posedge clk) begin
        if(rst) begin
            ctrl_active <= 'd0;
        end
        else begin
            if(start_ctrl) begin
                ctrl_active <= 1'b1;
            end
            else if(stop_ctrl) begin
                ctrl_active <= 1'b0;
            end
        end
    end

    always_ff @(posedge clk) begin
        if(rst) begin
            wr_addr <= 'd0;
        end
        else begin
            if (wr_en) begin
                wr_addr <= (wr_addr == SIZE-1) ? 'd0 : wr_addr + 1'b1;
            end
        end
    end

    always_ff @(posedge clk) begin
        if(rst) begin
            rd_addr <= 'd0;
        end
        else begin
            if (rd_en) begin
                rd_addr <= (rd_addr == SIZE-1) ? 'd0 : rd_addr + 1'b1;
            end
        end
    end

endmodule
//end of file.
