mtype = { ack, nak, err, next, accept }

proctype transfer (chan inc, out, chin, chout)
{
    byte o, i;
    inc?next(o);
    end: do
        :: chin?nak(i) -> out!accept(i); chout!ack(o)
        :: chin?ack(i) -> out!accept(i); 
            if
            ::inc?[next(o)] -> inc?next(o);chout!ack(o)
            ::else -> chout!ack(o); goto fin_transfert
            fi;
        :: chin?err(i) -> chout!nak(o)
        od;
    fin_transfert : printf("plus de donnees a envoyer\n");
}

init
{
    chan AtoB = [1] of {byte, byte};
    chan BtoA = [1] of {byte, byte};
    chan Ain = [10] of {byte,byte};
    chan Bin = [10] of {byte,byte} ;
    chan Aout = [10] of {byte,byte};
    chan Bout = [10] of {byte,byte};

    atomic {	
        run transfer(Ain, Aout, BtoA, AtoB);
        run transfer(Bin, Bout, AtoB, BtoA);
        Ain ! next(1); Ain ! next(2); Bin ! next(3); Bin ! next(4)
	};
	/* BtoA!err(0); */ AtoB!err(0);
}
