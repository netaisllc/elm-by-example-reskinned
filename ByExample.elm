module ByExample where

import Debug

import Anchor exposing ( anchor, anchors, AnchorModel )
import Cards exposing ( cards )
import Effects exposing ( Effects, Never )
import Hero exposing ( hero )
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Markdown
import Signal exposing ( Signal, Address )
import Topic exposing ( TopicModel, topics )
import Task


-- MODEL --

type alias Model =
    { anchors : List AnchorModel
    , content : Html
    , initDrawer : Bool
    , nextResource : String
    , prevResource : String
    , resource : String
    , showDrawer : Bool
    , showNext : Bool
    , showPrev : Bool
    , topics : List TopicModel
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
    , nextResource = "content/requirements.md"
    , prevResource = "content/2.md"
    , resource = "/"
    , showDrawer = False
    , showNext = True
    , showPrev = False
    , topics = topics
    }



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


saveCall : Model -> String -> Model
saveCall model resource =
    -- Store the requested resource and determine in-page navigation
    { model
        | resource <- resource
        , showPrev <- ( setPrevNavigation resource )
    }


setPrevNavigation : String -> Bool
setPrevNavigation resource =
    -- Never show PREV in-page nav link when the current page is
    -- the Home page
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
            , content address model
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

content : Address Action -> Model -> Html
content address model =
    let
        home = "/"
    in
        if model.resource == home then initialContent address model
        else page address model


initialContent : Address Action -> Model -> Html
initialContent address model =
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
        , navigation address model
    ]


page : Address Action -> Model -> Html
page address model =
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
        , navigation address model ]


-- NAVIGATION

navigation : Address Action -> Model -> Html
navigation address model =
    -- Render up to two in-page navigation links
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
                , onClick address ( CallTopic model.prevResource )
                ] []
            , button
                [ classList
                    [ ( "elm-orange--bg", True)
                    , ( "fab", True)
                    , ( "forward", True)
                    , ( "hidden", not ( showNext ) )
                    , ( "white", True)
                    ]
                , onClick address ( CallTopic model.nextResource )
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

