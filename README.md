### Abduction in Prolog 

Run

```bash
swipl abduce.pl
```

#### Examples

```prolog
aa(X) :- bb(X), ee(X).
aa(X) :- cc(X), ff(X).
dd(X, Y) :- aa(Y); not gg(X, Y).
```

```prolog
?- abduce(dd(1, 0), Res).
Res = [ee(0), bb(0)] ;
Res = [ff(0), cc(0)] ;
Res = [not gg(1, 0)] ;
false.
```

```prolog
flies(X) :- bird(X), not abnormal(X).
abnormal(X) :- penguin(X).
bird(X) :- penguin(X), monkey(X).
bird(X) :- sparrow(X).
flies1(X) :- not abnormal(X), bird(X).
```

```prolog
?- abduce(not flies(kobe), Res).
Res = [not penguin(kobe), not sparrow(kobe)] ;
Res = [not monkey(kobe), not sparrow(kobe)] ;
Res = [penguin(kobe)] ;
false.

?- abduce(not not flies(kobe), Res).
Res = [not penguin(kobe), sparrow(kobe)] ;
false.
```

#### ChangeLog

* Support `;` in clauses.

* Support `not not not not ...` in clauses.

#### TODO

* Handle loop 

```prolog
wise(X):-not teacher(X).
teacher(peter):-wise(peter).
```

* Support `+` `-` `*` `/`

```prolog
a(X) :- b(Y), Y #= X+1.
```

In this case, query

```prolog
?- abduce(a(1), Res).
```

will raise error.

#### References

[1] Simply Logical. (n.d.). Cut. Simply Logical. Retrieved from https://book.simply-logical.space/src/text/3_part_iii/8.3.html