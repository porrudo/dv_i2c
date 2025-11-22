`ifndef _I2C_MON
`define _I2C_MON

class i2c_monitor extends uvm_monitor;
  `uvm_component_utils(i2c_monitor)

  uvm_analysis_port #(i2c_basic_tr) port;
  virtual dut_if dut_vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    port = new("port", this);
  endfunction : build_phase
  
  function void connect_phase(uvm_phase phase);
    //assert(uvm_config_db#(virtual dut_if)::get(this, "", "dut_if", dut_vif));  MIRAR CJ;
  endfunction
  
  task run_phase(uvm_phase phase);
    /*// CJ; FORKEAR
    fork
      forever
      begin
        i2c_basic_tr tr;
        byte data;

        //wait for start condition
        @(negedge dut_vif.sda_val && dut_vif.scl_val) //Utilizamos el sda_val, puede ser el drive, pero ni idea        port.write();

        //decode i2c transaction
        //TODO
        for(int i = 0; i < 8; i ++ ) 
          begin
            @(posedge dut_vif.scl_val)
            data[i] = dut_vif.sda_val;
          end
        tr.data = data;

        //send message with i2c content
        port.write(tr);
      
      end

    join_any*/

  endtask : run_phase
  
endclass: i2c_monitor

`endif // _I2C_MON