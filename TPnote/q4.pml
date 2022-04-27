#define N 12
#define NB 3
proctype gardien(chan mychan,hippo1,hippo2,hippo3){
    // Choix aléatoire de l'hippopotame
    if
    :: 1 -> hippo1!N            // les trois branches sont éxecutables, les chiffres ne servent qu'à la compréhension du code
    :: 2 -> hippo2!N
    :: 3 -> hippo3!N
    fi
    // Attente que l'hippopotame qui a mangé la dernière bouchée crie
    byte hippo;
    do
    :: mychan?hippo -> printf("Le gardien prévient les autres\n")
                    -> if   // On prévient les autres hippopotames 
                       :: hippo == 1 -> hippo2!0; hippo3!0;
                       :: hippo == 2 -> hippo1!0; hippo3!0;
                       :: hippo == 3 -> hippo1!0; hippo2!0;
                       fi
                    -> break;
    od
}

proctype hippopotame(chan inx, outx, outy,outz){
    byte boule;
    byte what_i_ate = 0;
    do
    :: inx?boule -> 
        if 
        :: (boule > 0 && what_i_ate < N/NB) -> boule = boule - 1               // L'hippopotame croque une bouchée
                                          -> what_i_ate = what_i_ate + 1
                                          -> if
                                             :: boule==0 -> printf("L'hippopotame %d crie vers le gardien ! Il a mangé %d bouts de boule d'herbe.\n",_pid,what_i_ate) -> outz!_pid -> break;
                                             :: else -> if
                                                        :: 1 -> outx!boule
                                                        :: 2 -> outy!boule
                                                        fi
                                             fi
        :: (boule > 0 && what_i_ate >= N/NB) -> if
                                              :: 1 -> outx!boule
                                              :: 2 -> outy!boule
                                              fi
        :: else -> printf("L'hippopotame %d est triste. Il a mangé %d bouts.\n",_pid,what_i_ate) // Cas où le gardien a annoncé aux hippos la fin de la session
                -> break;
        fi
    od
}

init
{
    chan toGardien = [1] of {byte}; // Servira à avertir le gardien qu'il n y a plus rien à manger
    chan toA = [1] of {byte};       // Sert à transmettre la boule à l'individu 1
    chan toB = [1] of {byte};       // Sert à transmettre la boule à l'individu 2
    chan toC = [1] of {byte};       // Sert à transmettre la boule à l'individu 3
    atomic
    { 
        run hippopotame(toA,toB,toC,toGardien); 
        run hippopotame(toB,toA,toC,toGardien); 
        run hippopotame(toC,toA,toB,toGardien);
        run gardien(toGardien,toA,toB,toC); 
    }
}

/*
Je suis conscient que ma solution ne fonctionne que pour un nombre de parts multiples du nombres d'individus mais j'ai malheureusement manqué de temps.
Une solution aurait été que le gardien garde un oeil sur chacun pour récupérer la nourriture lorsqu'il reste (NB_parts % NB_individus) parts,
afin d'ensuite relancer la distribution aléatoire pour les morceaux restants. 
*/