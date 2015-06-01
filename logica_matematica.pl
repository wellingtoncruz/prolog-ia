/* Lógica Matemática */
/* Wellington Cruz wellington.cruz@gmail.com */

/* Montagem das arestas do Grafo */
/* Baseado no grafo disponível na URL: http://www.lia.ufc.br/~silveira/alg_grafos_trabalho_1/c.png */


aresta(2,1).
/*aresta(3,2).*/ /* Esta aresta está comentada para testar o predicado que calcula os vértices atingiveis */
aresta(4,5).
aresta(6,5).
aresta(8,7).
aresta(4,1).
aresta(2,5).
aresta(6,3).
aresta(7,4).
aresta(5,8).
aresta(8,6).
aresta(2,4).

/* Predicados auxiliares */
concatena([], L, L).
concatena([X|L1], L2, [X|L3]) :- concatena(L1, L2, L3).

num([], 0).
num([_|L1], N) :- num(L1, N2), N is  N2 +1.

/* Predicado "caminho" que mostra todos os caminhos do vértice I até F */
caminho(I, F, C) :- trajeto(I, F, [I], C).
trajeto(I, F, V, C) :- aresta(I, F), concatena(V, [F], C).

trajeto(I, F, V, C) :- aresta(I, X), X\==F, \+member(X, V), concatena(V, [X], T), trajeto(X, F, T, C).

/* Predicado "atingiveis" que mostra todos os vértices que podem ser atingidos a partigir do vértice X */
atingiveis(X, V) :- setof(Y, atinge(X, Y), V).
atinge(X, V) :- atingivel(X, V, [X]).
atingivel(X, Y, V) :- aresta(X, Y), \+member(Y, V).
atingivel(X, Y, V) :- aresta(X, Z), \+member(Z, V), atingivel(Z, Y, [Z|V]).

/* Predicado "interseccao" que calcula os membros comuns de dois grupos representados por duas listas */
interseccao([], _, []).
interseccao([X|L1], L2, [X|L3]) :- member(X, L2), interseccao(L1, L2, L3).
interseccao([_|L1], L2, L3) :- interseccao(L1, L2, L3).

/* Predicado "subconjunto" que determina se o conjunto representado pela lista L1 é um subconjunto do conjunto representado por L2 */
subconjunto(L1, L2) :- interseccao(L1, L2, INT), num(INT, N1), num(L1, N2), N1==N2.


