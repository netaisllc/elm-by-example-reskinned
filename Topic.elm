module Topic where

import Html exposing ( .. )
import Html.Attributes exposing ( .. )


type alias TopicModel =
    { resource : String
    , name : String
    , slug : String
    }

-- Table of content's topics
topics : List TopicModel
topics =
    [ TopicModel "/" "Home" "Welcome to Elm by Example, the GUI cut."
    , TopicModel "content/requirements.md" "Requirements" "Things you'll want close at hand."
    , TopicModel "content/1.md" "1. Hello World" "Write your first Elm program. Woo-hoo!"
    , TopicModel "content/2.md" "2. Fibonacci Bars" "... ... ... ..."
    , TopicModel "content/3.md" "3. Mouse Signals" "... ... ... ..."
    , TopicModel "content/4.md" "4. Window Signals" "... ... ... ..."
    , TopicModel "content/5.md" "5. Eyes" "... ... ... ..."
    , TopicModel "content/6.md" "6. Time Signals" "... ... ... ..."
    , TopicModel "content/7.md" "7. Delayed Circles" "... ... ... ..."
    , TopicModel "content/8.md" "8. Circles" "... ... ... ..."
    , TopicModel "content/9.md" "9. Calculator" "... ... ... ..."
    , TopicModel "content/10.md" "10. Keyboard Signals" "... ... ... ..."
    , TopicModel "content/11.md" "11. Paddle" "... ... ... ..."
    , TopicModel "content/12.md" "12. Tic Tac Toe" "... ... ... ..."
    , TopicModel "content/13.md" "13. Snake" "... ... ... ..."
    , TopicModel "content/14.md" "14. Snake Revisited" "... ... ... ..."
    ]

