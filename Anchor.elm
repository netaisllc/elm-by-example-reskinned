module Anchor where

import Html exposing (..)
import Html.Attributes exposing (..)


type alias AnchorModel =
    { href : String
    , target : String
    , title : String
    , text : String
    }

-- Anchor: Original source site
anchorSourceSite : AnchorModel
anchorSourceSite =
    AnchorModel
        "http://elm-by-example.org/"
        "_blank"
        "Source website (Grzegorz Balcerek)"
        "Original Elm by Example"


-- Anchor: Elm-lang site
anchorElmSite : AnchorModel
anchorElmSite =
    AnchorModel
        "http://elm-lang.org/"
        "_blank"
        "Official Elm language website"
        "Elm Language"


-- Toolbar's anchor collection
anchors : List AnchorModel
anchors =
    [   anchorSourceSite
    ,   anchorElmSite
    ]


-- Toolbar's anchor constructor
anchor : AnchorModel -> Html
anchor model =
    a   [ href      model.href
        , target    model.target
        , title     model.title
        ]
        [ text      model.text ]
