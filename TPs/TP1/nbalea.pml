byte a
/* Test with a chan length of 0. Explain the result */
chan q = [1] of { byte }

inline random() {
 byte r;
 if
 :: r=0
 :: r=1
 fi;
 q!r
}

init { random(); q?a; printf("Rand : %d\n", a) }


/* To test in command line : spin -n123 random1_inline.pml */

byte d;
chan s = [0] of { byte };

proctype random_n(chan c; byte count) {
 byte b=0;
 byte r=0;
 do
 :: count>0 -> if
 	:: b=0
 	:: b=1
 	fi;
 	r=r*2+b;
 	count=count-1
 :: else -> break
 od;
 c!r
}

init
{  
    atomic{ random(); q?a; printf("Rand : %d\n", a)} 
    atomic{ run random_n(s,8); s?d; printf("Rand : %d\n", d)} 
}