import Distribution.Compat.CharParsing (CharParsing(string))
x :: Integer
x = 10

y :: Integer = 50

inRange :: Integer -> Integer -> Integer -> Bool
inRange min max x = x >= min && x <= max
j = inRange 10 20 15

fac n 
  | n <= 1 = 1
  | otherwise = n * fac (n-1)

k = fac 3

isZero 0 = True
isZero _ = False

w = isZero 50

main = do
  putStrLn "Hello World!"
  putStrLn ("Please look at my favorite odd numbers: " ++ show (filter odd [10..20])) 
  print (show k)
  print (show w)