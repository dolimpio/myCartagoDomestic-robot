// beliefs and rules
last_order_id(1).
money(10).
beer(10).
default_price_beer(2).
price_to_sell(3).
threshold(3).

// initial goals

!makeMoney.

!buyBeer.
!sellBeer.
!offerBeer.
!manageOrders.
!deliverBeer.

+!makeMoney : beer(X) & money(Y) & Y>0 & X<10 <-
		.println("No tengo beer pero tengo dinero, empiezo a comprar");
		+stock(no);
		!buyBeer.

+!buyBeer <-
		.println("Supermarket 1 empieza a comprar");
		+needBeer.


+auction(N)[source(S)] :  (threshold(T) & needBeer & N < T) | (.my_name(I) & winner(I) & needBeer & not alliance(I,A)) <- 
		?default_price_beer(B);
		?money(M);
		//Pujo normal durante 3 intentos
		if(stock(no) & M > B){ //Puja por defecto si el dinero es mayor que la puja por defecto
			.send(S, tell, place_bid(N,B));
	  	} else{
	    	.send(S, tell, place_bid(N,0));
	  	}. 

+auction(N)[source(S)] :  .my_name(I) & needBeer & not winner(I) & not alliance(I,A)
   <- !alliance(A);  //Pasados 3 intentos de compra, intento alianza
      !bid_normally(S,N).

@alliance
+auction(N)[source(S)] :  alliance(_,A) <-
	 	?default_price_beer(B);
      	?bid(A,C);
      	.send(S, tell, place_bid(N,B+C)).

+!bid_normally(S,N) : true <- 
		?default_price_beer(B);
      	.send(S, tell, place_bid(N,B)).

@prop_alliance
+!alliance(A) : true <- 
		.send(A,tell,alliance).

//Creamos almacen
+!createStore <-
	.create_agent(store, "store.asl");
	.send(store, askOne, beer(N), beer(10)); // Modificar adecuadamente
	+beer(N).

//Gestion de envios a robot
+!deliverBeer : (last_order_id(N) & (orderFrom(Ag,Qtd) & beer(QtdB))) <- 
	-+last_order_id((N+1)); 
	-+beer((QtdB-Qtd));
	deliver(Product,Qtd); 
	.send(Ag,tell,delivered(Product,Qtd,OrderId)); // REVISAR para añadir el dinero que se gana de la venta con el robot
	?money(J);
	?price_to_sell(I);
	-+money((J+(I*Qtd)));
	//.send(store, achieve, delStore(beer,Qtd)); // REVISAR
	-orderFrom(Ag,Qtd); 
	!deliverBeer.
+!deliverBeer <- !deliverBeer.

+!order(beer,Qtd)[source(Ag)] <- 
	+orderFrom(Ag,Qtd); 
	.println("Pedido de ",Qtd," cervezas recibido de ",Ag).

