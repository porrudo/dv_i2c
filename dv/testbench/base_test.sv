`include "environment.sv"

class base_test extends uvm_test;
  
  environment env;

  `uvm_component_utils(base_test)
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    env = environment::type_id::create("env", this);  //CJ; create environment
  endfunction

  //CJ: Función de espera a reset
  /*
  function void wait_unreset();
    while(env.dut_if.reset_n == 0);    
  endfunction
  */
endclass
