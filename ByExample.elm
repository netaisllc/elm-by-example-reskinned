module ByExample where

import Debug

import Cards exposing ( cards )
import Effects exposing ( Effects, Never )
import Hero exposing( hero )
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Markdown
import Signal exposing ( Signal, Address )
import Topic exposing( TopicModel, topics )
import Task


-- MODEL --

type alias Model =
    { anchors : List AnchorModel
    , content : Html
    , initDrawer : Bool
    , resource : String
    , showDrawer : Bool
    , showNext : Bool
    , showPrev : Bool
    , topics : List TopicModel
    }

type alias AnchorModel =
    { href : String
    , target : String
    , title : String
    , text : String
    }

-- Initial model
init : ( Model, Effects Action )
init =
  ( initialModel
  , Effects.none
  )

initialModel : Model
initialModel =
    { anchors = anchors
    , content = text ""
    , initDrawer = True
    , resource = "/"
    , showDrawer = False
    , showNext = True
    , showPrev = False
    , topics = topics
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


-- Some anchor tag options for Topics
topicOptions : Options
topicOptions =
    { stopPropagation = True
    , preventDefault = True
    }


-- Table of content's topic anchor constructor
topic : Address Action -> TopicModel -> Html
topic address model =
    div
        [ classList
            [ ( "flex-item", True )
            , ( "flex-set", True )
            , ( "flex--align-content-center", True )
            , ( "topic", True )
            ]
        , onClick address ( CallTopic model.resource )
        , title model.slug
        ]
        [ div [ ] [ text model.name ]
        , div [ class "secondary" ] [ text model.slug ]
        ]


-- UPDATE --

type Action
    = NoOp
    | Drawer
    | CallTopic String
    | LoadTopic (Maybe String)


update : Action -> Model -> ( Model, Effects Action )
update action model =
    case action of

        NoOp ->
            ( model
            , Effects.none
            )

        Drawer ->
            (
                ( touchDrawer model )
                , Effects.none
            )

        CallTopic resource ->
            (
                ( saveCall ( touchDrawer model ) resource )
                , getTopic resource
            )

        LoadTopic maybeTopic ->
            let
                defaultTxt = "##Topic not found"
            in
                ( { model | content <- ( Markdown.toHtml ( Maybe.withDefault defaultTxt maybeTopic ) ) }
                , Effects.none
                )


-- Store the requested resource and determine in-page navigation
saveCall : Model -> String -> Model
saveCall model resource =
    { model
        | resource <- resource
        , showPrev <- ( setPrevNavigation resource )
    }

setPrevNavigation : String -> Bool
setPrevNavigation resource =
    let
        home = "/"
        hidePrevious = False
        showPrevious = True
    in
        if resource == home then hidePrevious
        else showPrevious


touchDrawer : Model -> Model
touchDrawer model =
    -- Toggle TOC drawer,
    -- Always spoil initDrawer since it's only relevant to first page load
    { model
        | showDrawer <- ( not model.showDrawer )
        , initDrawer <- False
    }


-- VIEW --

-- WHOLE APP WRAPPER
appContainer : Address Action -> Model -> Html
appContainer address model =
    div [ ]
        [ div -- overlay
            [ classList
                [ ( "scrim", True )
                , ( "visible", model.showDrawer )
                ],
              onClick address Drawer
            ] [ ]
        , div -- app-container
            [ class "app-container" ]
            [ toolBar address model
            , drawer address model
            , content model
            ]
        ]


-- TOOLBAR anchors collection
toolBarAnchors : Model -> Html
toolBarAnchors model =
    let
        anchorSet = List.map anchor model.anchors
    in
        div
            [ classList
                [ ( "anchors", True )
                , ( "elm-sky-blue--bg", True )
                , ( "flex-set", True )
                ]
            ] anchorSet


-- TOOLBAR control icon
toolBarMenuIcon : Address Action -> Html
toolBarMenuIcon address =
    let
        classIcon = "icon menu"
        classIconShadow = "icon-shadow"
    in
      div
        [  class classIcon, onClick address Drawer ]
        [  div [ class classIconShadow  ] [ ] ]


-- TOOLBAR component
toolBar : Address Action -> Model -> Html
toolBar address model =
    div
        [ classList
            [ ( "elm-sky-blue--bg", True )
            , ( "flex-set", True )
            , ( "flex--content-between", True )
            , ( "toolbar", True )
            , ( "shadow--one", True )
            ]
        ]
        [ toolBarMenuIcon address
        , toolBarAnchors model
        ]


-- DRAWER component
drawer : Address Action -> Model -> Html
drawer address model =
    div
        [ classList
            [ ( "animated", True )
            , ( "drawer", True )
            , ( "hidden", ( model.initDrawer ) )
            , ( "slideInLeft", model.showDrawer )
            , ( "slideOutLeft", ( not model.showDrawer ) )
            , ( "shadow--one", True)
            ]
        ]
        [ drawerHeader model
        , drawerTopics address model
        ]


-- DRAWER Heading
drawerHeader : Model -> Html
drawerHeader model =
    div
        [ classList
            [ ( "drawer--top", True )
            , ( "elm-sky-blue--bg", True )
            , ( "shadow--one", True)
            ]
        ]
        [ text "Contents" ]


-- DRAWER topics
drawerTopics : Address Action -> Model -> Html
drawerTopics address model =
    let
        topicSet = List.map (topic address) model.topics
    in
        div
            [ classList
                [ ( "flex-set", True )
                , ( "flex--column", True )
                , ( "topics", True)
                ]
            ]
            topicSet


-- CONTENT

content: Model -> Html
content model =
    let
        home = "/"
    in
        if model.resource == home then initialContent model
        else page model


initialContent : Model -> Html
initialContent model =
    div
        [ classList
            [ ( "content", True )
            , ( "main", True )
            , ( "flex-set", True )
            , ( "flex--column", True )
            ]
        ]
        [ hero
        , cards
        , navigation model
    ]


page : Model -> Html
page model =
    let
        markup = model.content
    in
        div
        [ classList
            [ ( "content", True )
            , ( "page", True )
            ]
        ]
        [ markup
        , navigation model ]


-- NAVIGATION

navigation : Model -> Html
navigation model =
    let
        showNext = model.showNext
        showPrev = model.showPrev
    in
        div []
            [ button
                [ classList
                    [ ( "back", True)
                    , ( "elm-orange--bg", True)
                    , ( "fab", True)
                    , ( "hidden", not ( showPrev )  )
                    , ( "white", True)
                    ]
                ] []
            , button
                [ classList
                    [ ( "elm-orange--bg", True)
                    , ( "fab", True)
                    , ( "forward", True)
                    , ( "hidden", not ( showNext ) )
                    , ( "white", True)
                    ]
                ] []
        ]


view : Address Action -> Model -> Html
view address model =
    appContainer address model

-- EFFECTS

-- For a given resource, acquire the topic
-- content and then return it as an Effect Action
getTopic : String -> Effects Action
getTopic resource =
    Http.getString resource
        |> Task.toMaybe
        |> Task.map LoadTopic
        |> Effects.task

