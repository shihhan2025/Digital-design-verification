module tb_top;
logic clk;

always #5 clk = ~clk;

fifo_if fifo_vif(clk);

fifo dut(
    .clk(clk),
    .rst_n(fifo_vif.rst_n),
    .wr_en(fifo_vif.wr_en),
    .rd_en(fifo_vif.rd_en),
    .data_in(fifo_vif.data_in),
    .data_out(fifo_vif.data_out),
    .empty(fifo_vif.empty),
    .full(fifo_vif.full)
);

endmodule
