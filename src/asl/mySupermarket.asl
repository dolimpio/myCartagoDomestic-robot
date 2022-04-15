// beliefs and rules
last_order_id(1).
money(10).
stock(0).
default_price_beer(5).
threshold(3).

// initial goals

!makeMoney.

!buyBeer.
!sellBeer.
!offerBeer.
!manageOrders.
!deliverBeer.

+!makeMoney : stock(X) & money(Y) & Y>0 & X<10 <-
		.println("No tengo stock pero tengo dinero, empiezo a comprar");
		!buyBeer.

+!buyBeer <-
		.println("Supermarket 1 empieza a comprar");
		+needBeer.

+auction(N)[source(S)] :  (threshold(T) & needBeer & N < T) | (.my_name(I) & winner(I) & not alliance(I,A))
   <- !bid_normally(S,N).

+auction(N)[source(S)] :  .my_name(I) & needBeer & not winner(I) & not alliance(I,A)
   <- !alliance(A);
      !bid_normally(S,N).

@palliance
+auction(N)[source(S)]
   :  alliance(_,A)
   <- ?default_price_beer(B);
      ?bid(A,C);
      .send(S, tell, place_bid(N,B+C)).

+!bid_normally(S,N) : true
   <- ?default_price_beer(B);
      .send(S, tell, place_bid(N,B)).

@prop_alliance[breakpoint]
+!alliance(A) : true
   <- .send(A,tell,alliance).





+!createStore <-
	.create_agent(store, "store.asl");
	.send(store, askOne, beer(N), beer(N)); // Modificar adecuadamente
	+beer(N).

+!deliverBeer : (last_order_id(N) & (orderFrom(Ag,Qtd) & beer(QtdB))) <- 
	-+last_order_id((N+1)); 
	-+beer((QtdB-Qtd)); 
	deliver(Product,Qtd); 
	.send(Ag,tell,delivered(Product,Qtd,OrderId)); // Modificar adecuadamente
	.send(store, achieve, delStore(beer,Qtd)); // Modificar adecuadamente
	-orderFrom(Ag,Qtd); 
	!deliverBeer.
+!deliverBeer <- !deliverBeer.

+!order(beer,Qtd)[source(Ag)] <- 
	+orderFrom(Ag,Qtd); 
	.println("Pedido de ",Qtd," cervezas recibido de ",Ag).

