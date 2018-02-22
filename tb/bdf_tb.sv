// ------------------------------------------//
// 
// ------------------------------------------//
// Authors:
// NAME:  Atif Iqbal                           
// NETID: aahangar                             
// SBUID: 111416569                            
//
// ------------------------------------------//

import defines_pkg::*;

module bdf_tb();

    logic                  clk; 
    logic                  rst;
    logic                  load_ctrl;
    logic                  start_ctrl;
    logic                  stop_ctrl;
    logic [DATA_WIDTH-1:0] data_in;
    logic [DATA_WIDTH-1:0] data_out;
    logic [CODE_WIDTH-1:0] code_word;
    logic [CODE_WIDTH-1:0] code_words [0:CODE_LENGTH-1];

    initial clk=0;
    always #5 clk = ~clk;
    
    // instantiate dut
    bdf #(
        .NUM_BUFFS     (NUM_BUFFERS),
        .CTRL_WIDTH    (CODE_WIDTH),
        .ITER_PERIOD   (ITERATION_BOUND),
        .DATA_WIDTH    (DATA_WIDTH))
    u_bdf (
        .clk           (clk),
        .rst           (rst),
        .ctrl_in       (code_word),
        .load_ctrl     (load_ctrl),
        .start_ctrl    (start_ctrl),
        .stop_ctrl     (stop_ctrl),
        .data_in       (data_in),
        .data_out      (data_out)
    );
   
    initial begin
        load_ctrl  = 0;
        start_ctrl = 0;
        code_word  = 0;
        start_ctrl = 0;
        stop_ctrl  = 0;
        data_in    = 0;
        $readmemb(PROGFILENAME, code_words);
      
        // reset
        @(posedge clk) rst = 1; 
        @(posedge clk) rst = 0; 

        // load control data
        for(int i = 0; i < CODE_LENGTH; i++) begin
            @(posedge clk) code_word = code_words[i];
            load_ctrl = 1;
        end
        @(posedge clk) load_ctrl = 0;
      
        // run dut
        start_ctrl = 1;
        repeat(1000) @(posedge clk);
        start_ctrl = 0;
        stop_ctrl  = 1;

        repeat(1000) @(posedge clk);

        $finish;
    end

endmodule
