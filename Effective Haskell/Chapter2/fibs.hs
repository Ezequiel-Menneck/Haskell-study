fib n
  | n == 0 = 0
  | n == 1 = 1
  | otherwise = fib (n - 1) + fib (n - 2)

fibsTest = map fib [0..]

smallFibs = 
  takeWhile (< 100) fibsTest

fibs firstFib secondFib =
  let nextFib = firstFib + secondFib
  in firstFib : fibs secondFib nextFib

fibs' =
  let 
    fibsHelp fibOne fibTwo =
        fibOne : fibsHelp fibTwo (fibOne + fibTwo)
  in fibsHelp 0 1

fibs'' = 0 : 1 : helper fibs'' (tail fibs'')
  where
    helper (a:as) (b:bs) =
      a + b : helper as bs

main = do
  print $ take 10 fibs'  
  print $ take 10 $ fibs 0 1  