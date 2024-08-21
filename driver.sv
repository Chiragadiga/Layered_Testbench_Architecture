class driver;

	
	virtual ac_if.test acif;
	transaction tr;
	mailbox mbx, rtn, mbx_scb;
	
	extern function new(mailbox mbx, rtn, mbx_scb, input virtual ac_if.test acif);
	extern virtual task run();
	extern virtual task wrap_up();
endclass : driver

function driver::new(mailbox mbx, rtn, mbx_scb, input virtual ac_if.test acif);
	this.mbx=mbx;
	this.rtn=rtn;
	this.mbx_scb=mbx_scb;
	this.acif = acif;
	tr=new();
endfunction : new


task driver::run(); 
	int sum;
  //write the run task here
  acif.rst = 1; // Apply reset
  @(acif.cb); 
  sum = acif.cb.sum;
  if (sum==0)
  $display("** PASS: Reset operation successful (sum = 0)");
  else
  $display("** FAIL: Reset operation failed, sum is not zero and the value is %h", acif.cb.sum);
  @(acif.cb); 
  // Wait for reset to complete
  acif.rst = 0;
  



  // Self-check reset
  //if (acif.sum == 0)
   // $display("** PASS: Reset operation successful (sum = 0)");
 // else
   // $display("** FAIL: Reset operation failed, sum is not zero and the value is //%h", acif.sum); 

  // Loop for transactions
  forever begin
    // Get transaction from generator
    mbx.get(tr);

    //  returns trans to gen
    rtn.put(tr);

    // Send transaction to scoreboard
    mbx_scb.put(tr);


    // Drive the DUT interface with the transaction
    acif.cb.in <= tr.in;
    @(acif.cb);
    end
//your code ends

endtask : run
	
task driver::wrap_up();
	wait (acif.cb.sum == 16'hFFFF);
	@acif.cb;

	$display("*********Sum output saturated to 16'hFFFF; Finishing simulation**********");
	$finish;
	
endtask : wrap_up




	
