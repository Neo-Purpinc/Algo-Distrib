#define N 15
mtype = {joue, fin }

byte allumettes_retire;
byte allumettes_restant = N;

proctype joueur (byte proc; chan outc, inc)
{
byte var;
byte allumettes;

do
::inc?joue(var) ->
	if
	:: allumettes = 1;
	:: allumettes = 2;
	:: allumettes = 3;
	fi;
	if
	:: (var - allumettes <= 0) ->
	  atomic {allumettes_retire = allumettes_retire + var;
		  allumettes_restant = allumettes_restant - var;
		  printf("Je suis le joueur %d et j'ai retire la derniere allumette \n",proc)};
		  outc!fin(proc);break;
	:: else ->
	  atomic {printf("Le joueur %d retire %d allumettes, il en reste : %d \n",proc,allumettes,var-allumettes);
		  allumettes_retire = allumettes_retire + allumettes;
		  allumettes_restant = allumettes_restant - allumettes};
		  outc!joue(var-allumettes);
	fi;
::inc?fin(var) -> printf("(%d) : le gagnant est %d\n",proc,var); break;
od;
assert (allumettes_restant == 0);
}

proctype verif() {assert(allumettes_retire + allumettes_restant == N)}

init {chan from1to2 = [1] of {byte,byte};
	chan from2to1 = [1] of {byte,byte};

    atomic {	
	run joueur(1,from1to2,from2to1);
	run joueur(2,from2to1,from1to2);
	run verif();
	from2to1!joue(N);
	}
}
