// ------------------------------------------//
// Register File for SPU-Lite Processor
// ------------------------------------------//
// Authors:
// NAME:  Atif Iqbal                           
// NETID: aahangar                             
// SBUID: 111416569                            
//
// NAME: Karthik Raj
// NETID: ?
// SBUID: ?
// ------------------------------------------//

import defines_pkg::*;

module top_tb();

   parameter T = 32;
   parameter NUMINPUTVALS  = 10000;
   parameter NUMOUTPUTVALS = 20000;
   //TODO:
   parameter INFILENAME  = "TODO";
   parameter EXPFILENAME = "TODO";

   logic clk, reset;
   logic [T-1:0] data_in;
   logic [T-1:0] data_out;

   logic [T-1:0] inValues [NUMINPUTVALS-1:0];
   logic [T-1:0] expValues [NUMOUTPUTVALS-1:0];

   initial clk=0;
   always #5 clk = ~clk;
   
   //TODO: Instantiate DUT

   initial begin
     //$readmemb(INFILENAME, inValues);
     //$readmemb(EXPFILENAME, expValues);
     
     // reset
     @(posedge clk); #1; reset = 1; 
     @(posedge clk); #1; reset = 0; 

     repeat(1000) @(posedge clk);

     $finish;
   end


endmodule
