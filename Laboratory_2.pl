% ex 1

cmmdc(X, 0, X).
cmmdc(X, Y, Z):- Y\=0,
    Rest is X mod Y,
    cmmdc(Y, Rest, Z).

cmmmc(X, Y, Z):-
    cmmdc(X, Y, R),
    Z is X*Y/R.

% ex 2

triangle(A, B, C):- (A+B>C), (B+C>A), (A+C>B).

% ex 3

solve(A, B, C, X):- 
    Delta is B*B-4*A*C,
    Delta>=0,
    X is ((0-B)+sqrt(Delta))/2*A.

solve(A, B, C, X):- 
    Delta is B*B-4*A*C,
    Delta>0,
    X is ((0-B)-sqrt(Delta))/2*A.

% ex 4

power_fwd(_, 0, Acc, Acc).
power_fwd(X, Y, Acc, Z):-
    Y>0,
    Y1 is  Y-1,
    Acc1 is Acc*X,
    power_fwd(X, Y1, Acc1, Z).

power_fwd(X, Y, Z) :- power_fwd(X, Y, 1, Z).

power_bwd(_, 0, 1).
power_bwd(X, Y, Z):-
    Y>0,
    Y1 is Y-1,
    power_bwd(X, Y1, Z1),
    Z is Z1*X.

% ex 5

fib(0, 0).
fib(1, 1).
fib(N, X):-
    N>1,
    N1 is N-1,
    N2 is N-2,
    fib(N1, X1),
    fib(N2, X2),
    X is X1+X2.

% ex 6

fib1(0, Acc1, _, Acc1).
fib1(1, _, Acc2, Acc2).
fib1(N, Acc1, Acc2, X):-
    N > 1,  % Fix the condition here
    N1 is N - 1,
    Acc11 is Acc2,
    Acc22 is Acc1 + Acc2,
    fib1(N1, Acc11, Acc22, X).
fib1(N, X):- fib1(N, 0, 1, X).

% ex 7

for(Inter,Inter,0).
for(Inter,Out,In):-
 In>0,
 NewIn is In-1,
 Intermediate is Inter+In,
 for(Intermediate,Out,NewIn).

% ex 8

for_bwd(0, 0).
for_bwd(In, Out):-
    In > 0,
    NewIn is In - 1,
    for_bwd(NewIn, Out1),
    Out is Out1 + In.

% ex 9

while(High, High, 0).
while(Low, High, Sum):-
    Low < High,
    Low1 is Low + 1,
    while(Low1, High, Sum1),
    Sum is Sum1 + Low.

% ex 10

dowhile(High, High, 0).
dowhile(Low, High, Low-
    Low < High,
    Compare is Low+1,
    Compare >= High. % aici am o eroare de sintaxa
dowhile(Low, High, Sum):-
    Low < High,
    Low1 is Low + 1,
    dowhile(Low1, High, Sum1),
    Sum is Sum1 + Low.








    

