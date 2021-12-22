module Main exposing (..)

import Browser
import Html exposing (Html, a, button, div, h1, input, span, text)
import Html.Attributes as Attr exposing (class, placeholder, size, style, target, value)
import Html.Events exposing (onClick, onInput)
import Json.Encode as Encode
import Set exposing (..)


main =
    Browser.sandbox { init = init, update = update, view = view }


type alias MainPageContent =
    { searchBarContent : String
    , katas : List Kata
    , activeTags : Set String
    , loggedIn : Bool
    }


type Model
    = MainPage MainPageContent


type alias Kata =
    { url : String
    , tags : Set String
    , title : String
    }


init : Model
init =
    MainPage
        { searchBarContent = ""
        , loggedIn = False
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
        , activeTags = Set.empty -- |> Set.insert "C" |> Set.insert "Delphi"
        }


type Msg
    = SearchBarChange String
    | ActivateTag String
    | DeactivateTag String
    | LogIn
    | LogOut


update : Msg -> Model -> Model
update msg (MainPage model) =
    case msg of
        SearchBarChange s ->
            MainPage { model | searchBarContent = s }

        ActivateTag tag ->
            MainPage { model | activeTags = Set.insert tag model.activeTags }

        DeactivateTag tag ->
            MainPage { model | activeTags = Set.remove tag model.activeTags }

        LogIn ->
            MainPage { model | loggedIn = True }

        LogOut ->
            MainPage { model | loggedIn = False }


view : Model -> Html Msg
view (MainPage model) =
    let
        searchBar =
            div []
                [ input
                    [ Attr.placeholder "general search (not working yet!)"
                    , value model.searchBarContent
                    , onInput SearchBarChange
                    , Attr.size 60
                    ]
                    []
                , button [] [ text "Search" ]
                ]

        allTags =
            let
                accumulatedTags =
                    List.concat (List.map (\kata -> Set.toList kata.tags) model.katas)

                uniqueTags =
                    Set.fromList accumulatedTags
            in
            Set.toList
                uniqueTags

        tags =
            div []
                [ text "Filter by tag"
                , div [] (List.map (\tag -> viewTag tag model.activeTags) allTags)
                ]

        shouldShow : Kata -> Bool
        shouldShow kata =
            let
                kataTags =
                    kata.tags
            in
            Set.isEmpty (Set.diff model.activeTags kataTags)

        visibleKatas =
            List.filter shouldShow model.katas

        katasList =
            div [] (List.map (viewKata model.loggedIn) visibleKatas)

        userStatus =
            let
                ( txt, msg ) =
                    if model.loggedIn then
                        ( "Log out", LogOut )

                    else
                        ( "Log in", LogIn )
            in
            a [ onClick msg ] [ text txt ]

        jsonString =
            case List.head model.katas of
                Nothing ->
                    "{}"

                Just kata ->
                    Encode.encode 4 (kataJSON kata)
    in
    div []
        [ userStatus
        , searchBar
        , tags
        , katasList
        , div [ class "monospace" ] [ text jsonString ]
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


kataJSON : Kata -> Encode.Value
kataJSON kata =
    Encode.object
        [ ( "url", Encode.string kata.url )
        , ( "title", Encode.string kata.title )
        ]


tom : Encode.Value
tom =
    Encode.object
        [ ( "name", Encode.string "Tom" )
        , ( "age", Encode.int 42 )
        ]


json =
    Encode.encode 4 tom
