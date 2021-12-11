module Main exposing (..)

import Browser
import Html exposing (Html, button, div, h1, input, span, text)
import Html.Attributes exposing (placeholder, value)
import Html.Events exposing (onClick, onInput)


main =
    Browser.sandbox { init = init, update = update, view = view }


type alias Model =
    Int


init : Model
init =
    10


type Msg
    = Increment
    | Decrement
    | SearchBarChange String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            model + 1

        Decrement ->
            model - 1

        SearchBarChange s ->
            model


view : Model -> Html Msg
view model =
    let
        searchBar =
            div []
                [ text "Search bar"
                , input [ placeholder "Search for kata", value "", onInput SearchBarChange ] []
                ]

        tags =
            div [] [ text "Known tags" ]
    in
    div []
        [ searchBar
        , tags
        , button
            [ onClick Decrement ]
            [ text "Inc" ]
        , h1 [] [ text (String.fromInt model) ]
        , button [ onClick Increment ] [ text "Dec" ]
        ]
