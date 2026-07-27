`ifndef FIFO_SEQUENCE_SV
`define FIFO_SEQUENCE_SV

class fifo_base_sequence extends uvm_sequence #(fifo_seq_item);
  `uvm_object_utils(fifo_base_sequence)

  function new(string name = "fifo_base_sequence");
    super.new(name);
  endfunction

endclass

class fifo_random_sequence extends fifo_base_sequence;
  `uvm_object_utils(fifo_random_sequence)
  
  function new(string name = "fifo_random_sequence");
    super.new(name);
  endfunction
  
  int num_transactions = 100; 

  virtual task body();
    fifo_seq_item req_item;
    `uvm_info("SEQ", $sformatf("Starting random sequence with %0d items", num_transactions), UVM_LOW);
    for(int i=0;i<num_transactions;i++) begin
      req_item = fifo_seq_item::type_id::create( "req_item"$sformatf("req_item_%0d", i) );
      start_item(req_item);

      if (!req_item.randomize() with 
          {wr_en || rd_en}) 
        begin
        `uvm_fatal("SEQ", "Randomization failed!");
      end

      finish_item(req_item);
    end
  endtask
endclass

class fifo_direct_sequence extends fifo_base_sequence;
  `uvm_object_utils(fifo_direct_sequence)
  int fifo_depth = 16;
  function new (string name = "fifo_direct_sequence");
    super.new(name);
  endfunction

  virtual task body();
    fifo_seq_item req_item;
    `uvm_info("SEQ", "Starting direct sequence: Fill FIFO then Empty FIFO", UVM_LOW);
    for(int i=0;i<fifo_depth;i++) begin
      req_item = fifo_seq_item::type_id::create( "req_item"$sformatf("req_item_%0d", i) );
      start_item(req_item);
      if (!req_item.randomize() with {
        wr_en == 1;
        rd_en == 0;
      })
        `uvm_fatal("SEQ", "Randomization failed!")
      finish_item(req_item);
    end

    repeat (fifo_depth) begin
      req_item = fifo_seq_item::type_id::create("req_item");
      start_item(req_item);
      assert(req_item.randomize() with { wr_en == 1'b0; rd_en == 1'b1; });
      finish_item(req_item);
    end
  endtask
endclass
    
`endif
