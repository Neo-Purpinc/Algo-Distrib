#define N 5
short tab[N];

proctype iteration(short n)
{
    short i=1, somme;
    do
    ::(i<=n) -> somme= somme + i; i= i+1
    ::else -> break
    od;
    printf("somme : %d\n", somme)

}
proctype maxtab(){
    short i=1, max=tab[0];
    do
    ::(i<N) -> 
        if
        ::(tab[i]>max) -> max=tab[i];
        ::else -> skip;
        fi
        i=i+1;
    ::else -> break;
    od;
    printf("max : %d\n", max)
}

init { atomic{run iteration(N); tab[0]=1; tab[1]=2; tab[2]=30; tab[3]=4; tab[4]=5; run maxtab();} }