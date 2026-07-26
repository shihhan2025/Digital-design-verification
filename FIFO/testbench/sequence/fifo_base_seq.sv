`ifndef FIFO_SEQUENCE_SV
`define FIFO_SEQUENCE_SV

class fifo_base_sequence extends uvm_sequence #(fifo_seq_item);
  `uvm_object_utils(fifo_base_sequence)

  function new(string name = "fifo_base_sequence");
    super.new(name);
  endfunction

endclass

`endif
