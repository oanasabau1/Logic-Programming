% Laborator 9

% axioms for trees
complete_tree(t(6, t(4,t(2,nil,nil),t(5,nil,nil)), t(9,t(7,nil,nil),nil))).
incomplete_tree(t(6, t(4,t(2,_,_),t(5,_,_)), t(9,t(7,_,_),_))).

% ex 1

% convert into a difference list from a complete list

convertCL2DL([H|T], [H|LS], LE):- convertCL2DL(T, LS, LE). 
convertCL2DL([], LS, LS).

% convert into a complete list from a difference list

convertDL2CL(LS, LS, []):- var(LS), !.
convertDL2CL([H|T], LE, [H|R]):- convertDL2CL(T, LE, R).

% ex 2

% convert into a difference list from a incomplete list

convertIL2DL(L, LS, LS):- var(L), !.
convertIL2DL([H|T], [H|LS], LE):- convertIL2DL(T, LS, LE).
   
% convert into a incomplete list from a difference list

convertDL2IL(LS, LS, _):- var(LS), !.
convertDL2IL([H|T], LE, [H|R]):- convertDL2IL(T, LE, R).

% ex 3

flat_dl([], L, L).
flat_dl([H|T], [H|RS], RE):- atomic(H), !, flat_dl(T, RS, RE).
flat_dl([H|T], RS, RE):- flat_dl(H, RS, RE1),
    					 flat_dl(T, RE1, RE).

% ex 4

% we use side effects here and the solving method is based on the laboratory guide

append([], L, L).
append([H|T], L, [H|R]):- append(T, L, R).

:-dynamic p/1.
all_decompositions(L, _):- append(L1, L2, L),
    					   asserta(p([L1, L2])),
                           fail.
all_decompositions(_, R):- collect(R).

collect([L1|R]):- retract(p(L1)), !, 
    			  collect(R).
collect([]).


% ex 5

% preorder traversal for difference lists

preorder_dl(nil, List, List).
preorder_dl(t(K, L, R), [K|ListS], ListE):-
    preorder_dl(L, LSL, LEL),
    preorder_dl(R, LSR, LER),
    ListS=LSL,
    LSR=LEL,
    ListE=LER.

% version without explicit unification - for exercise

preorder_dl1(nil, List, List).
preorder_dl1(t(K, L, R), [K|ListS], ListE):-
    preorder_dl1(L, ListS, LSL),
    preorder_dl1(R, LSL, ListE).

% inorder traversal for difference lists - example from the laboratory

inorder_dl(nil, List, List).
inorder_dl(t(K, L, R), ListS, ListE):- 
    inorder_dl(L, LSL, LEL),
    inorder_dl(R, LSR, LER),
    ListS=LSL,
    LEL=[K|LSR],
    ListE=LER.

% version without explicit unification - for exercise

inorder_dl1(nil, List, List).
inorder_dl1(t(K, L, R), ListS, ListE):- 
    inorder_dl1(L, ListS, LEL),
    inorder_dl1(R, [K|LEL], ListE).
    
% postorder traversal for difference lists

postorder_dl(nil, List, List).
postorder_dl(t(K, L, R), ListS, ListE):-
    postorder_dl(L, LSL, LEL),
    postorder_dl(R, LSR, [K|LER]),
    ListS=LSL,
    LSR=LEL,
    ListE=LER.

% version without explicit unification - for exercise

postorder_dl1(nil, List, List).
postorder_dl1(t(K, L, R), ListS, ListE):-
    postorder_dl1(L, ListS, LEL),
    postorder_dl1(R, LEL, [K|ListE]).

% ex 6

even_dl(nil, LS, LS).
even_dl(t(K, L, R), LS, LE):- 0 is K mod 2, !, 
    						  even_dl(L, LS, [K|LSL]),
    						  even_dl(R, LSL, LE).
even_dl(t(_, L, R), LS, LE):- even_dl(L, LS, LSL),
    					      even_dl(R, LSL, LE).

% ex 7

between_dl(T, LS, LS, _, _):- var(T), !. 
between_dl(nil, LS, LS, _, _).
between_dl(t(K, L, R), LS, LE, K1, K2):- K>K1, K<K2, !,
    									 between_dl(L, LS, [K|LSL], K1, K2),
    									 between_dl(R, LSL, LE, K1, K2).
between_dl(t(_, L, R), LS, LE, K1, K2):- between_dl(L, LS, LSL, K1, K2),
    									 between_dl(R, LSL, LE, K1, K2).

% ex 8

collect_depth_k(T, _, LS, LS) :- var(T), !.
collect_depth_k(t(K, _, _), 1, [K|LS], LS) :- !.
collect_depth_k(t(_, L, R), D, LS, LE):- D > 1, !,
    									 D1 is D-1,
    									 collect_depth_k(L, D1, LS, LSL),
   										 collect_depth_k(R, D1, LSL, LE).

