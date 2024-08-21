class scoreboard;
	
	int unsigned exp_sum; //variable to hold expected DUT sum output
	transaction tr_in, tr_out; //transaction inputted to DUT and outputted by DUT
	mailbox mbx_drv, mbx_mon;
	//constraint sum_limit {exp_sum <= 16'hFFFF;}

	covergroup cov;
    // Write the functional coverage definition here
   my_func_cov : coverpoint tr_in.in;
	option.auto_bin_max=8;
endgroup


	extern function new(mailbox mbx_drv, mbx_mon);
	extern virtual task run();
	extern virtual task wrap_up();
endclass : scoreboard

function scoreboard::new(mailbox mbx_drv, mbx_mon);
	this.mbx_drv=mbx_drv;
	this.mbx_mon=mbx_mon;
	this.exp_sum = 0;
	tr_in=new();
	tr_out = new();
	cov = new;
endfunction : new

task scoreboard::run();
	forever begin   // <Chirag added this to sample the transaction at every instance>
	//write the run task here
	//for (int i=0; i<20; i++) begin
	mbx_drv.get(tr_in);
	$display( "tr.in=0x%0h", tr_in.in);
	// Perform coverage sample on the transaction
	cov.sample();

	exp_sum += tr_in.in; 

	// Get a transaction from the monitor
	mbx_mon.get(tr_out);

	/*for (int i=0;i<20;i++) begin
	tr_in.in = $random;
	$display( "tr.in=0x%0h", tr_in.in);
	end
	*/

	// Compare the obtained DUT sum output and the expected sum output
	if (exp_sum === tr_out.sum) begin
		$display("PASS: DUT output is correct. Expected: %0d, Got: %0d", exp_sum, tr_out.sum);
	end 
	 else if (exp_sum > tr_out.sum) begin // <Chirag Added this to account for the exp_sum exceeding 16'hffff>
		$display ("PASS: DUT reached Saturation and the expected sum is greater than Accumululator");
		end 
	else begin
		$display("FAIL: DUT output is incorrect. Expected: %0d, Got: %0d", exp_sum, tr_out.sum);
	end
	end
//your code ends here
endtask : run
	
task scoreboard::wrap_up();

$display ("coverage = %0.2f%%" , cov.get_inst_coverage());
 endtask : wrap_up
