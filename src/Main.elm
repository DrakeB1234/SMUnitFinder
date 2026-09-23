module Main exposing (main)

import Browser
import Html exposing (Html)
import Html.Attributes as Attr
import Http
import Json.Decode as Decode
import Style
import Unit exposing (Unit)


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
type alias Model =
    { isLoading : Bool
    , error : Maybe Http.Error
    , units : List Unit
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { isLoading = True
      , error = Nothing
      , units = []
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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotUnits (Ok units) ->
            ( { model | isLoading = False, units = units }, Cmd.none )

        GotUnits (Err error) ->
            ( { model | isLoading = False, error = Just error }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    Html.main_ [ Attr.class "page" ]
        [ Style.stylesheet
        , Html.h1 [] [ Html.text "Find a storage unit" ]
        , viewBody model
        ]


viewBody : Model -> Html Msg
viewBody model =
    if model.isLoading then
        Html.p [] [ Html.text "Loading..." ]

    else
        case model.error of
            Just _ ->
                Html.p [] [ Html.text "Something went wrong." ]

            Nothing ->
                Html.ul [ Attr.class "unit-list" ] (List.map viewUnit model.units)


{-| TASK 3: Make this card useful. See the README.
-}
viewUnit : Unit -> Html Msg
viewUnit unit =
    Html.li [ Attr.class "unit-card" ]
        [ Html.h2 [] [ Html.text ("Unit " ++ Unit.name unit) ]
        , Html.p []
            [ Html.text
                (String.fromInt (Unit.widthFeet unit)
                    ++ " x "
                    ++ String.fromInt (Unit.lengthFeet unit)
                )
            ]
        ]
