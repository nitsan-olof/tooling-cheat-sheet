module Main exposing (..)

import Browser
import Html exposing (Html, a, button, div, h1, input, pre, span, text)
import Html.Attributes as Attr exposing (class, placeholder, size, style, target, value)
import Html.Events exposing (onClick, onInput)
import Json.Encode as Encode
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
    , katas : List Kata
    }


type Model
    = KataApp SearchPageData AppState


type alias Kata =
    { url : String
    , tags : Set String
    , title : String
    }


init : Model
init =
    KataApp
        { searchBarContent = ""
        , activeTags = Set.empty -- |> Set.insert "C" |> Set.insert "Delphi"
        }
        { loggedIn = False
        , katas =
            [ { url = "https://github.com/emilybache/GildedRose-Refactoring-Kata"
              , tags = Set.fromList [ "C", "R", "Smalltalk", "Java", "Delphi" ]
              , title = "Gilded Rose"
              }
            , { url = "https://github.com/emilybache/RPG-Combat-Approval-Kata"
              , tags = Set.fromList [ "Java", "Approvals" ]
              , title = "RPG Combat"
              }
            , { url = "https://github.com/objarni/TestDataBuilderKata"
              , tags = Set.fromList [ "C" ]
              , title = "Channel - Test Data Builder in C"
              }
            , { url = "https://github.com/objarni/AlarmClockKata"
              , tags = Set.fromList [ "C" ]
              , title = "Alarm Clock (aka Timer Expiry)"
              }
            , { url = "https://github.com/objarni/Tennis-Refactoring-Kata"
              , tags = Set.fromList [ "C++", "C", "Go", "Java", "Groovy", "C#" ]
              , title = "Tennis Score"
              }
            ]
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
                    List.concat (List.map (\kata -> Set.toList kata.tags) appState.katas)

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
            List.filter shouldShow appState.katas

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
            case List.head appState.katas of
                Nothing ->
                    "{}"

                Just kata ->
                    Encode.encode 4 (katasJSON appState.katas)
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
            [ text kata.title ]
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
