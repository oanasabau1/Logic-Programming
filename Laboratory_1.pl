% Predicatul woman/1
woman(dorina).
woman(irina).
woman(maria).
woman(carmen).
woman(ana).
woman(sara).
woman(ema).

% Predicatul man/1
man(sergiu).
man(marius).
man(mihai).
man(george).
man(alex).
man(andrei).

% Predicatul parent/2
parent(dorina, maria).
parent(marius, maria).
parent(mihai, george).
parent(irina, george).
parent(mihai, carmen).
parent(irina, carmen).
parent(maria, ana). % maria este parintele anei
parent(george, ana).
parent(maria, andrei).
parent(george, andrei).
parent(carmen, sara).
parent(alex, sara).
parent(carmen, ema).
parent(alex, ema).

% Predicatul mother/2
mother(X, Y) :- woman(X), parent(X, Y).
% X este mama lui Y daca X este femeie si X este parintele lui Y

% Predicatul father/2
father(X, Y) :- man(X), parent(X, Y).
% X este tatal lui Y daca X este barbat si X este parintele lui Y

% Predicatul sibling/2
% X și Y sunt frați/surori dacă au același parinte și X diferit de Y
sibling(X,Y) :- parent(Z,X), parent(Z,Y), X\=Y.

% Predicatul sister/2
% X este sora lui Y dacă X este femeie și X și Y sunt frați/surori
sister(X,Y) :- sibling(X,Y), woman(X).

% Predicatul aunt/2
% X este mătușa lui Y daca este sora lui Z și Z este părintele lui Y
aunt(X,Y) :- sister(X,Z), parent(Z,Y).

% Predicatul brother/2
% X este fratele lui Y dacă X este barbat și X și Y sunt frați/surori
brother(X,Y) :- sibling(X,Y), man(X).

% Predicatul brother/2
% X este unchiul lui Y daca este fratele lui Z și Z este părintele lui Y 
uncle(X,Y) :- brother(X,Z), parent(Z,Y).

% Predicatul grandmother/2
% X este bunica lui Y daca este femeie si daca X este parintele lui Z si Z este parintele lui Y
grandmother(X, Y) :- woman(X), parent(X, Z), parent(Z, Y).

% Predicatul grandfather/2
% X este bunicul lui Y daca este barbat si daca X este parintele lui Z si Z este parintele lui Y
grandfather(X, Y) :- man(X), parent(X, Z), parent(Z, Y).

% Predicatul ancestor/2 
% X este strămoșul lui Y dacă X este legat de Y printr-o serie de relații de tip părinte. 
ancestor(X, Y) :- parent(X, Y).
ancestor(X, Y) :- parent(X, Z), ancestor(Z, Y).