module Main exposing (..)

import Browser
import Html exposing (Html, a, button, div, input, span, text)
import Html.Attributes as Attr exposing (value)
import Html.Events exposing (onClick, onInput)
import Json.Encode as Encode
import KataDb exposing (kataList)
import Set exposing (..)


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


type alias SearchPageData =
    { searchBarContent : String
    , activeTags : Set String
    }


type alias AppState =
    { loggedIn : Bool
    , kataList : List Kata
    }


type Model
    = KataApp SearchPageData AppState


type alias Kata =
    { url : String
    , tags : Set String
    , title : String
    , commandLine : String
    }


init : Model
init =
    KataApp
        { searchBarContent = ""
        , activeTags = Set.empty -- |> Set.insert "C" |> Set.insert "Delphi"
        }
        { loggedIn = False
        , kataList =
            kataList
        }


type Msg
    = SearchBarChange String
    | ActivateTag String
    | DeactivateTag String
    | LogIn
    | LogOut


update : Msg -> Model -> Model
update msg (KataApp pageData appState) =
    case msg of
        SearchBarChange s ->
            KataApp { pageData | searchBarContent = s } appState

        ActivateTag tag ->
            KataApp { pageData | activeTags = Set.insert tag pageData.activeTags } appState

        DeactivateTag tag ->
            KataApp { pageData | activeTags = Set.remove tag pageData.activeTags } appState

        LogIn ->
            KataApp pageData { appState | loggedIn = True }

        LogOut ->
            KataApp pageData { appState | loggedIn = False }


view : Model -> Html Msg
view (KataApp pageData appState) =
    let
        searchBar =
            div []
                [ input
                    [ Attr.placeholder "general search (not working yet!)"
                    , value pageData.searchBarContent
                    , onInput SearchBarChange
                    , Attr.size 60
                    ]
                    []
                , button [] [ text "Search" ]
                ]

        allTags =
            let
                accumulatedTags =
                    List.concat (List.map (\kata -> Set.toList kata.tags) appState.kataList)

                uniqueTags =
                    Set.fromList accumulatedTags
            in
            Set.toList
                uniqueTags

        tags =
            div []
                [ text "Filter by tag"
                , span [] (List.map (\tag -> viewTag tag pageData.activeTags) allTags)
                ]

        shouldShow : Kata -> Bool
        shouldShow kata =
            let
                kataTags =
                    kata.tags
            in
            Set.isEmpty (Set.diff pageData.activeTags kataTags)

        visibleKatas =
            List.sortBy .title (List.filter shouldShow appState.kataList)

        katasList =
            div [] (List.map (viewKata appState.loggedIn) visibleKatas)

        userStatus =
            let
                ( txt, msg ) =
                    if appState.loggedIn then
                        ( "Log out", LogOut )

                    else
                        ( "Log in", LogIn )
            in
            a [ onClick msg ] [ text txt ]

        jsonString =
            case List.head appState.kataList of
                Nothing ->
                    "{}"

                Just kata ->
                    Encode.encode 4 (katasJSON appState.kataList)
    in
    div []
        [ --userStatus
          --, searchBar
          tags
        , katasList

        --, pre [ class "monospace" ] [ text jsonString ]
        ]


viewTag : String -> Set String -> Html Msg
viewTag tag activeTags =
    if Set.member tag activeTags then
        viewMarkedTag tag

    else
        viewUnmarkedTag tag


viewUnmarkedTag : String -> Html Msg
viewUnmarkedTag tag =
    span [ Attr.class "tag", onClick (ActivateTag tag) ] [ text tag ]


viewMarkedTag tag =
    span [ Attr.class "tag highlight", onClick (DeactivateTag tag) ] [ text tag ]


viewKata loggedIn kata =
    div [ Attr.class "kata" ]
        [ text
            (if loggedIn then
                "🖌️ "

             else
                ""
            )
        , a
            [ Attr.href kata.url
            , Attr.target "_blank"
            , Attr.class "kata-title"
            ]
            [ text (kata.title ++ " "), text (" " ++ kata.commandLine) ]
        , span [] (List.map viewUnmarkedTag (Set.toList kata.tags))
        ]



-- JSON


katasJSON : List Kata -> Encode.Value
katasJSON katas =
    Encode.list kataJSON katas


kataJSON : Kata -> Encode.Value
kataJSON kata =
    Encode.object
        [ ( "url", Encode.string kata.url )
        , ( "title", Encode.string kata.title )
        , ( "tags", Encode.set (\tag -> Encode.string tag) kata.tags )
        ]
