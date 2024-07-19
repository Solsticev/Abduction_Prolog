:- use_module(library(lists)).
:- use_module(library(clpfd)).

:- dynamic(aa/1).
:- dynamic(bb/1).
:- dynamic(cc/1).
:- dynamic(dd/1).
:- dynamic(ee/1).
:- dynamic(ff/1).

:-op(900,fy,not).


% Rules

aa(X) :- bb(X), ee(X).
aa(X) :- cc(X), ff(X).
dd(X, Y) :- aa(Y); not gg(X, Y).

flies(X) :- bird(X), not abnormal(X).
abnormal(X) :- penguin(X).
bird(X) :- penguin(X), monkey(X).
bird(X) :- sparrow(X).
flies1(X) :- not abnormal(X), bird(X).

wet(X) :- rain(X); splash(X).
tew(X) :- rain(X), splash(X).
tew(X) :- cry(X).

a(X) :- b(Y), Y #= X+1.



abducible(A/_) :-
    A \= aa,
    A \= dd,
    A \= abnormal,
    A \= flies,
    A \= flies1,
    A \= bird,
    A \= wet,
    A \= tew.


abduce(O, E) :- 
    abduce(O, [], E).

abduce(true, E, E) :- !.

abduce(not(A), E0, E) :- !,
    abduce_not(A, E0, E).

abduce((A, B), E0, E) :- !,
    abduce(A, E0, E1),
    abduce(B, E1, E).

abduce((A; B), E0, E) :- !, 
    (abduce(A, E0, E);
    abduce(B, E0, E)).

abduce(A, E0, E) :-
    clause(A, B),
    abduce(B, E0, E).

abduce(A, E, E) :-
    member(A, E).

abduce(A, E, [A | E]) :-
    functor(A, Pred, Nargs),
    not member(A, E),
    abducible(Pred/Nargs),
    not abduce_not(A, E, E).

abduce_not(not(A), E0, E) :- !,
    abduce(A, E0, E).

abduce_not((A, B), E0, E) :- !, 
    (abduce_not(A, E0, E);
    abduce_not(B, E0, E)).

abduce_not((A; B), E0, E) :- !,
    abduce_not(A, E0, E1),
    abduce_not(B, E1, E).

abduce_not(A, E0, E) :-
    setof(B, clause(A, B), Ls),
    abduce_not_ls(Ls, E0, E).

abduce_not(A, E, E) :-
    member(not(A), E).

abduce_not(A, E, [not(A) | E]) :-
    functor(A, Pred, Nargs),
    not member(not(A), E),
    abducible(Pred/Nargs),
    not abduce(A, E, E).

abduce_not_ls([], E, E).
abduce_not_ls([B | Bs], E0, E) :-
    abduce_not(B, E0, E1),
    abduce_not_ls(Bs, E1, E).