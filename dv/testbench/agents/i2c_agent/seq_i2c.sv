`ifndef _I2C_SEQ
`define _I2C_SEQ

`include "transaction_i2c.sv"

class i2c_basic_seq extends uvm_sequence#(i2c_basic_tr);
  // Datos a enviar en la transacción
  byte addr;
  byte data;
  bit  write;
  `uvm_object_utils(i2c_basic_seq)
  
  function new(string name = "i2c_basic_seq");
    super.new(name);
  endfunction

  virtual task body();
    
    `uvm_info(get_type_name(), "i2c_basic_seq created", UVM_LOW)
    // Conduce el contenido deseado en el transaction request
    `uvm_do_with(req, {
      req.addr == addr;
      req.data == data;
      req.read == !write;
    });
  endtask : body
endclass : i2c_basic_seq

`endif // _I2C_SEQ
