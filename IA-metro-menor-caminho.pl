/* Inteligência Artificial */

/* Grupo */
/* Caio Marcelo */
/* Wellington Cruz  wellington.cruz@gmail.com  */

/* Menor Caminho - METRO DE LISBOA */
/* Mapa pode ser encontrado em: http://www.demat.ist.utl.pt/recursos/images/metro.gif */
/* comando para aumentar o tamanho da exibição das listas no SWI-Prolog: (copie e cole)*/
/* set_prolog_flag(toplevel_print_options, [quoted(true), portray(true), max_depth(100), priority(699)]). */

/* Iniciamos a base de dados básica, com uma lista para cada linha e uma lista de linhas */
linha(amarela, [odivelas, senhor_roubado, ameixoeira, lumiar, quinta_das_conchas, campo_grande, cidade_universitaria, entre_campo, campo_pequeno, saldanha, picoas, marques_do_pombal, rato]).
linha(verde, [telheiras, campo_grande, alvalade, roma, areeiro, alameda, arroios, anjos, intendente, martim_moniz, rossio, baixa_chiado, cais_do_sodre]).
linha(vermelha, [alameda, olaias, bela_vista, chelas, olivais, cabo_ruivo, oriente]).
linha(azul, [amadora_leste, alfornelos, carnilde, colegio_militar, alto_dos_moinhos, laranjeiras, jardim_zoologico, praca_de_espanha, sao_sebastiao, parque, marques_do_pombal, avenida, restauradores, baixa_chiado]).
linhas([amarela, verde, vermelha, azul]).

/* Predicados auxiliares */

/* Predicado auxiliar que concatena duas listas */
concatena([],L,L).
concatena([X|L1], L2, [X|LR]) :- concatena(L1, L2, LR).

/* Predicado auxiliar que calcula o numero de elementos de uma lista */
numelementos([],0).
numelementos([_|T], X) :- numelementos(T, Y), X is Y + 1.

/* Predicado auxiliar que retorna o primeiro elemento em comum entre duas listas */
elementocomum([H|_], L, H) :- member(H, L).
elementocomum([_|T], L, E) :- elementocomum(T, L, E).

/* Predicado auxiliar que retorna o primeiro elemento de uma lista */
proximo([H|_], H).

/* Predicado auxiliar que retorna uma lista sem o primeiro elemento */
drop([_|T], T).

/* Predicado auxiliar que retorna o menor elemento de uma lista */
menor([H|T], L) :- menorelemento(T, H, L).
/* Iniciamos a verificação assumindo que o primeiro elemento da lista é o menor.
   Daí em diante percorremos toda a lista em um numero menor que ele, acumulando o
   melhor valor encontrado na variavel M */
menorelemento([], L, L).
menorelemento([H|T], M, L) :- numelementos(H, T1), numelementos(M, T2), T1 < T2, menorelemento(T, H, L).
menorelemento([_|T], M, L) :- menorelemento(T, M, L).

/* Predicados do EP */

/* Predicado que calcula a quantidade de estacoes de uma linha */
qestacoes(X, N) :- linha(X, Y), numelementos(Y, N).

/* Predicado que verifica se duas estacoes estam na mesma linha */
mesmalinha(A, B, X) :- linha(X, L), member(A, L), member(B, L).

/* Predicado que retorna uma lista com as linhas que cruzam com uma linha X */
cruza(X, L) :- linhas(LL), cruzalinhas(X, LL, L). /* Primeiro obtemos a lista de linhas e passamos para o predicado secundario cruzalinhas */
/* o predicado cruzalinhas verifica se a linha X e o primeiro elemento da linha se cruzam, e caso positivo acumula o elemento em L */
/* quem efetivamente verifica se uma linha X cruza com uma linha Y é o predicado secruzam */
cruzalinhas(X, [H|T], L) :- X\=H, secruzam(X, H), cruzalinhas(X, T, L1), L = [H|L1].
cruzalinhas(X, [_|T], L) :- cruzalinhas(X, T, L).
cruzalinhas(_, [], []).
secruzam(L1, L2) :- linha(L1, X), linha(L2, Y), secruzamlistas(X, Y). /* o predicado recebe somente o nome das listas, portanto pegamos a lista de estacoes das duas linhas e passamos para o predicado secruzamlistas */
secruzamlistas([H|_], L) :- member(H, L). /* duas linhas se cruzam efetivamente se uma estacao da L1 também pertence a L2 */
secruzamlistas([_|T], L) :- secruzamlistas(T, L).

/* o predicado achalinha devolve em L o nome da linha a qual uma estação A pertece */
achalinha(A, L) :- linhas(LL), estacaolinha(A, LL, L). /* pegamos a lista de linhas e passamos para o predicado secundario estacaolinha */
estacaolinha(A, [H|_], H) :- linha(H, LC), member(A, LC). /* pegamos a lista de estacoes de cada linha da lista, e caso A pertença a lista, é essa a linha a qual pertence */
estacaolinha(A, [_|T], L) :- estacaolinha(A, T, L).

/* o predicado caminho é um dos mais imporantes do EP */
/* ele verifica se é possível chegar de uma linha L1 até a linha L1 */
/* também acumula as linhas necessárias para o trajeto em LV */
/* note que se é possivel chegar da linha L1 até a linha L2, então também é possivel ir de qualquer estação de L1 até qualquer estação de L2 */
caminho(L1, L1, [L1]). /* Caso base, é possivel ir de L1 até L1 passando somente por L1 */
/* o predicado secundario caminho possivel mantem uma nova lista V que é a lista de linhas que já foram visitadas */
/* esse controle é importante para evitar que o programa trave em ciclos, ou trave quando não for possivel atingir L1 até L2 */
caminho(L1, L2, LV) :- caminhopossivel(L1, L2, [L1], LV). /* iniciamos o predicado com a primeira linha visita, L1 */
caminhopossivel(L1, L2, V, [L1|[L2]]) :- \+member(L2, V), secruzam(L1, L2). /* Caso base, caso L1 e L2 se cruzem imediatamente, retornamos uma lista com L1 e L2, desde que L2 ainda não tenha sido visitado */
caminhopossivel(L1, L2, V, [L1|LV2]) :- secruzam(L1, LX), L1\==LX, \+member(LX, V), caminhopossivel(LX, L2, [LX|V], LV2). /* Se L1 e L2 não se cruzam, então L1 deve cruzar com LX, desde que LX ainda não tenha sido visitado. Então testamos se é possível chegar de LX até L2, e assim recursivamente */

/* o predicado baldeacoes usa o predicado caminho e retorna as estacoes entre uma estação A e B */
baldeacoes(A, B, L) :- achalinha(A, L1), achalinha(B, L2), caminho(L1, L2, L). /* com o predicado achalinha encontramos a linha de cada estacao e passamos pro predicado caminho */
nbaldeacoes(A, B, N) :- achalinha(A, L1), achalinha(B, L2), caminho(L1, L2, L), numelementos(L, N). /* esse precisado é muito parecido com o anterior, só que retorna o numero de elementos da lista, e não a lista */

/* o predicado estacaobaldeacao retorna a estacao que é o ponto de interseccao de duas linhas */
estacaobaldeacao(L1, L2, E) :- linha(L1, L1L), linha(L2, L2L), elementocomum(L1L, L2L, E).

/* o predicado vem antes verifica se uma estação A, vem antes da B na linha L */
/* esse predicado é muito importante para verificarmos o sentido onde estamos viajando na linha */
vemantes(A, B, L) :- linha(L, LL), emordem(A, B, LL).
emordem(A, B, [A|T]) :- member(B, T).
emordem(A, B, [_|T]) :- member(A, T), member(B, T), emordem(A, B, T).

/* o predicado sublista retorna uma lista com os elementos entre A e B */
/* para isso cortamos os elementos que vem a esquerda de A e os que vem a direitra de B */
sublista(A, B, LL, R) :- cortaesquerda(A, LL, R1), cortadireita(B, R1, R).
cortaesquerda(A, [A|T], [A|T]). /* Retorna a lista com os elementos depois de A */
cortaesquerda(A, [_|T], R) :- cortaesquerda(A, T, R).
cortadireita(B, [B|_], [B]). /* Retorna os elementos antes de B */
cortadireita(B, [H|T], [H|R1]) :- cortadireita(B, T, R1).

/* o predicado sublinha retorna uma sublista da linha L, da estação A até B */
sublinha(A, B, L, R) :- vemantes(A, B, L), linha(L, LL), sublista(A, B, LL, R). /* se a estação A vem antes da B, então retornamos uma sublista com as estações entre A e B */
sublinha(A, B, L, R) :- \+ vemantes(A, B, L), linha(L, LL), reverse(LL, LR), sublista(A, B, LR, R). /* se B vem antes de A, então invertemos a lista para inverter o sentido da linha */

/* o predicado montaestacoes retorna uma lista de estações de A até B, passando pelas linhas da lista LA, fazendo as baldeações nas estações corretas */
/* nesse predicado temos 3 possibilidades: */
/* primeira linha do trajeto: que contem a estação inicial e vai até a primeira baldeacao */
/* ultima linha do trajeto: que contem a estacao final e começa na ultima baldeação e vai até a estação final */
/* estações intermediarias: fazem somente a ligação entre duas linhas e vão de uma baldeação até outra baldeação */
/* obs1: usamos drop no retorna das sublinhas para que as baldeações nao se repitam quando concatenarmos duas linhas */
/* obs2: LA é a linha anterior, necessária para saber qual baldeação deve ser usada para fazer a sublinha. ela é iniciada com null para detectarmos o caso da primeira linha da lista */
montaestacoes(_, B, [H], LA, L) :- estacaobaldeacao(H, LA, A), sublinha(A, B, H, PP), drop(PP, L). /* caso base: ultima estação da lista (que contem a estação de destino) retornamos a sublinha que vai da ultima baldeação até o estação final. */
montaestacoes(A, B, [H|T], LA , L) :- proximo(T, LP), estacaobaldeacao(H, LA, AA), estacaobaldeacao(H, LP, BA), sublinha(AA, BA, H, PA), montaestacoes(A, B, T, H, PP), concatena(PA, PP, DL), drop(DL, L). /* Caso intermediario: retornamos a sublinha de uma baldeação a outra concatenada com a proxima linha, recursivamente */
montaestacoes(A, B, [H|T], null , L) :- proximo(T, LP), estacaobaldeacao(H, LP, BA), sublinha(A, BA, H, PA), montaestacoes(A, B, T, H, PP), concatena(PA, PP, L). /* primeira linha do trajeto: retormamos a sublinha da primeira estação até a primeira baldeação, concatenada com as demais linhas, recursivamente */

/* o predicado estacoes retorna uma lista de estações de A até B em L */
estacoes(A, B, L) :- achalinha(A, L1), linha(L1, LL), member(B, LL), sublinha(A, B, L1, L). /* Caso base: as duas estações são da mesma linha. Retorna uma sublinha dessa linha */
estacoes(A, B, L) :- achalinha(A, L1), achalinha(B, L2), caminho(L1, L2, LL), montaestacoes(A, B, LL, null, L). /* Não são da mesma linha: encontra o caminho da linha L1 até L2 e monta a lista de estações com o predicado montaestacoes */
/* o predicado nestacoes é usa o predicado estacoes e retorna a quantidade N de estacoes entre A e B */
nestacoes(A, B, N) :- estacoes(A, B, L), numelementos(L, N).

/* o predicado melhorcaminhoestacoes encontra com findall todas as possibilidades entre A e B e retorna a lista com o menor numero de estações */
melhorcaminhoestacoes(A, B, L) :- findall(LL, estacoes(A, B, LL), LS), menor(LS, L).
/* o predicado melhorcaminhobaldeacoes encontra com findall todas as possibilidades de caminho entre A e B e retorna a lista com o menor numero de linhas */
melhorcaminhobaldeacoes(A, B, L) :- achalinha(A, L1), achalinha(B, L2), findall(LL, caminho(L1, L2, LL), LS), menor(LS, L).
