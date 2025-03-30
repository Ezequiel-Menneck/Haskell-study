fizzBuzzFor number 
  | 0 == number `rem` 15 = "fizzbuzz"
  | 0 == number `rem` 5 = "buzz"
  | 0 == rem number 3 = "fizz"
  | otherwise = show number

nativeFizzBuzz fizzBuzzCount curNum fizzBuzzString =
  if curNum > fizzBuzzCount
    then fizzBuzzString
  else 
    let nextFizzBuzzString = fizzBuzzString <> fizzBuzzFor curNum <> " "
        nextNumber = curNum + 1
    in nativeFizzBuzz fizzBuzzCount nextNumber nextFizzBuzzString

main = do
  print $ fizzBuzzFor 33