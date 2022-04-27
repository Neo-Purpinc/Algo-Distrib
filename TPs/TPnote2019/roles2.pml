#define SERVEUR_PRIMAIRE 1
#define SERVEUR_SECONDAIRE 2
#define CLIENT 3
short som_role;
proctype affecte_role (chan inx, iny, outx, outy)
{
    byte m1, m2,m3, role, fin;
    do
    /*:: (role == 0) -> */
    :: 
        if /* choix aleatoire de role */
        :: m1= SERVEUR_PRIMAIRE;
        :: m1= SERVEUR_SECONDAIRE;
        :: m1= CLIENT;
        fi;
        outx!m1; outy!m1; inx?m2; iny?m3;
        if
        ::(m1 != m2) && (m1 != m3) && (m2 != m3) -> 
            role=m1;
            som_role = som_role + role;
            outx!fin; outy!fin;
            break;
        /* out!fin permet de valider la verification */
        :: else -> skip;
        fi
    od;
    printf("le processus %d a le role : %d \n",_pid,role);
    (inx?[fin]) && (iny?[fin]) -> assert(som_role==6);
    /* (inx?fin) && (iny?fin) est une balise assurant que les autres processus ont aussi fini leur calcul */
}

init
{
    chan AtoB = [1] of {byte};
    chan AtoC = [1] of {byte};
    chan BtoA = [1] of {byte};
    chan BtoC = [1] of {byte};
    chan CtoA = [1] of {byte};
    chan CtoB = [1] of {byte};
    atomic
    {
        run affecte_role(BtoA,CtoA,AtoB,AtoC);
        run affecte_role(AtoB,CtoB,BtoA,BtoC);
        run affecte_role(AtoC,BtoC,CtoA,CtoB);
    }
}