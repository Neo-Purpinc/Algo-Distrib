#define true 1
#define false 0
#define Aturn false
#define Bturn true
bool x, y, t;
byte nbSC = 0;

proctype A()
{ 
	x = true;
	t = Bturn;
	(y == false || t == Aturn);
	nbSC++;
	/* critical section */
	printf("A is in critical section\n");
	nbSC--;
	x = false
}

proctype B()
{ 
	y = true;
	t = Aturn;
	(x == false || t == Bturn);
	nbSC++;
	/* critical section */
	printf("B is in critical section\n");
	nbSC--;	
	y = false
}
proctype verif()
{
	printf("nbSC = %d\n", nbSC);
	assert(nbSC<=0);
}

init { 
	atomic {
		run A();
		run B();
		run verif();
	}
}