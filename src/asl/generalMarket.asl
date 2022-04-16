//Cervezas iniciales del mercado
beer(20).


+!start_auction(N) <-
      .println("Notifico inicio de venta de cerveza en el mercado");
      .broadcast(tell, auction(N)).

@pb
+place_bid(N,_) :  .findall(b(V,A), place_bid(N,V)[source(A)], L) & .length(L,1) <-
      .max(L,b(V,W));
	?beer(M);
      .print("Vendido a ",W," total de ", V);
      show_winner(N,W);
      .broadcast(tell, winner(W));
	-+beer((M-V)); 
      .abolish(place_bid(N,_)).
