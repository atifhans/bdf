// ------------------------------------------//
// 
// ------------------------------------------//
// Authors:
// NAME:  Atif Iqbal                           
// NETID: aahangar                             
// SBUID: 111416569                            
// ------------------------------------------//

import defines_pkg::*;

module pe_2in1out #(parameter WIDTH   = 16,
                    parameter LATENCY = 15)
(
    input  logic                clk,
    input  logic                rst,
    input  logic [WIDTH-1:0]    data_in_1,
    input  logic [WIDTH-1:0]    data_in_2,
    output logic [WIDTH-1:0]    data_out_1
);

    logic [WIDTH-1:0] data_int[LATENCY];

    assign data_out_1 = data_int[LATENCY-1];

    always_ff @(posedge clk) begin
        if(rst) begin
            for(int i = 0; i < 15; i++) begin
                data_int[i] = 'd0;
            end
        end
        else begin
            data_int[0] <= data_in_1 | data_in_2;
            for(int i = 1; i < 15; i++) begin
                data_int[i] <= data_int[i-1];
            end
        end
    end

endmodule
//end of file.
