#define REPOS 0
#define EN_COURS 1
#define TERMINE 2

mtype = { candidat, election, elu }
short nb_elu; /* compte le nb de processus elus */

proctype electeur (short num; chan inc, rec,  em)
{
    byte etat= REPOS;
    short chef, initiateur;
    do
    :: inc?candidat -> 
            if
            :: (etat == REPOS) -> etat= EN_COURS; chef= num; em!election (num)
            :: else -> skip
            fi

    :: rec?election(initiateur) -> 
            if
            :: ((etat == REPOS) || (initiateur > chef)) -> etat= EN_COURS; chef= initiateur; em!election(initiateur)
            :: else -> 
                if
                :: (num == initiateur) -> etat= TERMINE; nb_elu++; em!elu(num);
                :: else -> skip
                fi
            fi

    :: rec?elu(initiateur) ->
            if
            :: (num != initiateur) -> 
                    printf("le processus : %d a elu le processus : %d \n",num,initiateur);
                    em!elu(initiateur);
                    etat= TERMINE; break
            :: else -> printf("je suis le processus %d et je suis le chef !!! \n",num);
                    etat= TERMINE; break
            fi
    od ;
    assert(nb_elu == 1);
}

init
{
    chan from1to2 = [1] of {byte, byte};
    chan from2to3 = [1] of {byte, byte};
    chan from3to4 = [1] of {byte,byte};
    chan from4to1 = [1] of {byte,byte};
    chan in1 = [1] of {byte};
    chan in2 = [1] of {byte};
    chan in3 = [1] of {byte};
    chan in4 = [1] of {byte};

    atomic {	
        run electeur(1, in1, from4to1, from1to2 );
        run electeur(2, in2, from1to2, from2to3 );
        run electeur(3, in3, from2to3, from3to4 );
        run electeur(4, in4, from3to4, from4to1 );
        in1 ! candidat; in2 ! candidat; in3 ! candidat;  in4 ! candidat 
    }
}
