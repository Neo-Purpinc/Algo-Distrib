mtype = { create , created }

proctype tree(int n; chan t) {
	int node = 0;
	bool nb = false;
	chan childL = [1] of { int };
	bool l = false;
	chan childR = [1] of { int };
	bool r = false;

	t?create ->
		if
		:: n>0 -> run tree(n-1, childL); childL!create ; childL?created ; run tree(n-1, childR) ; childR!create; childR?created
		:: n <= 0 -> skip
		fi
	t!created
}

init {
	chan childT = [1] of { int };
	run tree(4, childT);
	childT!create
}
