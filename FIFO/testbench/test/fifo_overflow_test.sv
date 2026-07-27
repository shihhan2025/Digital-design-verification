class fifo_overflow_test extends fifo_base_test;
    `uvm_component_utils(fifo_overflow_test)
    fifo_overflow_sequence seq;
    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        seq = fifo_overflow_sequence::type_id::create("seq");
        seq.start(env.agent.sequencer);
        phase.drop_objection(this);
    endtask
endclass
