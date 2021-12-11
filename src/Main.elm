module Main exposing (..)

import Browser
import Html exposing (Html, a, button, div, h1, input, span, text)
import Html.Attributes exposing (class, href, placeholder, style, value)
import Html.Events exposing (onClick, onInput)


main =
    Browser.sandbox { init = init, update = update, view = view }


type alias Model =
    { value : Int
    , searchBarContent : String
    , katas : List Kata
    }


type alias Kata =
    { url : String
    , tags : List String
    , title : String
    }


init : Model
init =
    { value = 10
    , searchBarContent = ""
    , katas =
        [ { url = "https://github.com/emilybache/GildedRose-Refactoring-Kata"
          , tags = [ "C", "R", "Smalltalk", "Java", "Delphi" ]
          , title = "Gilded Rose"
          }
        , { url = "https://github.com/emilybache/RPG-Combat-Approval-Kata"
          , tags = [ "Java", "Approvals" ]
          , title = "RPG Combat"
          }
        ]
    }


type Msg
    = Increment
    | Decrement
    | SearchBarChange String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            { model | value = model.value + 1 }

        Decrement ->
            { model | value = model.value - 1 }

        SearchBarChange s ->
            { model | searchBarContent = s }


view : Model -> Html Msg
view model =
    let
        searchBar =
            div []
                [ text "Search bar"
                , input
                    [ placeholder "Search for kata"
                    , value model.searchBarContent
                    , onInput SearchBarChange
                    ]
                    []
                ]

        tags =
            div [] [ text "Known tags" ]

        katasList =
            div [] (List.map viewKata model.katas)
    in
    div []
        [ searchBar
        , tags
        , button
            [ onClick Decrement ]
            [ text "-" ]
        , h1 [] [ text (String.fromInt model.value) ]
        , button [ onClick Increment ] [ text "+" ]
        , katasList
        ]


viewTag tag =
    span [ class "tag" ] [ text tag ]


viewMarkedTag tag =
    span [ class "marked-tag" ] [ text tag ]


viewKata kata =
    div [ class "kata" ]
        [ a [ href kata.url, class "kata-title" ] [ text kata.title ]
        , div [] (List.map viewTag kata.tags)
        ]
