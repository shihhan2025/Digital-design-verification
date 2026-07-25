class fifo_transaction #(parameter FIFO_WIDTH=8) extends uvm_sequence_item;

rand bit wr_en;
rand bit rd_en;
rand bit [FIFO_WIDTH-1:0] data_in;
bit [FIFO_WIDTH-1:0] data_out;

`uvm_object_utils(fifo_transaction)

function new(string name="fifo_seq_item");
  super.new(name);
endfunction

endclass
