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

    // connect to RTL
    modport DUT (
        input  clk, rst_n, wr_en, data_in, rd_en,
        output data_out, empty, full
    );

    // testbench driver
    modport TB (
        input  clk, data_out, empty, full,
        output rst_n, wr_en, data_in, rd_en
    );
    
endinterface
