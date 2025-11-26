class test_write extends base_test;

  i2c_basic_seq seq;

  `uvm_component_utils(test_write)
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info(get_name(), "  ** TEST **", UVM_LOW)
    seq = i2c_basic_seq::type_id::create("seq");
    seq.start(env.agt_i2c.m_seqr);
	#100us;
    
 	phase.drop_objection(this);
  endtask
endclass : test_write
