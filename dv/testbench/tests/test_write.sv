class test_write extends base_test;

  i2c_basic_seq seq;

  `uvm_component_utils(test_write)
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  
  endfunction
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info(get_name(), "  ** TEST WRITE **", UVM_LOW)

    if (env.dut_vif == null) begin
      `uvm_fatal(get_name(), "dut_vif not set in environment")
    end
    env.dut_vif.reset_n <= 1'b0;
    #1us;
    env.dut_vif.reset_n <= 1'b1;
    // Esperamos 200 ns antes de iniciar las escrituras
    #200ns;

    // Genera 5 escrituras con datos aleatorios (8 bits) cada 150 ns
    for (int i = 0; i < 5; i++) begin
      byte rand_data;
      if (!std::randomize(rand_data)) begin
        `uvm_error(get_name(), "No se pudo randomizar rand_data")
        rand_data = $urandom;
      end

      seq = i2c_basic_seq::type_id::create($sformatf("seq_%0d", i));
      seq.data  = rand_data;
      seq.write = 1'b1; // operación de escritura
      seq.start(env.agt_i2c.m_seqr);

      // Separación de 150 ns entre escrituras
      #150ns;
    end

    // Tras la última espera, fuerza SDA al valor alto (1) manteniendo control
    env.dut_vif.sda_drive <= 1'b1;
    env.dut_vif.sda_val   <= 1'b1;

    phase.drop_objection(this);
  endtask
endclass : test_write
