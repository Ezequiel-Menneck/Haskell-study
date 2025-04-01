factorial n  =
  if n == 1
    then n
  else 
    n * factorial (n - 1)

fibonacci n
  | n == 0 = 0
  | n == 1 = 1
  | otherwise = fibonacci (n - 1) + fibonacci (n - 2) 

curry' :: ((a, b) -> t) -> a -> b -> t
curry' f x y =
  f (x, y)

uncurry' :: (t1 -> t2 -> t3) -> (t1, t2) -> t3
uncurry' f (x, y) =
  f x y
    

ucurriedAddiciton nums = 
  let
    a = fst nums
    b = snd nums
  in a + b

addition = curry' ucurriedAddiciton
addition' = uncurry' addition



main = do
  print $ factorial 1
  print $ factorial 3
  print $ factorial 5
  print $ factorial 10
  print $ factorial 25
  print "------------------"
  print $ fibonacci 0
  print $ fibonacci 1
  print $ fibonacci 5
  print $ fibonacci 10
  print $ fibonacci 25
  print "------------------"
  print $ addition 10 25
  print $ addition' (30, 30)