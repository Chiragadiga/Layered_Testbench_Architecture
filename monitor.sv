class monitor;
	virtual ac_if.test acif;
	transaction tr;
	mailbox mbx;
	extern function new(mailbox mbx, input virtual ac_if.test acif);
	extern virtual task run();
	extern virtual task wrap_up();
endclass : monitor

function monitor::new(mailbox mbx, input virtual ac_if.test acif);
	this.mbx=mbx;
	this.acif = acif;
	tr=new();
endfunction : new

task monitor::run();

//write the run task here
// Wait for reset to be applied and removed
	int sum;
  wait (acif.rst === 1);
  wait (acif.rst === 0);
  @(acif.cb);
  // Loop for transactions (continuous monitoring)
  forever begin
    // Read DUT sum output
    @(acif.cb); // Synchronize with clock
   	sum = acif.cb.sum;
    tr.sum = sum;
    mbx.put(tr);
  end
//your code ends here


endtask : run
	
task monitor::wrap_up();
	//empty for now
endtask : wrap_up




	
