module Main exposing (..)

import Browser
import Html exposing (Html, a, button, div, h1, input, span, text)
import Html.Attributes exposing (class, href, placeholder, style, value)
import Html.Events exposing (onClick, onInput)
import Set exposing (..)


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
        , { url = "https://github.com/objarni/TestDataBuilderKata"
          , tags = [ "C" ]
          , title = "Test data builder"
          }
        , { url = "https://github.com/objarni/AlarmClockKata"
          , tags = [ "C" ]
          , title = "Alarm Clock (aka Timer Expiry)"
          }
        , { url = "https://github.com/objarni/Tennis-Refactoring-Kata"
          , tags = [ "C++", "C", "Go", "Java", "Groovy", "C#" ]
          , title = "Tennis Score"
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

        allTags =
            let
                accumulatedTags =
                    List.concat (List.map (\kata -> kata.tags) model.katas)

                uniqueTags =
                    Set.fromList accumulatedTags
            in
            Set.toList uniqueTags

        tags =
            div []
                [ text "Known tags"
                , div [] (List.map viewTag allTags)
                ]

        katasList =
            div [] (List.map viewKata (List.sortBy (\kata -> kata.title) model.katas))
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
