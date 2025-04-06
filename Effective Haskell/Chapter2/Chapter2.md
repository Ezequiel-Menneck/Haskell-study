# Working with Lists

# Writing Code Using Lists
Listas são criadas utilizando *[]* e os elementos separados po *,*. Podemos ter listas do tipo que quisermos, como em qualquer outra linguagem.
Listas só podem ter um tipo, ou seja, não podemos fazer algo como `[1, "a"]`

Em haskell temos um tipo especial de lista, Strings. Strings em Haskell não são nada mais que uma lista de *char*. Podemos ver isso com a comparação seguinte no *ghci*
```haskell
['h','e','l','l','o'] == "hello"
-- True
```

Para juntarmos listas em uma nova podemos utilizar o operador *<>* que já usamos com Strings.
Exemplo no *ghci*
```haskell
[1,2,3] <> [4,5,6]
[1,2,3,4,5,6]
['h', 'e'] <> "llo"
"hello"
[[1,2,3],[4,5,6]] <> [[7,8,9]]
[[1,2,3],[4,5,6],[7,8,9]]
```

Para pegarmos o elemento *nth* podemos utilizar o operador *!!* seguido do indice, algo como:
```haskell
wordsList = ["foo", "bar", "fizz", "baz", "buzz"]
wordOne = wordsList !! 0
-- wordOne == "foo"
```

Se tentarmos pegar um indice fora do range da lista teremos uma exeção `"*** Exception: Prelude.!!: index too large`

Em Haskell listas também são imutáveis. Então ao invés de mudarmos uma lista o comum é criarmos uma nova adicionando elementos ao começo de uma lista ja existente. Esse processo é chamado de *cons-ing* e o operador que usamos é o *:*, que chamamos de *cons*. Exemplos no *ghci*:
```haskell
λ 1 : [2,3]
λ 1 : 2 : [3]
λ 1 : 2 : 3 : []
λ 'h' : "ello"
λ 'h' : 'e' : ['l','l','o']
λ [1,2,3] : []
λ [1] : [2] : [3] : []
```

Listas em haskell também utilizam da nomenclatura de `head` e `tail` para definir o primeiro elemento e o restante da lista. A tail de uma lista é qualquer lista vazia com sua própria head e tail, então também podemos olhar para uma lista com uma série de heads que no final temos uma lista vazia, como:
`head : tail = head : (head : (head : ... : []))`

Também temos as funções `head` e `tail` que nos ajudam a pegar os elementos respectivos, exemplo no *ghci*:
```haskell
λ head [1,2,3]
1
λ tail [1,2,3]
[2,3]
λ head (tail [1,2,3])
2
λ tail (tail [1,2,3])
[3]
λ tail [1]
[]
```

Essas funções são muito úteis quando queremos pegar diferentes partes de uma lista que criamos, porém, alguma atenção é necessária. As duas funções são *partial functions*, isso significa que a função não é preparada para todo tipo possível de input, e pode lançar uma runtime exception ou causar o crash do programa. Ambas as funções lançam uma runtime exception se o valor passado a elas for uma lista varia:
```haskell
λ head []
*** Exception: Prelude.head: empty list
λ tail []
*** Exception: Prelude.tail: empty list
```

Podemos verificar se uma lista é vazia com ==, exemplo:
```haskell
listIsEmpty list =
  if list == []
    then putStrLn "this list is empty"
  else putStrLn ("the first element of this list is: " <> show (head list))

listIsEmpty' list =
  if null list
    then putStrLn "this list is empty"
  else putStrLn ("the first element of this list is: " <> show (head list))
```

## Creating Lists Recursively

Quando estamos criando listas recursivamente nosso caso base sempre sera uma lista vazia `[]`, que iremos ir adicionando elementos recursivamente em casa passo do algoritmo. Exemplo:
```haskell
countdown n =
  if n <= 0 then []
  else n : countdown (n - 1)
```

Nesse exemplo contamos de um número N até 0 e adicionamos isso na lista, algo como:
`[10, 9, 8, 7, 6, 5, 4, 3, 2, 1]`

Se analisarmos o algoritmo final pensando nos passos que a recursão faz ele seria algo assim:
```haskell
countdown 3 =
  if 3 <= 0-- false
  then []
  else 3 : (
    if 2 <= 0-- false
    then []
    else 2 : (
      if 1 <= 0-- false
      then []
      else 1 : (
        if 0 <= 0-- true
        then []
        else undefined
        ))) 
```
Resolvendo todos os passos teriamos algo como: `countdown 3 = 3 : 2 : 1 : []`

Outro exemplo mas ahora um exemplo onde pegamos os fatores a partir de 2 de um número X
```haskell
factors num =
  factors' num 2
  where
    factors' num fact
      | num == 1 = []
      | (num `rem` fact) == 0 = fact : factors' (num `div` fact) fact
      | otherwise = factors' num (fact + 1)
```

Nesse exemplo temos um padrão comum que é quando nosso algoritmo requer um valor auxuliar mas não desejamos que o usuário nos passe esse valor inicial, nesses casos o comum é utilizarmos a notação de `let` ou `where` para criar uma função `helper` dentro de nossa própria função que passe esse valor para nós.

## Deconstructing List

Desconstruir listas em haskell é um outro padrão, fazemos isso frequentemente. Em um app normal vamos ter um caso base de lista vazia e um caso recursivo que faz alguma computação com a head da lista e passa o acumulado para ela mesma recursivamente.
Exemplo:
```haskell
isBalanced s =
  0 == isBalanced' 0 s
    where
        usBalanced' count s
          | null s = count
          | head s == '(' = isBalanced' (count + 1) (tail s)
          | head s == ')' = isBalanced' (count - 1) (tail s)
          | otherwise = isBalanced' count (tail s)
```

Como na função de `factors` temos uma função helper que tem um acumulador.
Percorer listas é comum então em alguns casos queremos criar nossa implementação disso para reusar, exemplo:
```haskell
reduce func carryValue lst =
  if null lst then carryValue
  else
    let intermediateValue = func carryValue (head lst)
    in reduce func intermediateValue (tail lst)
```
Na comunidade Haskell, quando estamos falando sobre o comportamento essencial de uma função ou um tipo de dados, sem qualquer lógica de negócios estranha ou detalhes de implementação, às vezes nos referimos a isso como a forma da função ou estrutura de dados. Neste caso, podemos dizer que esta função tem a forma de qualquer função recursiva geral sobre uma lista.
Vamos usar `reduce` para refatorar `isBalanced`
```haskell
isBalanced str =
  0 == reduce checkBalance 0 str
  where
    checkBalance count letter
      | letter == '(' = count + 1
      | letter == ')' = count - 1
      | otherwise = count
```

Agora nesse caso não precisamos nos preocupar mais com a recursão, apenas com a lógica da função visto que a função de reduce nos proporciona a recursão.

Essa função já vem implementada na lib padrão de Haskell e se chama `foldl`. O termo geral em Haskell para funções que acumulam valores enquanto recorrem sobre uma estrutura são chamados de *folds*.
Também temos a função de `foldr`.
Esses nomes são para "fold left" e "fold right".

Vamos ver as implementações delas:
```haskell
foldl func carryValue lst =
  if null lst
    then carryValue
  else foldl func (func carryValue (head lst)) (tail lst)

foldr func carryValue lst =
  if null lst
    then carryValue
  else func (head lst) $ foldr func carryValue (tail lst)
```
![[Captura de Tela 2025-04-03 às 20.16.55.png]]
Na imagem acima podemos ver como a função de `foldl` é aplicada.
```haskell
foldl (+) 0 [1,2,3] =
  if null [1,2,3] then 0
  else foldl (+) (0 + 1) [2,3]
foldl (+) (0 + 1) [2,3] =
  if null [2,3] then (0 + 1)
  else foldl (+) ((0 + 1) + 2) [3]
foldl (+) ((0 + 1) + 2) [3] =
  if null [3] then ((0 + 1) + 2)
  else foldl (+) (((0 + 1) + 2) +3) []
foldl (+) (((0 + 1) + 2) + 3) []
  if null [] then (((0 + 1) + 2) + 3)
  else undefined-- we'll never get here
-- result (((0 + 1) + 2) + 3) = 0 + 1 + 2 + 3 = 6
```
É uma função *left-associative*, o resultado começa a ser montado a partir da esquerda para direita.

**foldr**
![[Captura de Tela 2025-04-03 às 20.24.48.png]]
Na imagem acima é a função de **foldr** que é *right-associative*
```haskell
foldr (+) 0 [1,2,3] =
  if null [1,2,3] then 0
  else (1 + (foldr (+) 0 [2,3]))
foldr (+) 0 [2,3] =
  if null [1,2,3] then 0
  else (1 + (2 + (foldr (+) 0 [3])))
foldr (+) 0 [3] =
  if null [1,2,3] then 0
  else (1 + (2 + (3 + (foldr (+) 0 []))))
foldr (+) 0 []=
  if null [1,2,3] then 0
  else undefined-- false
-- result (1 + (2 + (3 + 0))) = 6
```
Quando usamos as funções de *fold* são elas que determinam se nossa expressão será *left-associative ou right-associative* então passando um operador (/) para uma foldr ela será *right-associative* mesmo o operador (/) sendo left.

1. O l em foldl significa associativo esquerdo. 
2. Em uma dobra esquerda, o valor inicial é aplicado primeiro, no lado esquerdo da expressão desenrolada. 
3. Em uma dobra esquerda, o valor do acumulador é o primeiro argumento (esquerdo) da função que você passa. 
4. O r em folderr significa associativo direito. 
5. Em uma dobra direita, o valor inicial é aplicado por último, no lado direito de uma expressão desenrolada. 
6. Em uma dobra direita, o acúmulo

## Transforming List Elements

Para transformar elementos de uma lista em Haskell também temos a função de `map` como nas linguagens mais comuns do mercado. Podemos fazer isso com ela ou com recursão.
Exemplos:
```haskell
doubleElems :: [Int] -> [Int]
doubleElems nums =
  if null nums
    then []
  else
    let 
      hd = head nums
      tl = tail nums
    in (2 * hd) : doubleElems tl

doubleElems' = foldr doubleElem []
  where
    doubleElem num lst = (2 * num) : lst

doubleElems'' :: Num a => [a] -> [a]
doubleElems'' elems = foldr (applyElem (2*)) [] elems
  where
    applyElem f elem accumulator = f elem : accumulator

map' f = foldr (applyElem f) []
  where 
    applyElem f elem accumulator = f elem : accumulator

map'' :: (a1 -> a2) -> [a1] -> [a2]
map'' f xs = 
  if null xs then []
  else f (head xs) : map'' f (tail xs)
```

## Filtering List elements

*Filter function* igual nas linguagens comuns do mercado.
Permite selecionarmos itens X de uma lista, passamos uma função que retorna True para N caso e ela mantem esse item para nós. Exemplo de uma função que soma os números impares de 0 a 10
```haskell
sumOdd =
	(foldr (+) 0 . filter odd) [0..10]
```
Em Haskell é comum combinarmos as funções de **filter, fold e map** em um processo de dados em pipeline. Combinando esses blocos podemos criar funções complexas de maneira fácil. Exemplo uma função *foodBudget* que nos ajuda a encontrar os gastos de uma festa.
```haskell
checkGuestList guestList name =
  name `elem` guestList

foodCosts =
  [("Ren", 10.00)
  ,("George", 4.00)
  ,("Porter", 27.50)]

partyBudget :: Num c => (b -> Bool) -> [(b, c)] -> c
partyBudget isAttending =
  foldr (+) 0 . map snd . filter (isAttending . fst)

partyBudget' :: Num c => (b -> Bool) -> [(b, c)] -> c
partyBudget' isAttending =
  foldr ((+) . snd) 0 . filter (isAttending . fst)
```
Explicando a função em passo a passo:
```haskell
partyBudget' =
foldr (+) 0
. map snd
. filter (\name -> fst name `elem` ["Ren","Porter"])
$ [("Ren", 10.00) ,("George", 4.00) ,("Porter", 27.50)]
```
Quando compomos funções desse tipo casualmente queremos de da direita para esquerda. Nesse caso vamos começar lendo nosso *filter*.
```haskell
fst ("Ren", 10.00) `elem` ["Ren","Porter"]
True
fst ("George", 4.00) `elem` ["Ren","Porter"]
False
fst ("Porter", 27.50) `elem` ["Ren","Porter"]
True
```
Após filtrarmos temos o seguinte resultado GHCI:
```haskell
λ :{
> filteredNames =
> filter (\name -> (fst name) `elem` ["Ren","Porter"]) $
> [ ("Ren",10.00)
> , ("George",4.00)
> , ("Porter",27.50)]
> :}
λ filteredNames
[("Ren",10.0),("Porter",27.5)]
```
Depois passamos nossa lista de *filteredNames* a função de transformação *map snd*.
```haskell
map snd [("Ren",10.00),("Porter",27.5)]
= [snd ("Ren",10.00), snd ("Porter",27.5)]
= [10.00,27.5]
```
E para finalizar só precisamos chamar ela com o *foldr* e aplicar a soma:
```haskell
foldr (+) 0 [10.0, 27.5]
37.5
```

## Building Lists with Comprehensions

Podemos fazer combinações de *filter e map* usando *List Comprehensions*. É uma sintaxe alternativa para criar listas com maps e filters.
A sintaxe é essa:
```haskell
double = [2 * number | number <- [0..10]]
```
Double - Nome da lista
2 \* number - Expressão que vamos aplicar
| divisor de expressão e de quem é number
number <- \[0..10] - Quais os valores iniciais de number (lista)

Se quisermos dobrar apenas numeros impares podemos fazer assim:
```haskell
doubleOdds = [number * 2 | numer <- [0..10], odd number]
```

A diferença nesse exemplo é que adicionamos um filtro que fica depois da declaração de quem é a lista que vamos operar.
Mesma função escrita sem *List Comprehensions*
```haskell
double = map (\number -> number * 2) . filter odd $ [0..10]
```

List Comprehensions começa a ter valor quando temos funções mais complexas em cima de uma lista, mais de um filtro diferente. Exemplo onde queremos pegar duas listas de números e retornar os pares de elementos que aparecem na primeira e na segunda lista, apenas com os numeros impares da segunda lista:
```haskell
pairs as bs =
  let as' = filter (`elem`bs) as
      bs' = filter odd bs
      makePairs a = map (\b -> (a,b)) bs'
  in concat $ map mkPairs as'

pairs [1..10] [2..5]
-- [(2,3),(2,5),(3,3),(3,5),(4,3),(4,5),(5,3),(5,5)]
```

Agora vamos escrever isso com *List Comprehensions*
```haskell
pairs as bs =
  [(a,b) | a <- as, b <- bs, a `elem` bs, odd b]
```
Muito mais simples e enxuto de escrever, fica nitido oque queremos.

Outro exemplo agora com nossa função de *partyBudget* adicionando novas opções:
```haskell
partyBudget isAttending willEat foodCost guests = 
  foldl (+) 0 $
  [foodCost food
  | guest <- map fst guests
  , food <- map snd guests
  , willEat guest food
  , isAttending guest
  ]
```
*List Comprehensions* é para quando queremos fazer modificações nas listas inteiras, se quisermos combinar apenas o primeiro elemento de uma lista com outra sera uma abordagem diferente:
```haskell
[(num, str) | num <- [1,2,3], str <- ["I","II","III"]]
-- [(1,"I"),(1,"II"),(1,"III"),(2,"I"),(2,"II"),(2,"III"),(3,"I"),(3,"II"),(3,"III")]
```

Nesse caso não conseguimos associar cada um com seu romano respectivo, ja que a *List Comprehensions* aplica em tudo. Podemos fazer isso com criando uma função manual.
```haskell
combinesLists as bs =
  let
    a = head as
    b = head as
    as' = tail as
    bs' = tail bs
  in
    if null as || num bs
      then []
    else (a, b) : combinesLists as' bs'
```
Como *map e fold* na lib Std ja temos uma função que faz a mesma coisa que nossa função *combinesLists* a função *zip*.
Combinar *lists* em uma tupla normalmente não é muito útil, mas *zip* consegue ser combinado com *map e fold* para criar aplicações mais sofisticadas

Exemplo somando os pares de 2 listas, 1 numero com 1, 2 com 2 e assim vai:
```haskell
pairwiseSum xs ys =
  let sumEles pairs =
        let a = fst pairs
            b = snd pairs
        in a + b
  in map sumEles $ zip xs ys

pairwiseSum' xs ys = map (uncurry (+)) $ zip xs ys
```

# Destructuring Values with Pattern Matching

*Pattern Matching* nos permite escrever expressões poderosas que combinem partes de um valor baseado na sua estrutura

Na forma mais simples nos possibilita substituir uma variavel por um valor especifico.
O padrão vai combinar se a variavel for igual o valor. Exemplo:
```haskell
customGreeting "George" = "Oh, hey George"
customGreeting name = "Hello, " <> name
```
Uma das implementações verifica se o parametro é "George" se sim retorna a mensagem especial e a outra retorna a mensagem comum caso o parametro não seja "George"

O Pattern matching acontece de forma *top-to-bottom* ou seja, se a função de *customGreeting name* fosse declarada primeira nunca conseguiriamos ter o resultado personalizado, visto que no primeiro caso ja bateria na função.

Mais exemplos de *Pattern Matching*:
```haskell
matchNumber 0 = "zero"
matchNumber n = show n

matchList [1,2,3] = "one, two, three"
matchList list = show list

matchTuple ("hello", "world") = "greetings"
matchTuple tuple = show tuple

matchBool True = "yep"
matchBool bool = "this must be false"
```
Além de modo que temos um caso especial primeiro e depois um catch-all também é possível aplicar pattern matching de outra maneira. Podemos ter uma série de casos diferentes, exemplo:
```haskell
matchTuple ("hello", "world") = "Hello there, you great big world"
matchTuple ("hello", name) = "Oh, hi there, " <> name
matchTuple (salutation, "George") = "Oh! " <> salutation <> " George!"
matchTuple n = show n
```
No final dos padrões sempre temos um caso genérico que podemos fazer o catch caso nenhum dos casos seja aceito.

Com isso também temos funções parciais que são funções que não atendem todas as possibilidades, não aceitam um caso default. Exemplo:
```haskell
partialFunc 0 = "I only work for zero!"
-- partialFunc 0
-- I only work for zero
-- partialFunc 1
-- *** Exception: <interactive:75:1-39>: Non-exhaustive pattern in function partialFunc
```
Não precisamos de um caso catch-all / wildcard para um *pattern matching* se conseguimos mapear todas as posibilidades, por exemplo com Boolean, onde só temos 2 possibilidades, *True e False*:
```haskell
matchBool True = "True, sorry"
matchBool False = "Sorry, this is just not True"
```
## Destructuring Lists

Podemos utilizar pattern matching de diferentes maneiras, no começo vimos que sempre que queriamos trabalhar com algum valor de uma lista precisavamos verificar se era vazia, pegar o head, pegar o tail, fazer algo, chamar a recursão. Agora com pattern matching podemos fazer algo como:
```haskell
addValues [] = 0
addValues (first:rest) = first + (addValues rest)
```

Nesse caso fazemos o matching de 2 casos, no primeiro verificamos se a lista está vazia e caso sim retornamos 0 e no segundo extraimos a head e tail que chamamos de first e rest e chamamos a recursão.

Podemos também utilizar *pattern matching* em let expressions como:
```haskell
fancyNumber n = (zip fibs primes) !! n

printFancy n =
  let (fib, prime) = fancyNumbers n
      fib' = show fib
      prime' = show prime
  in "The fibonacci number is " <> fib' <> " and the prime is: " <> prime'
```

Em alguns casos vamos precisar pegar o valor da nossa variavel antes de ser desconstruida no pattern matching. Podemos fazer isso adicionando o nome da váriavel junto com um @ antes do *pattern*. Exemplo:
```haskell
modifyPair p@(a,b) 
  | a == "Hello" = "this is a salutation"
  | b == "George" = "this is a message for George"
  | otherwise = "I dont know what " <> show p <> " means"
```

Um *pattern* especial que podemos usar é o *wildcard pattern*. É um padrão que combina com qualquer valor, como uma variavel, mas sem o binding de valor para a variavel na função. É algo como "o valor deveria estar aqui mas não ligo". Para usar wildcard usamos o \_ ao invés de o nome da variavel. Vamos ver um exemplo onde implementamos nossa função *fst e snd*.
```haskell
import Prelude hiding (fst, snd)

fst (x, _, _) = x
snd (_, x, _) = x
thrd (_, _, x) = x

map ($ (1,2,3)) [fst, snd, thrs]
-- [1, 2, 3]
```

Para ignorar totalmente o valor da variavel usamos \_ que ja informa o time que é um valor que não  precisaremos. Em outros casos também é comum usar uma variavel onde o nome começa com \_. Como:
```haskell
printHead [] = "empty"
printHead lst@(hd:_tail) =
	"the head of " <> (sho lst) <> " is " <> show hd
```
Nesse caso o nome *_tail* é para deixarmos claro que o valor de tail não será usado.

Além de podermos fazer o match de nossas funções na declaração também podemos fazer o match dela para diferentes inputs dentro do corpo com *case*. O *case* nos permite aplicar o *pattern matching* em um valor dentro de nossa função. Podemos combinar *pattern matching e guards* para criar uma condicional expressiva. *Case* parece como um switch de outras langs. Exemplo:
```haskell
favoritFood person =
  case person of
    "Ren" -> "Tofu"
    "Rebecca" -> "Falafel"
    "George" -> "Banana"
    name -> "I dont know what " <> name <> " likes!"
```

Podemos combinar *case* com *guards*. Exemplo:
```haskell
handleNums l =
  case l of
    [] -> "An empty list"
    [x] | x == 0 -> "a list called: [0]"
        | x == 1 -> "a list called: [1]"
        | even x -> "a singleton list containing an even number"
        | otherwise -> "the list contains " <> show x
    _list -> "the list has more than 1 element"
```

## Getting Warned About Incomplete Patterns

