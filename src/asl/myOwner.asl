/* Initial beliefs and rules */

estate(4).

/* Initial goals */

!drink(beer). 

!bored.

!decay.

!setupTool("Owner", "Robot").

/* Plans */

// if I have not beer finish, in other case while I have beer, sip

+!setupTool(Name, Id)
	<- 	makeArtifact("GUI","gui.Console",[],GUI);
		setBotMasterName(Name);
		setBotName(Id);
		focus(GUI). 

//Si el owner esta aburrido le habla al robot	
+!bored : estate(4) <-
	.random(R);
	.wait(R*1000+5000);
	.println("Owner esta aburrido y animado y le dice: Hola que haces robot?!");
	.send(myRobot,tell,msg("Hola que haces robot?!"));
	!bored.
	
+!bored : estate(3) <-
	.random(R);
	.wait(R*1000+5000);
	.println("Owner esta aburrido y euforico y le dice: Hola robotito, como estas");
	.send(myRobot,tell,msg("Hola robotito, como estas"));
	!bored.
	
+!bored : estate(2) <-
	.random(R);
	.wait(R*1000+5000);
	.println("Owner esta aburrido y crispado y le dice: Maldito cacharro di algo");
	.send(myRobot,tell,msg("Maldito cacharro di algo"));
	!bored.
	
+!bored : estate(1) <-
	.random(R);
	.wait(R*1000+5000);
	.println("Owner esta aburrido y amodorrado y le dice: Hola zz que suenho zz");
	.send(myRobot,tell,msg("Hola zz que suenho zz"));
	!bored.
	
+!bored : estate(0) <-
	.random(R);
	.wait(R*1000+5000);
	.println("Owner esta aburrido y dormido y le dice: Hola zzzz zzzz zzzz");
	.send(myRobot,tell,msg("Hola zzzz zzzz zzzz"));
	!bored.
	
//Si el owner no puede beber, no bebe
+!drink(beer) : ~couldDrink(beer) <-
	.println("Owner ha bebido demasiado por hoy.").
	
//Si el owner tiene cerveza y ah sido preguntado bebe
+!drink(beer) : has(myOwner,beer) & asked(beer) <-
	.println("Owner va a empezar a beber cerveza.");
	-asked(beer);
	sip(beer);
	-+estate(4);
	.println("Eh bebido cerveza y estoy en estado 5: Animado");
	!drink(beer).
	
//Si el owner tiene cerveza y no pidio cerveza bebe
+!drink(beer) : has(myOwner,beer) & not asked(beer) <-
	sip(beer);
	.println("Owner está bebiendo cerveza.");
	!drink(beer).
	
//Si el owner not tiene cerveza la pide eh intenta beber(Esperara por la cerveza en la mayor parte de los casos)
+!drink(beer) : not has(myOwner,beer) & not asked(beer) <-
	.println("Owner no tiene cerveza.");
	!get(beer);
	!drink(beer).
	
//Si el owner no tiene cerveza Espera
+!drink(beer) : not has(myOwner,beer) & asked(beer) <- 
	//El owner tira una de las latas que tiene cerca y ya ah bebido
	.println("Owner tira una cerveza");
	//throw(beer);
	.println("Owner está esperando una cerveza.");
	.wait(5000);                                                                          
	!drink(beer).
	                                                                                                         
+!get(beer) : not asked(beer) <-
	.send(myRobot, achieve, bring(myOwner,beer)); //modificar adecuadamente
	//.send(myRobot, tell, msg("Necesito urgentemente una cerveza"));
	.println("Owner ha pedido una cerveza al robot.");
	+asked(beer).                                                                              

//Esta regla debe modificarse adecuadamente
+msg(M)[source(Ag)] <- 
	.print("Message from ",Ag,": ",M);
	+~couldDrink(beer);
	-msg(M).

+answer(Request) <-
	.println("El Robot ha contestado: ", Request);
	show(Request).
	
-answer(What) <- .println("He recibido desde el robot: ", What).

+!decay: true <-
	.random(R);
	.wait(R*1000+5000);
	?estate(X);
	if(X \== 0){
		-+estate(X-1);
	}

	!decay.
