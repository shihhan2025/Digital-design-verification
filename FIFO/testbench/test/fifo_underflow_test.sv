class fifo_underflow_test extends fifo_base_test;
    `uvm_component_utils(fifo_underflow_test)
    fifo_underflow_sequence seq;
    task run_phase(uvm_phase phase);
      
        phase.raise_objection(this);
        seq = fifo_underflow_sequence::type_id::create("seq");
        seq.start(env.agent.sequencer);
        phase.drop_objection(this);
      
    endtask

endclass
