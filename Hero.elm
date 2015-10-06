module Hero where

import Html exposing ( .. )
import Html.Attributes exposing ( .. )


-- CONTENT Hero section
hero : Html
hero =
    section
        [ class "hero" ]
        [ div
            [ classList
                [ ( "flex-set", True )
                , (" flex--content-center", True )
                ]
            ]
            [ div
                [ classList
                    [ ("hero--main", True )
                    , ("hidden-mobile", True )
                    ]
                ] [ ]
            , div
                [ class "perm-marker" ]
                [ text "Elm by Example" ]
            ]
        , div
            [ classList
                [ ( "hero--sub", True )
                ]
            ]
            [ text "In-depth exercises illustrating functional reactive programming in the browser using the Elm language"]
        ]