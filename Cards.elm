module Cards where

import Html exposing ( .. )
import Html.Attributes exposing ( .. )
import Markdown


-- CONTENT : CARDS SECTION
type alias Card =
    { title : String
    , image : Maybe String
    , body : String
    , actions : String
    }


cards : Html
cards =
    section
        [ classList
            [ ( "cards", True )
            , ( "flex-set", True )
            , ( "flex--content-around", True )
            , ( "flex-wrap", True )
            ]
        ]
        [ card introduction
        , card scope
        , card attribution
        ]


-- CARD helpers
card : Card -> Html
card model =
    div
        [ classList
            [ ( "card", True )
            , ( "shadow--one", True )
            ]
        ]
        [ cardHeader model.title
        , cardContent model.body
        , cardActions model.actions
        ]


cardHeader : String -> Html
cardHeader title =
    div
        [ class "card--header" ]
        [ img
            [ class "card--image hidden"] [ ]
        , div
            [ classList
                [ ("elm-orange", True )
                , ("card--header-text", True )
                ]
            ]
            [ text title ]
        ]

cardContent : String -> Html
cardContent body =
    div
        [ class "card--content" ]
        [ Markdown.toHtml body ]


cardActions : String -> Html
cardActions actions =
    div
        [ classList
            [ ( "card--actions", True )
            , ( " flex-set",True )
            ]
        ]
        [ div
            [ class "card--action" ]
            [ text actions ]
        ]


-- ACTUAL CARDS
introduction : Card
introduction =
    Card
        "Introduction" Nothing introductionBody "read more"

introductionBody = """
This is a tutorial for the **Elm** programming language, a language for creating web
pages and web applications using Functional Reactive Programming (FRP) techniques.

Follow along a series of "talked through" code examples to learn essential concepts and
techniques to bring the clarity and structure of Elm to your browser.
"""

scope : Card
scope =
    Card
        "Scope" Nothing scopeBody "read more"

scopeBody = """
This version targets Elm core version **0.15.1.**

Elm continues to improve its API, expressiveness and approachability to developers
without a background in functional programming.

While the tutorial author strives to keep this content up-to-date with _Elm latest_,
there are no hard-and-fast guarantees about accuracy or fitness-to-use.
"""

attribution : Card
attribution =
    Card
        "Attribution" Nothing attributionBody "read more"

attributionBody = """
Substantially all of the this site's content is from the original work of author/developer
[Grzegorz Balcerek](http://elm-by-example.org "Original Elm-by-example site"), and is published as a derivative work under
[CC BY-SA 4.0](http://www.creativecommons.org/licenses/by-sa/4.0/ "Lots more about CC 4.0").

Certain changes have been made to the original content for usability and display. A full list
of alterations can be found below.
"""
