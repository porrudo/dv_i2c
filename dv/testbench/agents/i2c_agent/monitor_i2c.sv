`ifndef _I2C_MON
`define _I2C_MON

class i2c_monitor extends uvm_monitor;
  `uvm_component_utils(i2c_monitor)

  uvm_analysis_port #(i2c_basic_tr) port;
  virtual dut_if dut_vif;
  byte data;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    port = new("port", this);
  endfunction : build_phase
  
  function void connect_phase(uvm_phase phase);
  //Database to Virtual interface
    assert(uvm_config_db#(virtual dut_if)::get(this, "", "dut_if", dut_vif)); 
  endfunction
  
  task run_phase(uvm_phase phase);
    byte         first_byte, second_byte, third_byte;
    logic[4:0]   i2c_addr;
    logic[1:0]   i2c_slv_addr;
    logic        rd_wr, ack;
    i2c_basic_tr tr;
    // CJ; FORKEAR
    fork
      forever begin
        tr = new();
        
        // Check polarity
        @(dut_vif.sdata == 1);
        @(negedge dut_vif.sdata);
        //if(dut_vif.sclk) break;
        // Read first byte: addr, r/w
        get_i2c_byte(first_byte);
        get_i2c_ack(ack);
        
        i2c_addr = first_byte[7:3];
        i2c_slv_addr = first_byte[2:1];
        rd_wr = first_byte[0];
        
        // Read second byte: register address
        get_i2c_byte(second_byte);
        get_i2c_ack(ack);
        
        // Read third byte: register data
        get_i2c_byte(third_byte);
        get_i2c_ack(ack);
        
        // Send value from agent through the port
        tr.addr = second_byte;
        tr.data = third_byte;
        data = third_byte;
        tr.read = rd_wr;
        port.write(tr);
        
        `uvm_info("I2C", $sformatf("Mon reads %p", tr), UVM_LOW);
      end
    join_none;
    /*fork
      forever //Read MSG
      begin
        tr = new();
        @(negedge dut_vif.sda_val)
        if(dut_vif.scl_val) break;
        /*i2c_basic_tr tr;
        byte data;
        bit i2c_ack;
        //wait for start condition
        forever begin
          @(negedge dut_vif.sda_val)
          if(dut_vif.scl_val) break;
        end
        $display("Start time : ",$time);
        //decode i2c transaction

        //read Device Addres and R/W proccess
         for(int i = 0; i < 8; i ++ ) 
          begin
            @(posedge dut_vif.scl_val)
            data[i] = dut_vif.sda_val;
          end
        tr.data = data;

        //Obtain ACK and send msg if valid
        get_ack(i2c_ack);
        $display("Ack: ",i2c_ack);
        if(i2c_ack) port.write(tr);

        //read Word Addres 

        //TODO
        for(int i = 0; i < 8; i ++ ) 
          begin
            @(posedge dut_vif.scl_val)
            data[i] = dut_vif.sda_val;
          end
        tr.data = data;

        //Obtain ACK and send msg if valid
        get_ack(i2c_ack);
        $display("Ack: ",i2c_ack);
        if(i2c_ack) port.write(tr);
  

        //De momento reutilizo variables porque total se hace un write

        //Lectura de dato

        for(int i = 0; i < 8; i ++ ) 
          begin
            @(posedge dut_vif.scl_val)
            data[i] = dut_vif.sda_val;
          end
        tr.data = data;
          get_ack();
        //send message with i2c content
        get_ack(i2c_ack);
        $display("Ack: ",i2c_ack);
        if(i2c_ack) port.write(tr);

        //Esperamos un ciclo de reloj por el ACK
        //No setoy seguro
        @(posedge dut_vif.scl_val)
        @(negedge dut_vif.scl_val)

        //Condicion de stop
        forever begin
          @(posedge dut_vif.sda_val)
          if(dut_vif.scl_val) break;
        //end
      end

    join_any*/

  endtask : run_phase

  local task get_i2c_byte(output logic [7:0] b);
    b = 0;
    repeat(8) begin
      b = (b << 1);   //serialize -> shift
      @(posedge dut_vif.sclk); 
      b[0] = dut_vif.sdata; //new bit, at the end
    end
  endtask : get_i2c_byte
  
  local task get_i2c_ack(output logic ack);
    @(posedge dut_vif.sclk); ack = dut_vif.sdata;
  endtask : get_i2c_ack

  endclass: i2c_monitor

`endif // _I2C_MON