// beliefs and rules
beer(0).

// initial goals


// plans from file:store.asl

+!delStore(beer,N) : beer(M) <- 
	-+beer((M-N)); 
	.save_agent("store.asl").
	
+!addStore(beer,N) : beer(M) <- 
	-+beer((M+N)); 
	.save_agent("store.asl").

