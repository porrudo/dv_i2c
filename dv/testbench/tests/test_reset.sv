class test_reset extends base_test;

  i2c_basic_seq seq;

  `uvm_component_utils(test_reset)
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info(get_name(), "  ** TEST **", UVM_LOW)
    // Drive reset_n low, then release after 100 ns

    env.dut_vif.reset_n <= 1'b1;
    #100us;
    env.dut_vif.reset_n <= 1'b0;
    #100us;
    env.dut_vif.reset_n <= 1'b1;
    #100us;
 	phase.drop_objection(this);
  endtask
endclass : test_reset
