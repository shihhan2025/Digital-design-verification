`ifndef FIFO_SCOREBOARD_SV
`define FIFO_SCOREBOARD_SV

class fifo_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(fifo_scoreboard)
  uvm_analysis_imp #(fifo_seq_item, fifo_scoreboard) item_imp;

  bit[7:0] expected_queue[$];

  int match_count = 0;
  int mismatch_count = 0;
  
  function new(string name = "fifo_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super_build_phase(phase);
    item_imp = new("item_imp", this);
  endfunction

  virtual function void write(fifo_seq_item tr);
    if (tr.wr_en) begin
      expected_queue.push_back(tr.data_in);
      `uvm_info("SCB", $sformatf("Pushed to Queue: 0x%0h | Current Queue Size = %0d", tr.data_in, expected_queue.size()), UVM_HIGH);
    end

    if (tr.rd_en) begin
      if (expected_queue.size() == 0) begin
        `uvm_error("SCB", $sformatf("Underflow Error! Read detected but Expected Queue is EMPTY! Actual data_out = 0x%0h", tr.data_out))
        mismatch_count++;
      end
      else begin
        bit [7:0] expected_data;
        expected_data = expected_queue.pop_front();
        if (tr.data_out === expected_data) begin
          match_count++;
          `uvm_info("SCB_PASS", $sformatf("MATCH! Expected = 0x%0h, Actual = 0x%0h", expected_data, tr.data_out), UVM_LOW)
        end
        else begin
          mismatch_count++;
          `uvm_error("SCB_FAIL", $sformatf("MISMATCH! Expected = 0x%0h, Actual = 0x%0h", expected_data, tr.data_out))
        end
      end
    end
  endfunction
  
  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("SCB_SUMMARY", "--------------------------------------------------", UVM_LOW)
    `uvm_info("SCB_SUMMARY", $sformatf("  TOTAL MATCHES    : %0d", match_count), UVM_LOW)
    `uvm_info("SCB_SUMMARY", $sformatf("  TOTAL MISMATCHES : %0d", mismatch_count), UVM_LOW)
    `uvm_info("SCB_SUMMARY", $sformatf("  LEFTOVER IN QUEUE: %0d", expected_queue.size()), UVM_LOW)
    `uvm_info("SCB_SUMMARY", "--------------------------------------------------", UVM_LOW)

    if (mismatch_count > 0) begin
      `uvm_error("SCB_SUMMARY", "TEST FAILED WITH MISMATCHES!")
    end else begin
      `uvm_info("SCB_SUMMARY", "TEST PASSED SUCCESSFULLY!", UVM_LOW)
    end
  endfunction

endclass

`endif
  
