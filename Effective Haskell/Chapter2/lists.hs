import Prelude hiding (foldr, foldl)

listOfNums = [1, 2, 3]
listOfFloats = [1.1, 2.2, 3.3]
listOfStrings = ["Hello", "Lists"]

stringAreListOfChar = ['h','e','l','l','o'] == "hello"

combinedLists = [1, 2, 3] <> [4, 5, 6]
combineCharListWithString = ['h', 'e'] <> "llo"
combinedListOfLists = [[1, 2, 3], [4, 5, 6]] <> [[7, 8, 9]]

wordsList = ["foo", "bar", "baz", "fizz", "buzz"]
word1 = wordsList !! 0
word2 = wordsList !! 1

list1 = 1 : [2,3]
list2 = 1 : 2 : [3]
list3 = 1 : 2 : 3 : []
list4 = 'h' : "ello"
list5 = 'h' : 'e' : ['l','l','o']
list6 = [1,2,3] : []
list7 = [1] : [2] : [3] : []

headAndTail1 = head [1,2,3]
-- 1
headAndTail2 = tail [1,2,3]
-- [2,3]
headAndTail3 = head (tail [1,2,3])
-- 2
headAndTail4 = tail (tail [1,2,3])
-- [3]
headAndTail5 = tail [1]
-- []

listIsEmpty list =
  if list == []
    then print "This list is empty"
  else print $ "the first element of this list is: " <> show (head list)

listIsEmpty' list =
  if null list
    then print "This list is empty"
  else print $ "the first element of this list is: " <> show (head list)


countUpAux acc n =
  if acc >= n then []
  else acc : countUpAux (acc + 1) n

countUp = countUpAux 0

countUp2 num =
  countUp2' 0 num
  where
    countUp2' acc num =
      if acc >= num then []
      else acc : countUp2' (acc + 1) num

factors num =
  factors' num 2
  where
    factors' num fact
      | num == 1 = []
      | (num `rem` fact) == 0 = fact : factors' (num `div` fact) fact
      | otherwise = factors' num (fact + 1)


isBalanced :: [String] -> Bool
isBalanced s =
  0 == isBalanced' 0 s
  where
    isBalanced' count s
      | null s = count
      | head s == "(" = isBalanced' (count + 1) (tail s)
      | head s == ")" = isBalanced' (count - 1) (tail s)
      | otherwise = isBalanced' count (tail s)

reduce func carryValue lst =
  if null lst then carryValue
  else
    let
      intermediateValue = func carryValue (head lst)
      in reduce func intermediateValue (tail lst)

isBalanced' str =
  0 == reduce checkBalance 0 str
  where
    checkBalance count letter
      | letter == '(' = count + 1
      | letter == ')' = count - 1
      | otherwise = count

concatString =
  reduce concat ""
    where
      concat acc letter = acc <> letter

foldl func carryValue lst =
  if null lst
    then carryValue
  else foldl func (func carryValue (head lst)) (tail lst)

foldr func carryValue lst =
  if null lst
    then carryValue
  else func (head lst) $ foldr func carryValue (tail lst)

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

double = [ 2 * x | x <- [0..10]]
doubleOdds = [ 2 * x | x <- [0..10], odd x]

partyBudget'' isAttending willEat foodCost guests =
  sum $
  [foodCost food
  | guest <- map fst guests
  , food <- map snd guests
  , willEat guest food
  , isAttending guest
  ]

combineLists as bs =
  let
    a = head as
    b = head bs
    as' = tail as
    bs' = tail bs
  in
    if null as || null bs
      then []
    else (a,b) : combineLists as' bs'


mergedLists = combineLists [1..10] [11..20]
mergedLists' = combineLists ["h", "l", "o"] ["e", "l", "o"]
zipLists = zip ["h", "l", "o"] ["e", "l", "o"]
zipLists' = combineLists [1..10] [11..20]

pairwiseSum xs ys =
  let sumEles pairs =
        let a = fst pairs
            b = snd pairs
        in a + b
  in map sumEles $ zip xs ys

pairwiseSum' xs ys = map (uncurry (+)) $ zip xs ys

customGreeting "George" = "Oh, hey George"
customGreeting name = "Hello, " <> name

matchNumber 0 = "zero"
matchNumber n = show n

matchList [1,2,3] = "one, two, three"
matchList list = show list

matchTuple ("hello", "world") = "greetings"
matchTuple tuple = show tuple

matchBool True = "yep"
matchBool bool = "this must be false"

matchTuple' ("hello", "world") = "Hello there, you great big world"
matchTuple' ("hello", name) = "Oh, hi there, " <> name
matchTuple' (salutation, "George") = "Oh! " <> salutation <> " George!"
matchTuple' n = show n

partialFunc 0 = "I only work for zero!"

modifyPair p@(a,b)
  | a == "Hello" = "this is a salutation"
  | b == "George" = "this is a message for George"
  | otherwise = "I dont know what " <> show p <> " means"

favoritFood person =
  case person of
    "Ren" -> "Tofu"
    "Rebecca" -> "Falafel"
    "George" -> "Banana"
    name -> "I dont know what " <> name <> " likes!"

handleNums l =
  case l of
    [] -> "An empty list"
    [x] | x == 0 -> "a list called: [0]"
        | x == 1 -> "a list called: [1]"
        | even x -> "a singleton list containing an even number"
        | otherwise -> "the list contains " <> show x
    _list -> "the list has more than 1 element"

main = do
  print $ countUp 300
  print $ countUp2 30
  print $ factors 30
  print $ concatString ["a", "b", "c"]
  print $ doubleElems [1,2,3,4,5]
  print $ partyBudget (checkGuestList ["Ren", "Porter"]) foodCosts
  print mergedLists
  print mergedLists'
  print zipLists
  print zipLists'
  print $ pairwiseSum' [1..10] [11..20]
  print $ modifyPair ("Mike", "Tyson")