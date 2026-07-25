class fifo_transaction extends uvm_sequence_item;

rand bit wr_en;
rand bit rd_en;
rand bit [7:0] data_in;
bit [7:0] data_out;

`uvm_object_utils(fifo_transaction)

function new(string name="fifo_transaction");
  super.new(name);
endfunction

endclass
