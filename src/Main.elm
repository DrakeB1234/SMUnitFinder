module Main exposing (main)

import Browser
import Html exposing (Html, button, div, h1, h2, li, main_, p, small, span, text, ul)
import Html.Attributes as Attr
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode
import Style
import Unit exposing (Features(..), Unit, available)


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }



-- MODEL


{-| TASK 1: This model can hold states that should never happen.

Nothing stops `isLoading = True` and `error = Just ...` from being true at
the same time. Replace these three fields with a type where only the real
states can exist. See the README for more.

-}
type UnitState
    = IsLoading
    | Error Http.Error
    | Success (List Unit)


type alias Model =
    { state : UnitState
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { state = IsLoading
      }
    , fetchUnits
    )


fetchUnits : Cmd Msg
fetchUnits =
    Http.get
        { url = "/data/units.json"
        , expect = Http.expectJson GotUnits (Decode.field "units" (Decode.list Unit.decoder))
        }



-- UPDATE


type Msg
    = GotUnits (Result Http.Error (List Unit))
    | Retry


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotUnits (Ok units) ->
            ( { model | state = Success units }, Cmd.none )

        GotUnits (Err error) ->
            ( { model | state = Error error }, Cmd.none )

        Retry ->
            ( { model | state = IsLoading }, fetchUnits )



-- VIEW


view : Model -> Html Msg
view model =
    main_ [ Attr.class "page" ]
        [ Style.stylesheet
        , h1 [] [ text "Find a storage unit" ]
        , viewBody model
        ]


viewBody : Model -> Html Msg
viewBody model =
    case model.state of
        IsLoading ->
            p [] [ text "Loading..." ]

        Error error ->
            div []
                [ p [] [ text (viewErrorMessage error) ]
                , button [ onClick Retry ] [ text "Try Again!" ]
                ]

        Success units ->
            ul [ Attr.class "unit-list" ] (List.map viewUnit units)


viewErrorMessage : Http.Error -> String
viewErrorMessage error =
    case error of
        Http.BadStatus status ->
            "Bad Status: The server returned an error: Status (" ++ String.fromInt status ++ ")"

        Http.Timeout ->
            "Timeout: The server took to long to respond."

        Http.NetworkError ->
            "Network Error: Failed to reach the server. Is there a working internet connection?"

        _ ->
            "Error: Something went wrong on our end."


{-| TASK 3: Make this card useful. See the README.
-}
viewUnit : Unit -> Html Msg
viewUnit unit =
    li [ Attr.class "unit-card" ]
        [ h2 [] [ text ("Unit " ++ Unit.name unit) ]
        , viewUnitSize (Unit.widthFeet unit) (Unit.lengthFeet unit) (Unit.squareFeet unit)
        , viewUnitFeatures (Unit.features unit)
        , viewUnitPriceAvailable unit
        ]


viewUnitPriceAvailable : Unit -> Html Msg
viewUnitPriceAvailable unit =
    if Unit.available unit then
        div []
            [ viewUnitPromo (Unit.promo unit)
            , span [] [ text (unitMonthlyRateCents (Unit.monthlyRateCents unit)) ]
            ]

    else
        div []
            [ text "SOLD OUT"
            ]


viewUnitSize : Int -> Int -> Int -> Html Msg
viewUnitSize widthFeet lengthFeet squareFeet =
    div []
        [ div []
            [ span [] [ text (String.fromInt widthFeet ++ "'") ]
            , small [] [ text "w" ]
            , span [] [ text "X" ]
            , span [] [ text (String.fromInt lengthFeet ++ "'") ]
            , small [] [ text "d" ]
            ]
        , div []
            [ text (String.fromInt squareFeet ++ " sq ft") ]
        ]


unitMonthlyRateCents : Int -> String
unitMonthlyRateCents cents =
    "$" ++ String.fromInt (cents // 100) ++ "/mo"


viewUnitPromo : Maybe String -> Html Msg
viewUnitPromo promo =
    case promo of
        Just value ->
            span [] [ text value ]

        Nothing ->
            text ""


viewUnitFeatures : List Features -> Html Msg
viewUnitFeatures features =
    ul []
        (List.map (\feature -> li [] [ text (featureToString feature) ]) features)


featureToString : Features -> String
featureToString feature =
    case feature of
        ClimateControlled ->
            "Climate Controlled"

        Elevator ->
            "Elevator Access"

        DriveUp ->
            "Drive-Up Access"

        GroundFloor ->
            "Ground Floor"

        WineStorage ->
            "Wine Storage"

        Unknown rawString ->
            ""
