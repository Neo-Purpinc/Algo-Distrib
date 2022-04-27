mtype = { euro1, cents50, chocolat, bonbon };
chan argent_channel = [1] of { mtype };
chan sucrerie_channel = [1] of { mtype };
proctype client() {
    do
    :: argent_channel!cents50 -> sucrerie_channel?chocolat;
    :: argent_channel! euro1 -> sucrerie_channel?bonbon;
    od
}
proctype distributeur() {
    do
    :: argent_channel? cents50 -> sucrerie_channel!chocolat;
    :: argent_channel? euro1 -> sucrerie_channel!bonbon;
    od
}

init { atomic { run client(); run distributeur(); }}