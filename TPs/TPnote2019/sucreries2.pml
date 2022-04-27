mtype = { chocolat, bonbon };
chan argent_channel = [1] of { short };
chan sucrerie_channel = [1] of { mtype };
short budget = 500, argent_dis = 0;
proctype client() {
    end0: do
    :: budget>= 50 -> 
        argent_channel!50 ->
            sucrerie_channel?chocolat;
    :: budget>= 100 -> 
        argent_channel!100 ->
            sucrerie_channel?bonbon;
    :: budget<50 -> 
        break
    od
}
proctype distributeur() {
    byte chocolats = 10, bonbons = 5;
    assert(budget+argent_dis == 500);
    end1: do
    :: ((chocolats > 0) && argent_channel?[50]) ->
        argent_channel?50;
        argent_dis = argent_dis + 50;
        budget=budget-50;
        sucrerie_channel!chocolat;
        chocolats = chocolats-1;
        assert(budget+argent_dis == 500);
    :: ((bonbons > 0) && argent_channel?[100]) ->
        argent_channel?100;
        argent_dis = argent_dis + 100;
        budget=budget-100;
        sucrerie_channel!bonbon;
        bonbons = bonbons-1;
        assert(budget+argent_dis == 500);
    :: (chocolats==0) && (bonbons==0) -> 
        break
    od
}
init { atomic { run client(); run distributeur(); }}