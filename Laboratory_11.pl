% Laborator 11

% axioms

edge(1,2).
edge(1,5).
edge(2,3).
edge(2,5).
edge(3,4).
edge(4,5).
edge(4,6).
is_edge(X,Y):- edge(X,Y);edge(Y,X).

% bfs

:- dynamic nod_vizitat/1.
:- dynamic coada/1. 

bfs(X, _):- assertz(nod_vizitat(X)), 
 			assertz(coada(X)), 
 			bf_search.
bfs(_,R):- !, collect_reverse([],R).

bf_search:- retract(coada(X)), 
 			expand(X), !, 
 			bf_search. 

expand(X):- is_edge(X,Y), 
 			not(nod_vizitat(Y)), 
 			asserta(nod_vizitat(Y)), 
 			assertz(coada(Y)),
 			fail. 
expand(_). 

% dfs

:- dynamic nod_vizitat/1.

dfs(X,_) :- df_search(X). 
dfs(_,L) :- !, collect_reverse([], L). 

df_search(X):- asserta(nod_vizitat(X)),
 			   is_edge(X,Y),
 			   not(nod_vizitat(Y)),
 			   df_search(Y).

collect_reverse(L, P):- retract(nod_vizitat(X)), !,
 						collect_reverse([X|L], P).
collect_reverse(L,L).

% dls

depth_max(2).

edge_ex1(a,b).
edge_ex1(a,c).
edge_ex1(b,d).
edge_ex1(d,e).
edge_ex1(c,f).
edge_ex1(e,g).
edge_ex1(f,h).

is_edge_ex1(X, Y):- edge_ex1(X, Y);
    				edge_ex1(Y, X).

:- dynamic nod_vizitat/1.

dls(X, N, _):- dl_search(X, N).
dls(_, _, L):- !, collect_reverse([], L).

dl_search(X, N):- asserta(nod_vizitat(X)),
    			  is_edge_ex1(X, Y),
    			  not(nod_vizitat(Y)),
    			  N1 is N-1,
    			  N1>=0,
    			  dl_search(Y, N1).

collect_reverse1(L, P):- retract(nod_vizitat(X)), !,
    				    collect_reverse([X|L], P).
collect_reverse1(L, L).


dls(X, L):- depth_max(Z), dls(X, Z, L). % wrapper