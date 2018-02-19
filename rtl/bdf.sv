// ------------------------------------------//
// 
// ------------------------------------------//
// Authors:
// NAME:  Atif Iqbal                           
// NETID: aahangar                             
// SBUID: 111416569                            
// ------------------------------------------//

import defines_pkg::*;

module bdf #(parameter NUM_BUFFS   = 12,
             parameter CTRL_WIDTH  = NUM_BUFFS*2,
             parameter ITER_PERIOD = 48,
             parameter DATA_WIDTH  = 16)
(
    input  logic                   clk,
    input  logic                   rst,
    input  logic                   load_ctrl,
    input  logic                   start_ctrl,
    input  logic                   stop_ctrl,
    input  logic [CTRL_WIDTH-1:0]  ctrl_in,
    input  logic [DATA_WIDTH-1:0]  data_in,
    output logic                   data_out
);

    parameter integer BUFF_SIZE_ARRAY[NUM_BUFFS] = {20, 10, 10, 20, 20, 20, 20, 20, 20, 10, 10, 10};

    logic                  buff_wr_toggle[NUM_BUFFS];
    logic                  buff_rd_toggle[NUM_BUFFS];
    logic [DATA_WIDTH-1:0] buff_data_in[NUM_BUFFS];
    logic [DATA_WIDTH-1:0] buff_data_out[NUM_BUFFS];

    assign buff_data_in[0] = data_in;
    assign data_out = buff_data_out[10];

    pe_2in2out #(
        .WIDTH    (DATA_WIDTH),
        .LATENCY  (LATENCY))
    u_pe_1 (
        .clk        (clk),
        .rst        (rst),
        .data_in_1  (buff_data_out[0]),
        .data_in_2  (buff_data_out[8]),
        .data_out_1 (buff_data_in[1]),
        .data_out_2 (buff_data_in[2])
    );

    pe_2in1out #(
        .WIDTH    (DATA_WIDTH),
        .LATENCY  (LATENCY))
    u_pe_2 (
        .clk        (clk),
        .rst        (rst),
        .data_in_1  (buff_data_out[1]),
        .data_in_2  (buff_data_out[11]),
        .data_out_1 (buff_data_in[4])
    );

    pe_1in2out #(
        .WIDTH    (DATA_WIDTH),
        .LATENCY  (LATENCY))
    u_pe_3 (
        .clk        (clk),
        .rst        (rst),
        .data_in_1  (buff_data_out[2]),
        .data_out_1 (buff_data_in[5]),
        .data_out_1 (buff_data_in[3])
    );

    pe_1in2out #(
        .WIDTH    (DATA_WIDTH),
        .LATENCY  (LATENCY))
    u_pe_4 (
        .clk        (clk),
        .rst        (rst),
        .data_in_1  (buff_data_out[3]),
        .data_out_1 (buff_data_in[7]),
        .data_out_1 (buff_data_in[8])
    );

    pe_2in1out #(
        .WIDTH    (DATA_WIDTH),
        .LATENCY  (LATENCY))
    u_pe_5 (
        .clk        (clk),
        .rst        (rst),
        .data_in_1  (buff_data_out[4]),
        .data_in_2  (buff_data_out[5]),
        .data_out_1 (buff_data_in[6])
    );

    pe_2in1out #(
        .WIDTH    (DATA_WIDTH),
        .LATENCY  (LATENCY))
    u_pe_6 (
        .clk        (clk),
        .rst        (rst),
        .data_in_1  (buff_data_out[6]),
        .data_in_2  (buff_data_out[7]),
        .data_out_1 (buff_data_in[9])
    );

    pe_1in2out #(
        .WIDTH    (DATA_WIDTH),
        .LATENCY  (LATENCY))
    u_pe_7 (
        .clk        (clk),
        .rst        (rst),
        .data_in_1  (buff_data_out[9]),
        .data_out_1 (buff_data_in[10]),
        .data_out_2 (buff_data_in[11])
    );

    genvar i;
    generate begin
        for(i = 0; i < NUM_BUFFS; i=i+1) begin
            buff_controller #(
                .WIDTH    (DATA_WIDTH),
                .SIZE     (BUFF_ARRAY_SIZE[i))
            u_buff_ctrl (
                .clk            (clk),
                .rst            (rst),
                .wr_toggle      (buff_wr_toggle[i]),
                .rd_toogle      (buff_rd_toogle[i]),
                .data_in        (buff_data_in[i]),
                .data_out       (buff_data_out[i])
            );
        end
    end

    controller #(
        .CTRL_WIDTH (CTRL_WIDTH),
        .CTRL_DEPTH (ITER_PERIOD))
    u_ctrl (
        .clk            (clk),
        .rst            (rst),
        .ctrl_in        (ctrl_in),
        .load_ctrl      (load_ctrl),
        .start_ctrl     (start_ctrl),
        .stop_ctrl      (stop_ctrl),
        .buff_wr_toggle (buff_wr_toggle),
        .buff_rd_toggle (buff_rd_toogle)
    );


endmodule
//end of file.
