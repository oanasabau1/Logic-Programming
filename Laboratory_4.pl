% Laborator 4

member1(X, [X|_]).
member1(X, [_|T]):-
    member1(X, T).

union([], L, L).
union([H|T], L, R):-
    member1(H, L), 
    !, % avoid backtracking
    union(T, L, R).
union([H|T], L, [H|R]):-
    union(T, L, R).

% ex 1

intersect([], _, []).
intersect([H|T], L, [H|R]):-
    member1(H, L),
    !, 
    intersect(T, L, R).
intersect([_|T], L, R):- 
    intersect(T, L, R).    

% ex 2

diff([], _, []).
diff([H|T], L, R):-
    member1(H, L),
     !, 
    diff(T, L, R).
diff([H|T], L, [H|R]):-
    diff(T, L, R).

% ex 3

% sterge toate aparitiile
delete_all(X, [H|T], R):- X=H, !, delete_all(X, T, R).
delete_all(X, [H|T], [H|R]):- delete_all(X, T, R).
delete_all(_, [], []).

% sterge doar prima aparitie
delete1(X, [X|T], T) :-!.
delete1(X, [H|T], [H|R]) :- delete1(X,T,R).
delete1(_, [], []).

% backward recursion
min1([H], H).
min1([H|T], M):-
    min1(T, M),
    H>=M, !. % folosesc operatorul cut ! ca sa nu mai pun conditia explicita pe cealalta ramura
min1(1[_|T], M):-
    min1(T, M).

% forward recursion
min2([H|T], Acc, M):-
    H>Acc,
    !,
    min2(T, Acc, M).
min2([_|T], Acc, M):-min2(T, Acc, M).
min2([], M, M).

min2([H|T], M):- min2([H|T], H, M). % wrapper

del_min(L, R):-min2(L, M), delete_all(M, L, R). % am testat si cu min1

% backward recursion
max1([H], H).
max1([H|T], M):-
    max1(T, M),
    H<M, !.
max1([_|T], M):-
    max1(T, M).

% forward recursion
max2([H|T], Acc, M):-
    H=<Acc, 
    !, 
    max2(T, Acc, M).
max2([_|T], Acc, M):- max2(T, Acc, M).
max2([], M, M).

max2([H|T], M):- max2([H|T], H, M). % wrapper

del_max(L, R):-max2(L, M), delete_all(M, L, R). % am testat si cu max1

% ex 4

append1([], L, L).
append1([H|T], L, [H|R]):-
    append1(T, L, R).

reverse1([], []).
reverse1([H|T], R):-
    reverse1(T, Rcoada),
    append1(Rcoada, [H], R).

reverse_k([H|T], K, R):-
    K\=0,
    !,
    K1 is K-1,
    reverse_k(T, K1, Rcoada),
    R=[H|Rcoada].
reverse_k(L, 0, R):-reverse1(L, R).

% ex 5


rle_encode([], _, []).              
rle_encode([H], K, [[H,K]]).
rle_encode([H1, H2|T], K, R):-
    H1=H2, 
    !,
    K1 is K+1,
    rle_encode([H2|T], K1, R).
rle_encode([H1, H2|T], K, [[H1, K]|R]):-
    rle_encode([H2|T], 1, R).
           
rle_encode(L, R):-rle_encode(L, 1, R). % wrapper
           
% ex 6

% implementare rotate_left: facem predicatul split care imparte lista in 2 liste la al K-lea element
% iar prima lista obtinuta o concatenam la a doua prin append ( append1(L2, L1, R) )

split(L, 0, [], L).
split([H|T], K, [H|L1], L2):-
    K1 is K-1,
    split(T, K1, L1, L2).

len([], 0).
len([_|T], R):-
    len(T, R1),
    R is R1+1.

rotate_left(L, K, R):-split(L, K, L1, L2),
    				  append1(L2, L1, R).

% implementare rotate_right: aceeasi idee ca la rotate_left, doar ca impartim lista la al lungime(lista)-K-lea element
% pentru a avea rotatie la dreapta

rotate_right(L, K, R):- len(L, Len),
    					K1 is Len-K,
    					split(L, K1, L1 ,L2),
    					append1(L2, L1, R).

% ex 7

% predicat care imi returneaza elementul de pe pozitia k

get_val_from_list([H|_], 1, H).
get_val_from_list([_|T], K, Val):-
    K1 is K-1,
    get_val_from_list(T, K1, Val).

rnd_select(_, 0, []).
rnd_select(L, K, R):-
    K1 is K-1,
    len(L, Len),
    random_between(1, Len, Rand), % extrag pozitia
    get_val_from_list(L, Rand, Val), % extrag elementul
    % delete1(Val, L, L1), % (optional) sterg sa nu se obtina acelasi element de 2 ori (sansele scad daca lista are foarte multe elemente)
    rnd_select(L, K1, R1),
    R=[Val|R1].
    
% ex 8

rle_decode([], []).
rle_decode([[H, K]|T], [H|R]):-
    K>1,
    K1 is K-1,
    rle_decode([[H, K1]|T], R).
rle_decode([[H, 1]|T], [H|R]):-
    rle_decode(T, R).


