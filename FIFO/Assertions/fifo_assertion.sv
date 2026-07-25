property p_overflow_protection;
  @(posedge clk) disable iff (!rst_n)
  (full && wr_en && !rd_en) |=> $stable(fifo_cnt);
endproperty
assert property (p_overflow_protection) else `uvm_error("ASSERT", "FIFO overflow occurred!");

property p_underflow_protection;
  @(posedge clk) disable iff (!rst_n)
  (empty && rd_en && !wr_en) |=> $stable(fifo_cnt);
endproperty
assert property (p_underflow_protection) else `uvm_error("ASSERT", "FIFO underflow occurred!");
