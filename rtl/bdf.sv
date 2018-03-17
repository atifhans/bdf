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
             parameter LATENCY     = 15,
             parameter DATA_WIDTH  = 16)
(
    input  logic                   clk1,
    input  logic                   rst1,
    input  logic                   clk2,
    input  logic                   rst2,
    input  logic                   load_ctrl,
    input  logic                   start_ctrl,
    input  logic                   stop_ctrl,
    input  logic [CTRL_WIDTH-1:0]  ctrl_in,
    input  logic [DATA_WIDTH-1:0]  data_in,
    output logic [DATA_WIDTH-1:0]  data_out
);

    parameter integer BUFF_ARRAY_SIZE[NUM_BUFFS] = {20, 10, 10, 20, 20, 20, 20, 20, 20, 10, 10, 10};

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
        .clk        (clk1),
        .rst        (rst1),
        .data_in_1  (buff_data_out[0]),
        .data_in_2  (buff_data_out[8]),
        .data_out_1 (buff_data_in[1]),
        .data_out_2 (buff_data_in[2])
    );

    pe_2in1out #(
        .WIDTH    (DATA_WIDTH),
        .LATENCY  (LATENCY))
    u_pe_2 (
        .clk        (clk2),
        .rst        (rst2),
        .data_in_1  (buff_data_out[1]),
        .data_in_2  (buff_data_out[11]),
        .data_out_1 (buff_data_in[4])
    );

    pe_1in2out #(
        .WIDTH    (DATA_WIDTH),
        .LATENCY  (LATENCY))
    u_pe_3 (
        .clk        (clk1),
        .rst        (rst1),
        .data_in_1  (buff_data_out[2]),
        .data_out_1 (buff_data_in[5]),
        .data_out_2 (buff_data_in[3])
    );

    pe_1in2out #(
        .WIDTH    (DATA_WIDTH),
        .LATENCY  (LATENCY))
    u_pe_4 (
        .clk        (clk2),
        .rst        (rst2),
        .data_in_1  (buff_data_out[3]),
        .data_out_1 (buff_data_in[7]),
        .data_out_2 (buff_data_in[8])
    );

    pe_2in1out #(
        .WIDTH    (DATA_WIDTH),
        .LATENCY  (LATENCY))
    u_pe_5 (
        .clk        (clk1),
        .rst        (rst1),
        .data_in_1  (buff_data_out[4]),
        .data_in_2  (buff_data_out[5]),
        .data_out_1 (buff_data_in[6])
    );

    pe_2in1out #(
        .WIDTH    (DATA_WIDTH),
        .LATENCY  (LATENCY))
    u_pe_6 (
        .clk        (clk2),
        .rst        (rst2),
        .data_in_1  (buff_data_out[6]),
        .data_in_2  (buff_data_out[7]),
        .data_out_1 (buff_data_in[9])
    );

    pe_1in2out #(
        .WIDTH    (DATA_WIDTH),
        .LATENCY  (LATENCY))
    u_pe_7 (
        .clk        (clk1),
        .rst        (rst1),
        .data_in_1  (buff_data_out[9]),
        .data_out_1 (buff_data_in[10]),
        .data_out_2 (buff_data_in[11])
    );

    //Buffer 0
    buff_controller #(
        .WIDTH    (DATA_WIDTH),
        .SIZE     (BUFF_ARRAY_SIZE[0]))
    u_buff0 (
        .clk_wr         (clk1),
        .rst_wr         (rst1),
        .clk_rd         (clk1),
        .rst_rd         (rst1),
        .wr_toggle      (buff_wr_toggle[0]),
        .rd_toggle      (buff_rd_toggle[0]),
        .data_in        (buff_data_in[0]),
        .data_out       (buff_data_out[0])
    );

    //Buffer 1
    buff_controller #(
        .WIDTH    (DATA_WIDTH),
        .SIZE     (BUFF_ARRAY_SIZE[1]))
    u_buff1 (
        .clk_wr         (clk1),
        .rst_wr         (rst1),
        .clk_rd         (clk2),
        .rst_rd         (rst2),
        .wr_toggle      (buff_wr_toggle[1]),
        .rd_toggle      (buff_rd_toggle[1]),
        .data_in        (buff_data_in[1]),
        .data_out       (buff_data_out[1])
    );

    //Buffer 2
    buff_controller #(
        .WIDTH    (DATA_WIDTH),
        .SIZE     (BUFF_ARRAY_SIZE[2]))
    u_buff2 (
        .clk_wr         (clk1),
        .rst_wr         (rst1),
        .clk_rd         (clk1),
        .rst_rd         (rst1),
        .wr_toggle      (buff_wr_toggle[2]),
        .rd_toggle      (buff_rd_toggle[2]),
        .data_in        (buff_data_in[2]),
        .data_out       (buff_data_out[2])
    );

    //Buffer 3
    buff_controller #(
        .WIDTH    (DATA_WIDTH),
        .SIZE     (BUFF_ARRAY_SIZE[3]))
    u_buff3 (
        .clk_wr         (clk1),
        .rst_wr         (rst1),
        .clk_rd         (clk2),
        .rst_rd         (rst2),
        .wr_toggle      (buff_wr_toggle[3]),
        .rd_toggle      (buff_rd_toggle[3]),
        .data_in        (buff_data_in[3]),
        .data_out       (buff_data_out[3])
    );

    //Buffer 4
    buff_controller #(
        .WIDTH    (DATA_WIDTH),
        .SIZE     (BUFF_ARRAY_SIZE[4]))
    u_buff4 (
        .clk_wr         (clk2),
        .rst_wr         (rst2),
        .clk_rd         (clk1),
        .rst_rd         (rst1),
        .wr_toggle      (buff_wr_toggle[4]),
        .rd_toggle      (buff_rd_toggle[4]),
        .data_in        (buff_data_in[4]),
        .data_out       (buff_data_out[4])
    );

    //Buffer 5
    buff_controller #(
        .WIDTH    (DATA_WIDTH),
        .SIZE     (BUFF_ARRAY_SIZE[5]))
    u_buff5 (
        .clk_wr         (clk1),
        .rst_wr         (rst1),
        .clk_rd         (clk1),
        .rst_rd         (rst1),
        .wr_toggle      (buff_wr_toggle[5]),
        .rd_toggle      (buff_rd_toggle[5]),
        .data_in        (buff_data_in[5]),
        .data_out       (buff_data_out[5])
    );

    //Buffer 6
    buff_controller #(
        .WIDTH    (DATA_WIDTH),
        .SIZE     (BUFF_ARRAY_SIZE[6]))
    u_buff6 (
        .clk_wr         (clk1),
        .rst_wr         (rst1),
        .clk_rd         (clk2),
        .rst_rd         (rst2),
        .wr_toggle      (buff_wr_toggle[6]),
        .rd_toggle      (buff_rd_toggle[6]),
        .data_in        (buff_data_in[6]),
        .data_out       (buff_data_out[6])
    );

    //Buffer 7
    buff_controller #(
        .WIDTH    (DATA_WIDTH),
        .SIZE     (BUFF_ARRAY_SIZE[7]))
    u_buff7 (
        .clk_wr         (clk2),
        .rst_wr         (rst2),
        .clk_rd         (clk2),
        .rst_rd         (rst2),
        .wr_toggle      (buff_wr_toggle[7]),
        .rd_toggle      (buff_rd_toggle[7]),
        .data_in        (buff_data_in[7]),
        .data_out       (buff_data_out[7])
    );

    //Buffer 8
    buff_controller #(
        .WIDTH    (DATA_WIDTH),
        .SIZE     (BUFF_ARRAY_SIZE[8]))
    u_buff8 (
        .clk_wr         (clk2),
        .rst_wr         (rst2),
        .clk_rd         (clk1),
        .rst_rd         (rst1),
        .wr_toggle      (buff_wr_toggle[8]),
        .rd_toggle      (buff_rd_toggle[8]),
        .data_in        (buff_data_in[8]),
        .data_out       (buff_data_out[8])
    );

    //Buffer 9
    buff_controller #(
        .WIDTH    (DATA_WIDTH),
        .SIZE     (BUFF_ARRAY_SIZE[9]))
    u_buff9 (
        .clk_wr         (clk2),
        .rst_wr         (rst2),
        .clk_rd         (clk1),
        .rst_rd         (rst1),
        .wr_toggle      (buff_wr_toggle[9]),
        .rd_toggle      (buff_rd_toggle[9]),
        .data_in        (buff_data_in[9]),
        .data_out       (buff_data_out[9])
    );

    //Buffer 10
    buff_controller #(
        .WIDTH    (DATA_WIDTH),
        .SIZE     (BUFF_ARRAY_SIZE[10]))
    u_buff10 (
        .clk_wr         (clk1),
        .rst_wr         (rst1),
        .clk_rd         (clk1),
        .rst_rd         (rst1),
        .wr_toggle      (buff_wr_toggle[10]),
        .rd_toggle      (buff_rd_toggle[10]),
        .data_in        (buff_data_in[10]),
        .data_out       (buff_data_out[10])
    );

    //Buffer 11
    buff_controller #(
        .WIDTH    (DATA_WIDTH),
        .SIZE     (BUFF_ARRAY_SIZE[11]))
    u_buff11 (
        .clk_wr         (clk1),
        .rst_wr         (rst1),
        .clk_rd         (clk2),
        .rst_rd         (rst2),
        .wr_toggle      (buff_wr_toggle[11]),
        .rd_toggle      (buff_rd_toggle[11]),
        .data_in        (buff_data_in[11]),
        .data_out       (buff_data_out[11])
    );

    controller #(
        .CTRL_WIDTH (CTRL_WIDTH),
        .CTRL_DEPTH (ITER_PERIOD))
    u_ctrl (
        .clk            (clk2),
        .rst            (rst2),
        .ctrl_in        (ctrl_in),
        .load_ctrl      (load_ctrl),
        .start_ctrl     (start_ctrl),
        .stop_ctrl      (stop_ctrl),
        .buff_wr_toggle (buff_wr_toggle),
        .buff_rd_toggle (buff_rd_toggle)
    );

endmodule
//end of file.
