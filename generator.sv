class transaction;
	rand bit [7:0] in;
	bit [15:0] sum;
endclass

class generator;
	transaction tr;
	mailbox mbx, rtn;
	extern function new(mailbox mbx, rtn);
	extern virtual task run();
	extern virtual task wrap_up();
endclass : generator

function generator::new(mailbox mbx, rtn);
	this.mbx=mbx;
	this.rtn=rtn;
endfunction : new

task generator::run(); 

// Instead of Randomization here, create a dynamic array in the environment where all the inputs are added to each other and they cant cross 16'hffff using a constraint random stimulus of sum<=16'hffff

//write the run task here		
 	// Randomize transaction
 	forever begin
 	tr=new();
	/*
	status= tr.randomize();
	if (!status)
	$fatal ("Randomization error");
	*/
    if (!tr.randomize())
    $fatal("Failed to randomize transaction");
    
    // Send transaction to driver via mailbox
    mbx.put(tr);
    // define object
    //ack_trans = new();
	rtn.get(tr);
	end
//end of your code


endtask : run

task generator::wrap_up();
	//empty for now
endtask : wrap_up





	
