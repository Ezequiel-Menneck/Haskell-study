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

main = do
  printSmallNumber 9
  printSmallNumber 22
  printSmallNumber' 3
  print $ sizeNumber 89
  print $ guardSize 9999
  print $ guardSize' 9999