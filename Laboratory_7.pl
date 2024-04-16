% Laborator 7

% pentru a implementa operatiile pe arbori ternari, doar modificam pe arborii binari prin adaugarea subarborilor din mijloc

% axioms
ternary_tree(
t(6,
t(4,
t(2, nil, nil, nil),
nil,
t(7, nil, nil, nil)),
t(5, nil, nil, nil),
t(9,
t(3, nil, nil, nil),
nil,
nil)
)
).

tree1(t(6, t(4,t(2,nil,nil),t(5,nil,nil)), t(9,t(7,nil,nil),nil))).

% ex 1

ternary_inorder(t(K, L, M, R), List):-
    ternary_inorder(L, LL),
    ternary_inorder(M, LM),
    ternary_inorder(R, LR),
    append(LL, [K|LM], List1),
    append(List1, LR, List).
ternary_inorder(nil, []).

ternary_preorder(t(K, L, M, R), List):-
    ternary_preorder(L, LL),
    ternary_preorder(M, LM),
    ternary_preorder(R, LR),
    append([K|LL], LM, List1),
    append(List1, LR, List).
ternary_preorder(nil, []).

ternary_postorder(t(K, L, M, R), List):-
    ternary_postorder(L, LL),
    ternary_postorder(M, LM),
    ternary_postorder(R, LR),
    append(LL, LM, R1),
    append(R1, LR, R2),
    append(R2, [K], List).
ternary_postorder(nil, []).

% ex 2

% tiparire in preordine

print_key(K, D):- D>0, !,
    		      D1 is D-1,
    			  tab(8),
    			  print_key(K, D1).
print_key(K, _):- write(K), nl.

pretty_print_ternary(nil, _).
pretty_print_ternary(t(K, L, M, R), D):- D1 is D+1,
    						  print_key(K, D),
    						  pretty_print_ternary(L, D1),
    						  pretty_print_ternary(M, D1),
    						  pretty_print_ternary(R, D1).

pretty_print_ternary(T):- pretty_print_ternary(T, 0). % wrapper

% ex 3

max(A, B, A):- A>B, !.
max(_, B, B).

ternary_height(nil, 0).
ternary_height(t(_, L, M, R), H):-
    ternary_height(L, H1),
    ternary_height(M, H2),
    ternary_height(R, H3),
    max(H1, H2, H_int),
    max(H_int, H3, H4),
    H is H4+1.

% ajungem la crearea predicatelor pe arbori binari

% ex 4

leaf_list(t(Key, nil, nil), [Key]):- !.
leaf_list(nil, []).
leaf_list(t(_, L, R), List):- leaf_list(L, L1),
    						  leaf_list(R, L2),
    						  append(L1, L2, List).

% ex 5

internal_list(nil, []).
internal_list(t(_, nil, nil), []):- !.
internal_list(t(Key, L, R), List):- internal_list(L, L1),
    						        internal_list(R, L2),
    						        append(L1, [Key|L2], List).

% ex 6

same_depth(nil, _, []).
same_depth(t(Key, _, _), 1, [Key]):- !.
same_depth(t( _, L, R), K, List):- K1 is K-1, !,
    							   same_depth(L, K1, L1),
    							   same_depth(R, K1, L2),
    						       append(L1, L2, List).
    					 

% ex 7

height(nil, 0).
height(t(_, L, R), H):-
	height(L, H1),
	height(R, H2),
	max(H1, H2, H3),
    H is H3+1.

diam(nil, 0).
diam(t(_, L, R), D):- diam(L, D1),
    				  diam(R, D2),
    				  height(L, H1),
    				  height(R, H2), 
    				  H12 is H1+H2+1, 
    				  max(D1, D2, D12),
    				  max(D12,H12,D).

% ex 8

symmetric(nil, nil).
symmetric(t(_, L1, R1), t(_, L2, R2)):- symmetric(L1, R2),
    									symmetric(R1, L2).

symmetric(t(_, L, R)):- symmetric(L, R). % wrapper

% ex 9

% inlocuire nod sters cu predecesorul

get_pred(t(Pred, L, nil), Pred, L):- !.
get_pred(t(Key, L, R), Pred, t(Key, L, NR)):- get_pred(R, Pred, NR).

delete_key(Key, t(Key, L, nil), L):- !.
delete_key(Key, t(Key, nil, R), R):- !.
delete_key(Key, t(Key, L, R), t(Pred, NL, R)):- !, get_pred(L, Pred, NL).
delete_key(Key, t(K, L, R), t(K, NL, R)):- Key<K, !, 
    									   delete_key(Key, L, NL).
delete_key(Key, t(K, L, R), t(K, L, NR)):- delete_key(Key, R, NR).

% inlocuire nod sters cu succesorul - se face asemanator cu predicatul de mai sus

get_succ(t(Succ, nil, R), Succ, R):- !.
get_succ(t(Key, L, R), Succ, t(Key, NL, R)):- get_succ(L, Succ, NL).

delete_key_succ(Key, t(Key, L, nil), L):- !.
delete_key_succ(Key, t(Key, nil, R), R):- !.
delete_key_succ(Key, t(Key, L, R), t(Succ, L, NR)):- !, get_succ(R, Succ, NR).
delete_key_succ(Key, t(K, L, R), t(K, NL, R)):- Key<K, !, delete_key_succ(Key, L, NL).
delete_key_succ(Key, t(K, L, R), t(K, L, NR)):- delete_key_succ(Key, R, NR).


