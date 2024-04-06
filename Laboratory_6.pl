% Laborator 6

% ex 1

simple_list_count([], 0).
simple_list_count([H|T], S):- simple_list_count(T, S1),
    					    S is S1+H.

count_atomic([], 0).
count_atomic([H|T], S):- atomic(H),
    				     count_atomic(T, S1),
    				     S is S1+1.
count_atomic([H|T], S):- count_atomic(H, S1),
    				     count_atomic(T, S2),
    				     S is S1+S2.

% ex 2

simple_list_sum([], 0).
simple_list_sum([H|T], S):- simple_list_sum(T, S1),
    					    S is S1+H.

sum_atomic([], 0).
sum_atomic([H|T], S):- atomic(H),
    				   sum_atomic(T, S1),
    				   S is S1+H.
sum_atomic([H|T], S):- sum_atomic(H, S1),
    				   sum_atomic(T, S2),
    				   S is S1+S2.

% ex 3

member1(H, [H|_]).
member1(X, [H|_]):- member1(X, H).
member1(X, [_|T]):- member1(X, T).

member_deterministic(H, [H|_]):-!.
member_deterministic(X, [H|_]):- member_deterministic(X, H), !.
member_deterministic(X, [_|T]):- member_deterministic(X, T).

% ex 4

replace_simple_lists(_, _, [], []).
replace_simple_lists(X, Y, [X|T], [Y|R]):-!, replace_simple_lists(X, Y, T, R).
replace_simple_lists(X, Y, [H|T], [H|R]):-replace_simple_lists(X, Y, T, R).

replace(_, _, [], []).
replace(X, Y, [X|T], [Y|R]):- !, replace(X, Y, T, R).
replace(X, Y, [H|T], [H|R]):-atomic(H), !,
    						 replace(X, Y, T, R).
replace(X, Y, [H|T], R):- replace(X, Y, H, R1),
    					  replace(X, Y, T, R2),
    					  R=[R1|R2].

% ex 5

% pornind de la predicatul heads, "negam" putin logica de implementare a acestuia 

lasts([], [], _).
lasts([H], [H], _) :- atomic(H), !.
lasts([H|T] ,R, _):- atomic(H),
    				 !,
    				 lasts(T,R,0).
lasts([H|T], R, _):- lasts(H,R1,1),
    			     lasts(T,R2,0),
    			     append(R1,R2,R).
lasts(L,R):- lasts(L, R, 1). % wrapper

% o alta varianta, pornind de la ideea generica descrisa in laborator

lasts1([], []).
lasts1([H], [H]):- atomic(H), !.
lasts1([H|T], R):- atomic(H),
    			   lasts1(T, R).
lasts1([H|T], R):- lasts1(H, R1),
    			   lasts1(T, R2),
    			   append(R1, R2, R).

% ex 6

% folosesc ca metoda de sortare insertion sort

% predicate aditionale

max(A, B, A):- A>B, !.
max(_, B, B).

depth([], 1).
depth([H|T], R):- atomic(H), !, depth(T, R).
depth([H|T], R):- depth(H, R1),
    			  depth(T, R2),
    			  R3 is R1+1,
    			  max(R3, R2, R).

flatten([],[]).
flatten([H|T], [H|R]):- atomic(H), !, flatten(T,R).
flatten([H|T], R):- flatten(H,R1),
    				flatten(T,R2),
    				append(R1,R2,R).

list_compare([], [], 1):-!.	
list_compare(_, [], 1):-!.	
list_compare([], _, 0):-!.	
list_compare([H1|_], [H2|_], 1):- H1>H2, !.		
list_compare([H1|_], [H2|_], 0):- H1<H2, !.		
list_compare([_|T1], [_|T2], R):- list_compare(T1, T2, R).	

compare_deep_lists(L1,L2,R):- flatten(L1, R1), flatten(L2, R2), list_compare(R1, R2, R).		

insert_ord_depth(X, [H|T], [H|R]):- depth([X], D1),
    								depth([H], D2), 
    								D1>D2,
    								!, 
    								insert_ord_depth(X, T, R). 

insert_ord_depth(X, [H|T], [H|R]):- depth([X], D1),
    								depth([H], D2),
    								D1=D2, 
    								compare_deep_lists([X], [H], Flag),
    								Flag=1,
    								!,
    								insert_ord_depth(X, T, R). 
																														
insert_ord_depth(X, T, [X|T]).		


sort_depth([H|T], R):- sort_depth(T, R1), 
    				   insert_ord_depth(H, R1, R).
sort_depth([], []).


% ex 7

len_con_depth([], Len, [Len]).
len_con_depth([H|T], Len, R):- atomic(H), !, 
    						   Len1 is Len + 1,
   							   len_con_depth(T, Len1, R).
len_con_depth([H|T], 0, R):-!, 
    						len_con_depth(H, 0, R1), 
    						len_con_depth(T, 0, R2), 
    						append([R1], R2, R).
len_con_depth([H|T], Len, R):- len_con_depth(H, 0, R1), 
    						   len_con_depth(T, 0, R2), 
   							   append([Len|[R1]], R2, R).

len_con_depth(L, R):- len_con_depth(L, 0, R). % wrapper
    						  