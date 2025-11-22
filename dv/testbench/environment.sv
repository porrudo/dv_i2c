`include "agents/i2c_agent/agent_i2c.sv"
class environment extends uvm_env;  
  `uvm_component_utils(environment)
  
  //agents
  i2c_agent agt_i2c;//CJ;
  //i2c_scoreboard scb; // CJ; no definido aún. crearlo

  //i2c_config cfg_i2c; // CJ; Vacio

  virtual dut_if dut_vif; //CJ; qué hace? es necesario añadirlo?
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
	
  function void build_phase(uvm_phase phase);
	//CJ; create other agents
    agt_i2c = i2c_agent::type_id::create("agt_i2c",this); //CJ; create other agents;
  endfunction

  function void connect_phase(uvm_phase phase);
    //agente.monitor.port.connect(scb.i2c_seq.analysis_export);   //CJ; get interface from database ; Añadir la conexión con el puntero
    agt_i2c.driver.dut_vif = dut_vif;
    agt_i2c.monitor.dut_vif = dut_vif; //CJ; conecta driver y monitor con dut if (func?)
  endfunction
endclass : environment
