`ifndef FIFO_BASE_TEST_SV
`define FIFO_BASE_TEST_SV

class fifo_base_test extends uvm_test;
  `uvm_component_utils(fifo_base_test)

  fifo_env env;

  function new(string name="fifo_base_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = fifo_env::type_id::create("env", this);
  endfunction

  virtual task run_phase(uvm_phase phase);   
    phase.raise_objection(this);
    // wait reset finish
    #100;
    phase.drop_objection(this);
  endtask

endclass
`endif
