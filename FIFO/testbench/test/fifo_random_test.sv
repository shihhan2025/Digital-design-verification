class fifo_random_test extends fifo_base_test;
  `uvm_component_utils(fifo_random_test)
  fifo_random_sequence seq;
  
  function new(string name="fifo_random_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = fifo_random_sequence::type_id::create("seq");
    seq.start(env.agent.sequencer);
    phase.drop_objection(this);
  endtask
  
endclass
