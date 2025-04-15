
## 1. Funções Recursivas
 Função recursiva é uma função que chama a si mesma até o caso base, exemplo a função fatorial:
 ```haskell
 factorial :: Integer -> Integer
 factorial 0 = 1
 factorial n = n * factorial (n - 1)
 ```
### Como funciona: 
- factorial 3 vai calcular:
	- 3 \* factorial 2
	- 2 \* factorial 1
	- 1 \* factorial 0 -> que é 1
- Resultado 3 \* 2 \* 1 \* 1 = 6

## 2. Funções Co-Recursivas
Uma co-recursão normalmente é usada para gerar **estruturas infinitas**, como **streams**. Ao contrário da recursão que consome dados, **co-recursão produz dados.**
Exemplo de lista infinita dos números naturais
```haskell
natuals :: [Integer]
naturals = from 0
	where
		from n = n : from (n + 1)
```
### Como funciona:
- naturals gera: \[0, 1, 2, 3, 4, 5, 6, ....]
- A função `from` é **co-recursiva** ele constrói de modo lazy uma lista infinita

### Funções Mutuamente Recursivas
Duas (ou mais) funções são **mutuamente recursivas** quando **uma chama a outra** em um ciclo..
Exemplo: Verificar se um número é par ou ímpar
```haskell
isEven :: Integer -> Bool
isEven 0 = True
isEvent n = isOdd (n - 1)

isOdd :: Integer -> Bool
isOdd 0 = False
isOdd n = isEvent (n - 1)
```
### Como funciona:
- isEvent 4 -> isOdd 3 -> isEven 2 -> isOdd 1 -> isEven 0 -> True
- isOdd chama isEven e vice-versa.

## Resumo Rápido 📝

|Técnica|Característica principal|Exemplo prático|
|---|---|---|
|Recursiva|Chama a si mesma|Fatorial|
|Co-recursiva|Gera estruturas infinitas (lazy evaluation)|Lista infinita|
|Mútua recursiva|Funções se chamam entre si|`isEven` e `isOdd`|
