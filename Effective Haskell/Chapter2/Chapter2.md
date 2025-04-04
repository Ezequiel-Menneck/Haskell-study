# Working with Lists

## Writing Code Using Lists
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