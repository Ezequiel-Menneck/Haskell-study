makeGreeting salutation person =
  salutation <> " " <> person

makeGreeting' salutation person =
  let messageWithTrailingSpace = salutation <> " "
  in messageWithTrailingSpace <> person

extendedGreeting person = 
  let hello = makeGreeting "Hello" person
      goodDay = makeGreeting "I hope you have a nice afternoon" person
      goodBye = makeGreeting "See you later" person
      in hello <> "\n" <> goodDay <> "\n" <> goodBye

extendedGreeting' person =
  let hello = makeGreeting helloStr person
      goodDay = makeGreeting "I hope you have a nice afternoon" person
      goodBye = makeGreeting "See you later" person
      helloStr = "Hello"
      in hello <> "\n" <> goodDay <> "\n" <> goodBye

extendedGreeting'' person = 
  let joinWithNewLines a b = a <> "\n" <> b
      hello = makeGreeting "Hello" person
      goodbye = makeGreeting "Goodbye" person
  in joinWithNewLines hello goodbye

extendedGreeting''' person =
  let joinWithNewLines a b = a <> "\n" <> b
      joined = joinWithNewLines hello goodbye
      hello = makeGreeting "Hello" person
      goodbye = makeGreeting "Goodbye" person
  in joined

extendedGreeting'''' person = 
  let joinWithNewLines a b = a <> "\n" <> b
      helloAndGoodbye hello goodbye = 
        let hello' = makeGreeting hello person
            goodbye' = makeGreeting goodbye person
        in joinWithNewLines hello' goodbye'
  in helloAndGoodbye "Hello" "Goodbye"

letWhereGreeting name place = 
  let
    salutation = "Hello " <> name
    meetingInfo = location "Tuesday"
  in salutation <> " " <> meetingInfo
  where
    location day = "we met at " <> place <> " on a " <> day 

main =
  -- print $ makeGreeting "Hello" "George"
  -- print $ makeGreeting' "Hello" "Thomas"
  -- print $ extendedGreeting "Michael"
  -- putStrLn $ extendedGreeting' "Billy"
  -- putStrLn $ extendedGreeting'' "Travis"
  -- putStrLn $ extendedGreeting''' "Jack"
  -- putStrLn $ extendedGreeting'''' "Mike"
  putStrLn $ letWhereGreeting "Phill" "29 Avenue"