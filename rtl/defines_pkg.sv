// ------------------------------------------//
// Matrix Vector Multiplier Defines Part-1
// ------------------------------------------//
// NAME:  Atif Iqbal
// NETID: aahangar
// SBUID: 111416569
// ------------------------------------------//

package defines_pkg;

    parameter PROGFILENAME    = "prog_file1.txt";
    parameter ITERATION_BOUND = 128;
    parameter NUM_BUFFERS     = 12;
    parameter DATA_WIDTH      = 16;
    parameter CODE_LENGTH     = ITERATION_BOUND;
    parameter CODE_WIDTH      = NUM_BUFFERS*2;

endpackage
