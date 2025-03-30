# Criando Variáveis

Variáveis em Haskell começam com uma letra minuscula e podem conter letras, numeros, underline e uma até uma aspa simples ('). Por conveniencia Haskell utiliza camelCase.

Podemos re-utilizar variáveis. Por exemplo usando o GHCI

```haskell
greeting = "Good Morning"
greeting
"Good Morning"
greeting = "Good Afternoon"
greeting
"Good Afternoon"
```

Nesse caso estamos reutilizando o nome de váriavel 'greeting' porém não estamos alterando seu valor. Isso é chamado de **subtle distinction**.
Vamos ver um exemplo na prática

```haskell
one = 1
two = one + one
one
1
two
2

one = 5
one
5
two
2
```

A partir de quando começamos a re-utilizar a variavel `one` estamos mirando no seu novo valor que é uma nova variável internalmente, todo o código escrito antes da troca de valor continuára utilizando o valor original.

# Escrevendo funções

Para definir funções em Haskell apenas damos um nome a ela e em seguida passamos os nomes de seus parametros, sem () apenas os nomes, como:

```haskell
makeGreeting salutation person =
  salutation <> " " <> person
```

Nesse exemplo `makeGreeting` é a função e `salutation` e `person` os argumentos.

Para definirmos funções anonimas usamos o backslash (\) seguido dos parametros e no final uma seta (->) para o corpo, por exemplo:

```haskell
\salutation person -> salutation <> " " <> person
```

Em Haskell é comum chamarmos funções que tem mais de 1 parametro com menos parametros que o total, algo como:

```haskell
greetPerson = makeGreeting "Hello"
```

Nesse caso criamos uma função chamada `greetPerson` dando para a função `makeGreeting` apenas o primeiro argumento. Como sabemos em Haskell todas as funções recebem apenas um parametro. Isso ocorre que toda função de mais de 1 parametro retorna outra função com um parametro a menos até termos a função de um parametro, que é esse caso. `makeGreeting` retornou uma nova função que recebe 1 parametro.

```haskell
makeGreeting :: String -> String -> String
greetGeorge :: String -> String
```

O oposto também é possível. Esse processo de remover parametros é chamado de `eta reductio / η-reduction` e o de adicionar parametros é chamado `eta expansion`.

Em Haskell operadores como (\*) e (<>) são funções que são infixas por padrão. Podemos aplicalas parcialmente igual qualquer outra função, exeto que temos que adicionar () entre ela. Podemos aplicar ela tanto para o elemento da esquerda quanto para o da direita, exemplo:

```haskell
λ half = (/2)
λ twoOver = (2/)
λ half 10
λ half 20
λ twoOver 2
λ twoOver 8
```

Também podemos transformar funções regulares em funções infixas, fazemos isso adicionar um (`). Isso ajuda a deixar o código mais simples de ler e também ajuda a quando queremos aplicar somente o segundo argumento da função (funciona pro primeiro também mas ai não faria sentido).

```haskell
greetGeorge = (`makeGreeting` "George")
greetGeorge "Hello"
"Hello George"
```

Podemos também utilizar a função `flip` para isso. Podemos escrevela facilmente como:

```haskell
flip someFunction arg1 arg2 = someFunction arg2 arg1
```

Agora podemos utilizar ela no mesmo lugar que os (`)

```haskell
λ greetGeorge = flip makeGreeting "George"
λ greetGeorge "Good Afternoon"
"Good Afternoon George"
```

# Composing Functions

Composição de funções é sobre criar novas funções que pegue 2 ou mais funções pequenas e crie uma função grande.
Exemplo no GHCI:

```haskell
addOne num = num + 1
timesTwo num = num * 2
squared num = num * num
minusFive num = num -5

result1 = addOne 1
result2 - timesTwo result1
result3 = squared result2
minusFive result3
11
```

Nesse exemplos compomos todas as funções criando valores intermediários e passando eles para a função seguinte. Ao invés disso podemos utilizar parenteses para chamar outra função diretamente. Isso torna muito mais fácil de reutilizar uma coleção de funções. Exemplo:

```haskell
findResult num = minusFive (squared (timesTwo (addOne num)))
findResult 1
11
```

Como vemos nesse caso é muito mais simples de ler e fácil de chamar a função para diferentes valores.
Como composição é algo frequentemente usado em Haskell temos um punhado de ferramentas que nos ajudam a deixar isso mais fácil. Temos duas funções chamadas de ($) e (.). O aplicador de função operador ($) nos ajuda a evitar de termos muitos parenteses no código. O operador de composição de função (.) nos ajuda a criar novas funções combinando as ja disponiveis.

Exemplo de como utilizar o ($) no ghci:

```haskell
addOne $ timesTwo 1
```

O operador de $ nos ajuda a substituir os parenteses, oque ele faz é aplicar a função que esta a esquerda ao resultado que temos a direita.

Exemplos de como utilizar o (.) no GHCI:

```haskel
timesTwoPlusOne = timesTwo . addOne
timesEight = timesTwo . timesTwo . timesTwo
doubleIncremented = addOne . addOne
(timesTwo . addOne . squared . minusFive) 128
30260
```

Esse operador é uma _higher-order function_, um termo utilizado para descrever funções que recebem outras funções como parametro ou que retorna uma função.
O operador (.) faz os dois. Combina duas funções e nos retorna uma novas função que aceita o argumento da segunda função que passamos a ele.

# Escrevendo funções sem parametros nomeados.

_Pointfree programming_ as vezes chamado de _tacit programming_ pega a ideia de _η-reduction_ e composição de funções para sua conclusão lógica por escrever funções que não pegam parametros nomeados no geral. Consideramos a função original de `makeGreeting`.

```haskell
makeGreeting salutation person = salutation <> " " <> person
```

Podemos aplicar _η-reduction_ uma vez para remover o ultimo parametro nomeado facilmente:

```haskell
makeGreeting' salutation = ((salutation <> " ") <>)
```

Para transformarmos a função em _pointfree_ precisamos repensar asobre a estrutura.

```haskell
makeGreeting' salutation = (<>) (salutation <> " ")
```

Essa versão faz a segunda chamada a (<>) ser uma prefix function. Pegamos o primeiro argumento salutation combinamos o mesmo com um espaço (" ") e retornamos uma nova função que espera um argumento (<> aplicado de maneira (<>) é a chamada da função diretamente, logo ela espera 2 parametros e passamos apenas um, retornando uma função que espera mais 1 parametro).
Próximo passo vamos trocar o parametro nomeado `salutation` por um,a função anonima:

```haskell
makeGreeting' = (<>) . (\salutation -> salutation <> " ")
```

Nesse caso funciona da mesma maneira que anteriormente, apenas agora que `salutation` entra como um parametro da função anonima.
Podemos refatorar ainda mais para chegarmos a _pointfree_ vejamos um exemplo onde quebramos isso em funções separadas.

```haskell
firstPart salutation = salutation <> " "
makeGreeting' = (<>) . firstPart
makeGreeting' "Hello" "george"
"Hello george"
```

Podemos refatorar a função `firstPart` de modo _pointfree_ reescrevendo como:

```haskell
firstPart = (<> " ")
makeGreeting' = (<>) . firstPart
makeGreeting' "Hello" "george"
"Hello george"
```

Agora podemos substituir a definição de `firstPart` direto na definição de `makeGreeting`.

```haskell
makeGreeting' = (<>) . (<> " ")
```

# Criando operadores personalizados.

Para criar nosso proprio operador de adição que chamaremos de (+++) temos duas formas, a primeira sendo definindo como escrevemos uma função na forma de prefixo com parenteses:

```haskell
(+++) a b = a + b
```

Alternativamente também podemos escrever de forma infixa com:

```haskell
a +++ b = a + b
```

A diferença é apenas no estilo de escrever, o resultado será o mesmo.

Se tentarmos utilizar esse operador personalizado ao invés do operador de soma padrão teremos resultados diferentes do esperado, como:

```haskell
ghci> 1 +++ 2 * 3
9
ghci> 1 + 2 * 3
7
```

Isso ocore pois nosso novo operador tem uma precedencia maior que a muiltiplicação. Quando criamos operadores novos por padrão eles já vem com a precedencia padrão como 9 (número máximo).
Além disso quando criamos operadores novos eles também já vem com a 'Fixidade' padrão de left-to-right, podemos definir isso de outra maneira também.

Para fazer essas mudanças no padrão de precedencia e no padrão de 'Fixidade' fazemos da seguinte maneira:

```haskell
infixl 6 +++
a +++ b = a + b
```

Desse modo agora nosso operador de `+++` tem precedencia de 6 ao invés de 9 (sendo 6 o valor de predencia do operador de +).

# Criando variáveis locais usando LET Bindings

Let bindings nos permite dar nome para expressões particulares em nosso programa. Exemplo:

```haskell
makeGreeting salutation person =
  let messageWithTrailingSpace = salutation <> " "
  in messageWithTrailingSpace <> person
```

Podemos utilizar quantas variaveis quiser dentro de um `let binding`. Exemplo:

```haskell
extendedGreeting person =
  let hello = makeGreeting "Hello" person
      goodDay = makeGreeting "I hope you have a nice afternoon" person
      goodBye = makeGreeting "See you later" person
  in hello <> "\n" <> goodDay <> "\n" <> goodBye
```

Com `let bindings` de alto level podemores referenciar bidings que definimos em uma mesma expressão let. Exemplo:

```haskell
extendedGreeting person =
  let hello = makeGreeting helloStr person
      goodDay = makeGreeting "i Hope you have a nice afternoon" person
      goodBay = makeGreeting "See you later" person
      helloStr = "hello"
  in hello <> "\n" <> goodDay <> "\n" <> goodBye
```

Quando estamos criando um `let binding` nossa expressão não precisa ser uma constante, como string ou número. Podemos utilizar `let bindings` para definirmos novas funções. A sintaxe é a mesma que definimos uma função de top level.

```haskell
extendedGreeting person =
  let joinWithNewLines a b = a <> "\n" b
      hello = makeGreeting "Hello" person
      goodbye = makeGreeting "Goodbye" person
  in joinWithNewLines hello goodbye
```

Haskell também suporta `recursive let bindings` oque significa que dentro de nossas `let bindings` podemos definir outras.
A ordem não importa, podemos referir itens que definimos mais a baixo. Exemplo

```haskell
extendedGreeting person =
  let joinWithNewLines a b = a <> "\n" <> b
      joined = joinWithNewLines hello goodbye
      hello = makeGreeting "Hello" person
      goodbye = makeGreeting "goodbye" person
  in joined
```

Além de `let` também eixstem outro tipo de binding chamado de `where binding`. Segue as mesmas regras de `let binding` exeto que ela é definida apenas no final da função e que usa a `keyword` `where` ao invés de `let`. Qualquer parametro que passamos para a função principal estão disponíveis no `where` porém os que definimos em `let` não estão, o contrário pode acontecer. Exemplo:

```haskell
letWhereGreeting name place =
  let
    salutation = Hello <> name
    meetingInfo = location "Tuesday"
  in salutation <> " " meetingInfo
  where
    location day = "we met at " <> place <> " on a " <> day
```

# Running Code Conditionally Using Branches
Em haskell temos 2 tipos de maneiras de trabalhar com branches, guards e if. Ambos são expressões como qualquer outra função.
Em haskell um IF sempre tera o ELSE, é como um operador ternário em outras langs ?:.

Podemos encadear IF's da maneira que preferirmos também. Exemplos:
```haskell
printSmallNumber num =
  if num < 10
    then print num
  else print "the number is to big"

printSmallNumber' num =
  let msg = if num < 10
      then show num
      else "the number is to big"
  in print msg

sizeNumber num = 
  if num < 3
    then "thats a small number"
    else
      if num < 10
        then "thats a medium sized number"
        else "thats a big number"

guardSize num
  | num < 3 = "thats a small number"
  | num < 10 = "thats a medium number"
  | num < 100 = "thats a big number"
  | num < 1000 = "thats a giants number"
  | otherwise = "thats a unfathomably big number"

guardSize' num
  | num > 0 =
    let size = "positive"
    in exclain size
  | num < 3 = exclain "small"
  | num < 100 = exclain "medium"
  | otherwise = exclain "large"
  where
    exclain message = "thats a " <> message <> " number!"
```

No caso de guards o let e where funcionam da maneira convencional, `where` está disponível em toda a expressão, em todo o contexto e `let` apenas dentro de sua branch.

