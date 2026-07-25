interface fifo_if #(parameter DATA_WIDTH = 8)
(
    input logic clk
);
    logic rst_n;
    // write side
    logic wr_en;
    logic [DATA_WIDTH-1:0] data_in;
    // read side
    logic rd_en;
    logic [DATA_WIDTH-1:0] data_out;
    // status
    logic empty;
    logic full;
endinterface
