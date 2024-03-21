% Laborator 3

% ex 1

append3([H|T], L2, L3, [H|R]):-
    append3(T, L2, L3, R).
append3([], [H|T], L3, [H|R]):-
    append3([], T, L3, R).
append3([], [], L3, L3).


% ex 2

add_first(X, L, [X|L]).

% ex 3

sum_bwd([], 0).
sum_bwd([H|T], S):- sum_bwd(T, Partial_Sum),
    				S is Partial_Sum + H.

sum_fwd([], Acc, Acc).
sum_fwd([H|T], Acc, S):-
    Acc1 is Acc + H, 
    sum_fwd(T, Acc1, S).

sum_fwd(L, S):-sum_fwd(L, 0, S). % wrapper

% ex 4

separate_parity([], [], []).
separate_parity([H|T], [H|E], O):-
    0 is H mod 2,
    separate_parity(T, E, O).

separate_parity([H|T], E, [H|O]):-
    1 is H mod 2, 
    separate_parity(T, E, O).

% ex 5

% avem nevoie de predicatul member 

member1(X, [X|_]).
member1(X, [_|T]):-
    member1(X, T).

% pastreaza prima aparitie - forward recursion 

remove_duplicates_fwd([], _, []).
remove_duplicates_fwd([H|T], Acc, R):-
    member1(H, Acc),
    Acc1=[H|Acc],
    remove_duplicates_fwd(T, Acc1, R).
remove_duplicates_fwd([H|T], Acc, [H|R]):-
    not(member1(H, Acc)),
    Acc1=[H|Acc],
    remove_duplicates_fwd(T, Acc1, R).

remove_duplicates_fwd(L, R):-remove_duplicates_fwd(L, [], R). % wrapper

% pastreaza ultima aparitie - backward recursion

remove_duplicates_bwd([], []).
remove_duplicates_bwd([H|T], R):-
    member1(H, T),
    remove_duplicates_bwd(T, R).
remove_duplicates_bwd([H|T], [H|R]):-
    not(member1(H, T)),
    remove_duplicates_bwd(T, R).

% ex 6
  
replace_all(_, _, [], []).
replace_all(X, Y, [X|T], [Y|R]):-
    replace_all(X, Y, T, R).
replace_all(X, Y, [H|T], [H|R]):- not(X=H),
    replace_all(X, Y, T, R).

% ex 7

drop_k([], _, _, []).
drop_k([_|T], K, Counter, R):- 
    0 is Counter mod K,
    !, % added the cut to avoid backtracking
    Counter1 is Counter+1,
    drop_k(T, K, Counter1, R).
drop_k([H|T], K, Counter, [H|R]):- 
    !, % added the cut to avoid backtracking
    Counter1 is Counter+1,
    drop_k(T, K, Counter1, R).

drop_k(L, K, R):- drop_k(L, K, 1, R). % wrapper

% ex 8

remove_consecutive_duplicates([], []).
remove_consecutive_duplicates([H|[]], [H|[]]). 
remove_consecutive_duplicates([H1,H2|T], [H1|R]):-
	not(H1 = H2),
    remove_consecutive_duplicates([H2|T], R).
remove_consecutive_duplicates([H1,H2|T], R):-
	H1 = H2,
    remove_consecutive_duplicates([H2|T], R).
           
% ex 9
           
pack_consecutive_duplicates([], []).
pack_consecutive_duplicates([H|[]], [[H]|[]]). 
pack_consecutive_duplicates([H1, H2|T], [[H1|[]], R1|R]) :-
    not(H1 = H2),
    pack_consecutive_duplicates([H2|T], [R1|R]).
pack_consecutive_duplicates([H1, H2|T], [[H1|R1]|R]) :-
    H1 = H2,
    pack_consecutive_duplicates([H2|T], [R1|R]).