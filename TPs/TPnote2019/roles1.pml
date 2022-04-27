#define MAITRE 1
#define ESCLAVE 2
short som_role ;
proctype affecte_role (chan inc, out)
{
    byte m1, m2, role, fin ;
    do
    /* :: (role == 0) -> */
    ::
        if /* choix aleatoire de role */
        :: m1=MAITRE ;
        :: m1=ESCLAVE ;
        fi ;
        out!m1 ; inc ?m2 ;
        if
        ::(m1 != m2) -> role=m1 ;
          som_role = som_role + role ; out!fin ; break ; /* out!fin permet de valider la verification */
        :: else -> skip ;
        fi
    od ;
    printf("Le processus %d a le role : %d \n",_pid,role) ;
    inc?fin -> assert(som_role==3) ; 
    /* inc ?fin est une balise assurant que l’autre processus a aussi fini son calcul */
}
init
{
    chan AtoB = [1] of {byte} ;
    chan BtoA = [1] of {byte} ;
    atomic { run affecte_role(AtoB,BtoA) ; run affecte_role(BtoA,AtoB) }
}