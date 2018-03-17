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
                    parameter LSIZE      = $clog2(CTRL_DEPTH))
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
    logic [0:CTRL_WIDTH-1] ctrl_word;
    logic [0:CTRL_WIDTH-1] ctrl_word_dly;
    logic [0:CTRL_WIDTH-1] ctrl_word_exp;
    logic                  ctrl_active;

    assign wr_en = load_ctrl;
    assign rd_en = (start_ctrl | ctrl_active);

    always_comb begin
        for(int i = 0; i < CTRL_WIDTH; i++) begin
            ctrl_word_exp[i] = ctrl_word[i] | ctrl_word_dly[i];
        end
        
        if(start_ctrl) begin
            buff_wr_toggle[0]  = ctrl_word_exp[0];
            buff_rd_toggle[0]  = ctrl_word_exp[1];
            buff_wr_toggle[1]  = ctrl_word_exp[2];
            buff_rd_toggle[1]  = ctrl_word[3];
            buff_wr_toggle[2]  = ctrl_word_exp[4];
            buff_rd_toggle[2]  = ctrl_word_exp[5];
            buff_wr_toggle[3]  = ctrl_word_exp[6];
            buff_rd_toggle[3]  = ctrl_word[7];
            buff_wr_toggle[4]  = ctrl_word[8];
            buff_rd_toggle[4]  = ctrl_word_exp[9];
            buff_wr_toggle[5]  = ctrl_word_exp[10];
            buff_rd_toggle[5]  = ctrl_word_exp[11];
            buff_wr_toggle[6]  = ctrl_word_exp[12];
            buff_rd_toggle[6]  = ctrl_word[13];
            buff_wr_toggle[7]  = ctrl_word[14];
            buff_rd_toggle[7]  = ctrl_word[15];
            buff_wr_toggle[8]  = ctrl_word[16];
            buff_rd_toggle[8]  = ctrl_word_exp[17];
            buff_wr_toggle[9]  = ctrl_word[18];
            buff_rd_toggle[9]  = ctrl_word_exp[19];
            buff_wr_toggle[10] = ctrl_word_exp[20];
            buff_rd_toggle[10] = ctrl_word_exp[21];
            buff_wr_toggle[11] = ctrl_word_exp[22];
            buff_rd_toggle[11] = ctrl_word[23];
        end
        else begin
            for(int i = 0; i < CTRL_WIDTH/2; i++) begin
                buff_wr_toggle[i] = 1'b0;
                buff_rd_toggle[i] = 1'b0;
            end
        end
        
    end

    memory #(
        .WIDTH    ( CTRL_WIDTH  ),
        .SIZE     ( CTRL_DEPTH  ))
    u_ctrl_mem (
        .clk_wr   ( clk       ),
        .rst_wr   ( rst       ),
        .clk_rd   ( clk       ),
        .rst_rd   ( rst       ),
        .wr_addr  ( wr_addr   ),
        .rd_addr  ( rd_addr   ),
        .data_in  ( ctrl_in   ),
        .data_out ( ctrl_word ),
        .wr_en    ( wr_en     )
    );
    always_ff @(posedge clk) begin
        if(rst) begin
            ctrl_word_dly <= 1'b0;
        end
        else begin
            ctrl_word_dly <= ctrl_word;
        end
    end

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
                wr_addr <= (wr_addr == CTRL_DEPTH-1) ? 'd0 : wr_addr + 1'b1;
            end
        end
    end

    always_ff @(posedge clk) begin
        if(rst) begin
            rd_addr <= 'd0;
        end
        else begin
            if (rd_en) begin
                rd_addr <= (rd_addr == CTRL_DEPTH-1) ? 'd0 : rd_addr + 1'b1;
            end
        end
    end

endmodule
//end of file.
