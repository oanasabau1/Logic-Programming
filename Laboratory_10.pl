% Laborator 10

% transformare din neighbor list-clause (A2B2) in edge-clause (A1B2)

:-dynamic neighbor/2.

neighbor(a, [b, d]).
neighbor(b, [a, c, d]).
neighbor(c, [b, d]).

neighb_to_edge:- retract(neighbor(Node,List)),!,
 				 process(Node,List),
 				 neighb_to_edge.
neighb_to_edge. 
process(Node, [H|T]):- assertz(gen_edge(Node, H)), process(Node, T).
process(Node, []):- assertz(gen_node(Node)).

% ex 1

% dupa cum am observat ca trebuie sa arate rezultatul final, am adaugat aditional faptele node_ex1(c) si node_ex1(d)
% deoarece nu au vecini in lista rezultata => graf orientat (din punctul meu de vedere)

edge_ex1(a,b).
edge_ex1(a,c).
edge_ex1(b,d).
node_ex1(c).
node_ex1(d).

% transformare din edge-clause (A1B2) in neighbor list-clause (A2B2)

:- dynamic gen_neighb/2.

% procesam nodurile 
edge_to_neighb :-
    node_ex1(U),
    assert(gen_neighb(U, [])),
    fail.
% procesam edge-urile cu failure-driven loop
edge_to_neighb :-
    edge_ex1(U, V),
    edge_to_neighb(U, V),
    fail.
edge_to_neighb.

edge_to_neighb(U,_):-
    not(gen_neighb(U, _)),
    assert(gen_neighb(U, [])).
edge_to_neighb(U,V):-
    retract(gen_neighb(U, List)), !,
    assert(gen_neighb(U, [V|List])). 

% ex 2

edge_ex2(a,b).
edge_ex2(b,c).
edge_ex2(a,c).
edge_ex2(c,d).
edge_ex2(b,d).
edge_ex2(d,e).
edge_ex2(e,a).

% modificam predicatul dat path si adaugam un parametru aditional care reprezinta numarul de noduri

hamilton_path(0, X, Y, Path, [Y|Path]):- edge_ex2(X,Y).
hamilton_path(N, X, Y, PPath, FPath):- edge_ex2(X,Z),
    							  	   not(member(Z, PPath)),
    							  	   N1 is N-1,
    							  	   hamilton_path(N1, Z, Y, [Z|PPath], FPath).

hamilton(N, X, Path):- N1 is N-1, 
    				   hamilton_path(N1, X, X, [X], Path). % wrapper
 
% ex 3

edge_ex3(a,b).
edge_ex3(b,c).
edge_ex3(a,c).
edge_ex3(c,d).
edge_ex3(b,d).
edge_ex3(d,e).
edge_ex3(e,a).

% avem nevoie de un parametru aditional, anume Ppath, care se va initializa cu []

% lista de restictii este vida
restricted_path_efficient(X, X, [], _, [X]).
restricted_path_efficient(X, Y, [], PPath, [X|FPath]) :- edge_ex3(X, Z),
   												   		 not(member(Z, PPath)),
   												   		 restricted_path_efficient(Z, Y, [], [Z|PPath], FPath).
restricted_path_efficient(X, Y, [X|T], PPath, [X|FPath]):- edge_ex3(X, Z),
   														   not(member(Z, PPath)),
   														   restricted_path_efficient(Z, Y, T, [Z|PPath], FPath).
restricted_path_efficient(X, Y, LR, PPath, [X|FPath]):- edge_ex3(X, Z),
   													    not(member(Z, PPath)),
   														restricted_path_efficient(Z, Y, LR, [Z|PPath], FPath).

restricted_path_efficient(X, Y, LR, P):- restricted_path_efficient(X, Y, LR, [], P). % wrapper

% ex 4

% doar adaugam costul si adunam cu acesta

edge_ex4(a,c,7).
edge_ex4(a,b,10).
edge_ex4(c,d,3).
edge_ex4(b,e,1).
edge_ex4(d,e,2).

:- dynamic sol_part/2.

optimal_weighted_path(X, Y, Path):- asserta(sol_part([], 10000)),
 						   			path(X, Y, [X], Path, 1).
optimal_weighted_path(_, _, Path):- retract(sol_part(Path,_)).

path(Y, Y, Path, Path, LPath):- retract(sol_part(_,_)), !,
 							    asserta(sol_part(Path,LPath)),
 							    fail.
path(X, Y, PPath, FPath, LPath):- edge_ex4(X, Z, Cost),
 							  	  not(member(Z, PPath)),
 							  	  LPath1 is LPath + Cost,
 							  	  sol_part(_, Lopt),
 						      	  LPath1 < Lopt,
 							  	  path(Z, Y, [Z|PPath], FPath, LPath1).


% ex 5

edge_ex5(a,b).
edge_ex5(a,c).
edge_ex5(c,e).
edge_ex5(e,a).
edge_ex5(b,d).
edge_ex5(d,a).

cycle(X, Y, Path, [Y|Path]):- edge_ex5(X, Y).
cycle(X, Y, PPath, FPath):- edge_ex5(X, Z),
    						not(member(Z, PPath)),
    						cycle(Z, Y, [Z|PPath], FPath).

cycle(X, Path):- cycle(X, X, [X], Path). % wrapper

 
% ex 6

neighb_ex6(a, [b,c]).
neighb_ex6(b, [d]).
neighb_ex6(c, [e]).
neighb_ex6(d, [a]).
neighb_ex6(e, [a]).

cycle_neighb(X, Y, Path, [Y|Path]):- neighb_ex6(X, L),
    								 member(Y, L). % verifica daca Y se afla in lista de vecini a lui X
cycle_neighb(X, Y, PPath, FPath):- neighb_ex6(X, L), 	
    							   process_neighb(L, Y, PPath, FPath).

process_neighb(L, Y, PPath, FPath):- member(Z, L), % ia pe rand vecini din lista
    								 not(member(Z, PPath)), 
									 cycle_neighb(Z, Y, [Z|PPath], FPath).

cycle_neighb(X, Path):- cycle_neighb(X, X, [X], Path). % wrapper
 
% ex 7

edge_ex7(a,b).
edge_ex7(b,e).
edge_ex7(c,a).
edge_ex7(d,c).
edge_ex7(e,d).

euler(0, _, PPath, FPath):- reverse(PPath, FPath). % cand am parcurs toate muchiile, inverseaza drumul
euler(N, X, PPath, FPath):- (edge_ex7(X, Z); edge_ex7(Z, X)), % verifica in ambele sensuri 
    				    	N1 is N-1,
    						not(member([X, Z], PPath)), % verifica pentru fiecare pereche sa nu faca parte din path
    						not(member([Z, X], PPath)),
    						euler(N1, Z, [[Z, X]|PPath], FPath).
euler(N, X, R):- euler(N, X, [], R). % wrapper
