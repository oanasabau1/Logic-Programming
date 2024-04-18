% Laborator 8

% axioms

incomplete_tree(t(7, t(5, t(3, _, _), t(6, _, _)), t(11, _, _))).
complete_tree(t(7, t(5, t(3, nil, nil), t(6, nil, nil)), t(11, nil, nil))).

append([], L, L).
append([H|T], L, [H|R]):- append(T, L, R).

% ex 1

% converteste lista completa in lista incompleta

convertIL2CL(L, []):- var(L), !.
convertIL2CL([H|T], [H|R]):- convertIL2CL(T, R).

% converteste lista incompleta in lista completa

convertCL2IL([], _).
convertCL2IL([H|T], [H|R]):- convertCL2IL(T, R).

% ex 2

append_il(L1, L2, L2):- var(L1), !.
append_il([H|T], L, [H|R]):- append_il(T, L, R).

% ex 3

% forward recursion

reverse_il_fwd(L, Acc, Acc):- var(L), !.
reverse_il_fwd([H|T], Acc, R):- append([H], Acc, Acc1), !,
    							reverse_il_fwd(T, Acc1, R).
reverse_il_fwd(L, R):- reverse_il_fwd(L, _, R). % wrapper

% backward recursion

reverse_il_bwd(L, _):- var(L), !.
reverse_il_bwd([H|T], R):- reverse_il_bwd(T, R1),
    					   append(R1, [H|_], R), !.

% ex 4

flat_il(L, _):- var(L), !.
flat_il([H|T], [H|R]):- atomic(H), !, flat_il(T, R). 
flat_il([H|T], R):- flat_il(H, L1),
    				flat_il(T, L2),
    				append(L1, L2, R), !.

% ex 5

% converteste arbore complet in arbore incomplet

convertCT2IT(nil, _).
convertCT2IT(t(Key, L, R), t(Key, L1, R1)):- convertCT2IT(L, L1),
    										 convertCT2IT(R, R1).

% converteste arbore incomplet in arbore complet

convertIT2CT(T, nil):- var(T), !. % fail e doar pentru search-uri
convertIT2CT(t(Key, L, R), t(Key, L1, R1)) :- convertIT2CT(L, L1),
             								  convertIT2CT(R, R1).
% ex 6

preorder_it(T, _):- var(T), !.
preorder_it(t(K, L, R), List):- preorder_it(L, L1),
    						    preorder_it(R, R1),
    					        append([K|L1], R1, List), !.

% ex 7

max(A, B, A):- A>B, !.
max(_, B, B).

height_it(T, 0):- var(T), !.
height_it(t(_, L, R), H):- height_it(L, H1),
    					   height_it(R, H2),
    					   max(H1, H2, H3),
    					   H is H3+1.

% ex 8

diam_it(T, 0):-var(T), !.
diam_it(t(_, L, R), D):- diam_it(L, D1),
    					 diam_it(R, D2),
    					 height_it(t(_, L, R), H1),
    					 H is H1+1,
                         max(D1, D2, D3),
    					 max(D3, H, D).

% ex 9

% in Acc avem o copie a listei initiale, in wrapper vom pune lista

subl_il(L, _, R):- nonvar(L), var(R), !, fail.
subl_il(L, _, _):- var(L), !.
subl_il([H|T1], Acc, [H|T2]):- subl_il(T1, Acc, T2), !.
subl_il(_, Acc, [_|T]):- subl_il(Acc, Acc, T).

subl_il(L, R):- subl_il(L, L, R). % wrapper