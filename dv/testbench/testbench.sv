import uvm_pkg::*;
`include "uvm_macros.svh"

`include "dut_if.sv"
`include "lib_test.sv"
//`include "adc_dms_model.sv"

module top;
  //dut if instance
  dut_if dut_if(); //CJ; no habia el dut_if
  
  //dut instance
  /*digital_top dut(
    .reset_n(dut_if.reset_n),
    .clk(dut_if.clk),

    .sclk(dut_if.sclk),
    .sdata(dut_if.sdata)*/

  /*  .adc_convert(),
    .adc_ready(),
    .adc_q()
  */
  //);

  //other instances?
  
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
    $shm_open("waves.shm");
    $shm_probe("ASM");
   /* dut_if.clk <= 0;
    dut_if.reset_n <= 0;
    #5000
    dut_if.reset_n <= 1;
    #2000
    dut_if.reset_n <= 0;*/
	//reset?
  end
  
  initial begin
	//interface to database, NO TOCAR
    uvm_config_db#(virtual dut_if)::set(uvm_root::get(),"","dut_if",dut_if);
  
  run_test(); //+UVM_TESTNAME=test_dummy
  end
  
  /*always 
   begin
  #100 dut_if.clk <= ~dut_if.clk;
  end*/
endmodule : top
