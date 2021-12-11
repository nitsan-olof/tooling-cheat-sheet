module Main exposing (..)

import Browser
import Html exposing (Html, button, div, h1, input, span, text)
import Html.Attributes exposing (placeholder, value)
import Html.Events exposing (onClick, onInput)


main =
    Browser.sandbox { init = init, update = update, view = view }


type alias Model =
    { value : Int
    , searchBarContent : String
    }


init : Model
init =
    { value = 10, searchBarContent = "" }


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
    in
    div []
        [ searchBar
        , tags
        , button
            [ onClick Decrement ]
            [ text "-" ]
        , h1 [] [ text (String.fromInt model.value) ]
        , button [ onClick Increment ] [ text "+" ]
        ]
