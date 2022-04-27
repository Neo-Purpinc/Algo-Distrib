#define p 0
#define v 1

chan sema = [0] of {bit};
byte count = 0;

proctype dijkstra() {
	end: do
	:: sema!p -> 
	   progress: sema?v;
	od
}

proctype user(){
	do
	:: sema?p;
	   count = count+1;
	   skip; /*critical section*/
	   count = count-1;
	   sema!v;
	   skip; /*non critical section*/
	od
}

proctype verif(){
	assert(count == 1 || count == 0)
}
init{
	atomic{
		run dijkstra();
		run verif();
		run user();	
		run user();
		run user()
	}
}