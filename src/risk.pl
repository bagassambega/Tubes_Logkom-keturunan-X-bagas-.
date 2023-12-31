card(0, cease).
card(1, ss).
card(2, aux).
card(3, rebel).
card(4, dis).
card(5, sup).


% Untuk data card yang dimiliki player merupakan array berisi 6 integer
% player(p1, '', TotalTerritories, TotalActiveTroops, TotalAddTroops, [false, false, false, false, false, false]).
% array paling terakhir berisi kartu risk yang dimiliki oleh pengguna
% indeks 0: ceasefire, 1: super soldier, 2: auxiliary, 3: rebelion, 4: disease, 5: supply chain
risk :-
    random(0, 6, N),
    currentPlayer(IDPlayer),
    player(IDPlayer, NamePlayer, TotalTerritories, TotalActiveTroops, TotalAddTroops, RiskCard),
    card(N, Card),
    riskCard(Card, IDPlayer),
    endTurn.


riskCard(cease, Player) :- ceasefire(Player).
riskCard(ss, Player) :- superSoldier(Player).
riskCard(aux, Player) :- auxiliary(Player).
riskCard(rebel, Player) :- rebelion(Player).
riskCard(dis, Player) :- disease(Player).
riskCard(sup, Player) :- supplychain(Player).


ceasefire(ID) :-
    retract(player(ID, Name, TotalTerritories, TotalActiveTroops, TotalAddTroops, RiskCard)),
    assertz(player(ID, Name, TotalTerritories, TotalActiveTroops, TotalAddTroops, 1)),
    format('Player ~w mendapatkan risk card CEASEFIRE ORDER.~nHingga giliran berikutnya, wilayah pemain tidak dapat diserang oleh lawan.~n', [Name]).
     /* Player menjadi kebal untuk satu putaran */

/* Semua hasil lemparan dadu player untuk turn selanjutnya selalu 6*/
superSoldier(ID) :-
    retract(player(ID, Name, TotalTerritories, TotalActiveTroops, TotalAddTroops, RiskCard)),
    assertz(player(ID, Name, TotalTerritories, TotalActiveTroops, TotalAddTroops, 2)),
    format('Player ~w mendapatkan risk card SUPER SOLDIER SERUM.~nHingga giliran berikutnya, semua hasil lemparan dadu saat penyerangan dan pertahanan akan bernilai 6.~n', [Name]).

/* Jumlah tentara yang ditambahkan menjadi 2x kali lipatnya */
auxiliary(ID) :-
    retract(player(ID, Name, TotalTerritories, TotalActiveTroops, TotalAddTroops, RiskCard)),
    assertz(player(ID, Name, TotalTerritories, TotalActiveTroops, TotalAddTroops, 3)),
    format('Player ~w mendapatkan risk card AUXILIARY TROOPS.~nPada giliran berikutnya, tentara tambahan yang didapatkan pemain akan bernilai 2 kali lipat.~n', [Name]).

/* Salah satu wilayah yang dikuasai akan menjadi milik lawan (acak) */
rebelion(ID) :-
    retract(player(ID, Name, TotalTerritories, TotalActiveTroops, TotalAddTroops, RiskCard)),
    assertz(player(ID, Name, TotalTerritories, TotalActiveTroops, TotalAddTroops, 4)),
    format('Player ~w mendapatkan risk card REBELION.~nSalah satu wilayah acak pemain akan berpindah kekuasaan menjadi milik lawan.~n', [Name]),
    getAllOwnedTerritory(ID, Result),
    length(Result, Len),
    random(0, Len, Index),
    nth0(Index, Result, Val),
    repeat,
    random(1, 4, RandomID),
    RandomID \= ID,
    !,
    (player(RandomID, RandomName, A, B, C, D),
    retract(pemilik(Val, Name)),
    assertz(pemilik(Val, RandomName)),
    format('Wilayah ~w sekarang dikuasai oleh Player ~w ~n', [Val, RandomName])).


/* Semua hasil lemparan dadu player untuk turn selanjutnya akan selalu bernilai 1 */
disease(ID) :-
    retract(player(ID, Name, TotalTerritories, TotalActiveTroops, TotalAddTroops, RiskCard)),
    assertz(player(ID, Name, TotalTerritories, TotalActiveTroops, TotalAddTroops, 5)),
    format('Player ~w mendapatkan risk card DISEASE.~nHingga giliran berikutnya, semua hasil lemparan dadu akan bernilai 1.~n', [Name]).

/* Jumlah tentara tambahan akan 0 di turn selanjutnya */
supplychain(ID) :-
    retract(player(ID, Name, TotalTerritories, TotalActiveTroops, TotalAddTroops, RiskCard)),
    assertz(player(ID, Name, TotalTerritories, TotalActiveTroops, TotalAddTroops, 6)),
    format('Player ~w mendapatkan risk card SUPPLY CHAIN.~nPada giliran berikutnya, pemain tidak akan mendapat tentara tambahan.~n', [Name]).
