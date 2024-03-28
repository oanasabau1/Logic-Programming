% Laborator 5

% ex 1

delete1(H, [H|T], T):-!.
delete1(X, [H|T], [H|R]):- delete1(X, T, R).
delete1(_, [], []).

min1([H], H).
min1([H|T], M):-min1(T, M),
     			H>=M, !.
min1([H|T], H):-min1(T, _).   

max1([H], H).
max1([H|T], M):-max1(T, M),
     			H<M, !.
max1([H|T], H):-max1(T, _). 

sel_sort(L, [M|R]):- min1(L, M),
    			     delete1(M, L, L1),
    				 sel_sort(L1, R).
sel_sort([], []).


sel_sort_max(L, [M|R]):- max1(L, M),
    			     delete1(M, L, L1),
    				 sel_sort_max(L1, R).
sel_sort_max([], []).

% ex 2

% backward recursion

insert_ord(X, [H|T], [H|R]):- X>H, !,
    						 insert_ord(X, T, R).
insert_ord(X, T, [X|T]).

ins_sort([H|T], R):- ins_sort(T, R1),
    			     insert_ord(H, R1, R).
ins_sort([], []).

% forward recursion

insert_ord_fwd(X, [H|T], Acc, R):- X>H,
    								   !,
    								   append1(Acc, [H], Acc1),
    								   insert_ord_fwd(X, T, Acc1, R).
insert_ord_fwd(X, T, Acc, R):- append1(Acc, [X|T], R).

ins_sort_fwd([H|T], R):- ins_sort_fwd(T, R1), 
    					 insert_ord_fwd(H, R1, [], R).
ins_sort_fwd([], []).

% ex 3

one_pass([H1, H2|T], [H2|R], F):- H1>H2, !,
    							  F=1,
    							  one_pass([H1|T], R, F).
one_pass([H1|T], [H1|R], F):- one_pass(T, R, F).
one_pass([], [], _).

bubble_sort(L, R):- one_pass(L, R1, F),
    				nonvar(F), !,
    				bubble_sort(R1, R).
bubble_sort(L, L).

bubble_sort_fixed(L, 0, L).
bubble_sort_fixed(L, K, R):-
    K1 is K-1,
    one_pass(L, R1, F), % aici nu apelam bubble sort, ci reluam codul din predicatul lui
    nonvar(F),
    !,
    bubble_sort_fixed(R1, K1, R). 

% ex 4

% pentru acest exercitiu aleg ca metoda de sortare quick sort

append1([], L, L).
append1([H|T], L, [H|R]):-
    append1(T, L, R).

partition(P, [X|T], [X|S], L):- X<P,
    							!,
    							partition(P, T, S, L).
partition(P, [X|T], S, [X|L]):- partition(P, T, S, L).
partition(_, [], [], []).

quick_sort([H|T], R):- partition(H, T, S, L),
    				   quick_sort(S, S_list),
    				   quick_sort(L, L_list),
    				   append1(S_list, [H|L_list], R).
quick_sort([], []).

% implementarea exercitiului-propriu-zis

partition_chars(P, [X|T], [X|S], L):-
    							char_code(X, X_ascii),
    							char_code(P, P_ascii),
    							X_ascii<P_ascii,
    							!,
    							partition_chars(P, T, S, L).
partition_chars(P, [X|T], S, [X|L]):- partition_chars(P, T, S, L).
partition_chars(_, [], [], []).

sort_chars([H|T], R):- partition_chars(H, T, S, L),
    				   sort_chars(S, S_list),
    				   sort_chars(L, L_list),
    				   append1(S_list, [H|L_list], R).
sort_chars([], []).

% ex 5

% pentru acest exercitiu aleg ca metoda de sortare tot quick sort

len([], 0).
len([_|T], L):-
    len(T, L1),
    L is L1+1.

% implementarea exercitiului-propriu-zis

partition_lens(P, [X|T], [X|S], L):-
    							len(X, X_len),
    							len(P, P_len),
    							X_len<P_len,
    							!,
    							partition_lens(P, T, S, L).
partition_lens(P, [X|T], S, [X|L]):- partition_lens(P, T, S, L).
partition_lens(_, [], [], []).

sort_lens([H|T], R):- partition_lens(H, T, S, L),
    				   sort_lens(S, S_list),
    				   sort_lens(L, L_list),
    				   append1(S_list, [H|L_list], R).
sort_lens([], []).

% ex 6

member1(H, [H|_]).
member1(X, [_|T]):- member1(X, T).

perm1(L, [H|R]):- member1(H, L),
    			  delete1(H, L, L1),
    			  perm1(L1, R).
perm1([], []).
