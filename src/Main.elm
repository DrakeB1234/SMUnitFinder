module Main exposing (main)

import Browser
import Html exposing (Html, button, div, h1, h2, input, label, li, main_, option, p, select, small, span, text, ul)
import Html.Attributes as Attr exposing (default)
import Html.Events exposing (onCheck, onClick, onInput)
import Http
import Json.Decode as Decode
import Style
import Unit exposing (Features(..), Unit)


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


type SizeFilter
    = AnySize
    | Small
    | Medium
    | Large


type UnitSort
    = Name
    | PriceLowToHigh
    | PriceHighToLow


type alias Model =
    { state : UnitState
    , sizeFilter : SizeFilter
    , climateOnly : Bool
    , unitSort : UnitSort
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { state = IsLoading
      , sizeFilter = AnySize
      , climateOnly = False
      , unitSort = Name
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
    | FilterSize SizeFilter
    | ToggleClimateFilter Bool
    | SortChanged UnitSort


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotUnits (Ok units) ->
            ( { model | state = Success units }, Cmd.none )

        GotUnits (Err error) ->
            ( { model | state = Error error }, Cmd.none )

        Retry ->
            ( { model | state = IsLoading }, fetchUnits )

        FilterSize filter ->
            ( { model | sizeFilter = filter }, Cmd.none )

        ToggleClimateFilter newBool ->
            ( { model | climateOnly = newBool }, Cmd.none )

        SortChanged sortType ->
            ( { model | unitSort = sortType }, Cmd.none )



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
            div []
                [ viewUnitFilter model
                , viewUnitSort
                , viewAmountOfUnits units (unitFilter model.sizeFilter model.climateOnly units)
                , ul [ Attr.class "unit-list" ] (List.map viewUnit (unitSort model.unitSort (unitFilter model.sizeFilter model.climateOnly units)))
                ]


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



-- Filter / Sort Unit Helpers


viewUnitFilter : Model -> Html Msg
viewUnitFilter model =
    div [ Attr.class "unit-filter" ]
        [ div [ Attr.class "unit-filter__title" ] [ text "STORAGE FILTER" ]
        , div [ Attr.class "unit-filter__checkboxes" ]
            [ div [ Attr.class "filter-checkbox__title" ] [ text "By Size" ]
            , div [ Attr.class "filter-checkbox" ]
                [ label []
                    [ input
                        [ Attr.type_ "checkbox"
                        , Attr.checked
                            (if model.sizeFilter == AnySize then
                                True

                             else
                                False
                            )
                        , onClick (FilterSize AnySize)
                        ]
                        []
                    , text "Any Size"
                    ]
                ]
            , div [ Attr.class "filter-checkbox" ]
                [ label []
                    [ input
                        [ Attr.type_ "checkbox"
                        , Attr.checked
                            (if model.sizeFilter == Small then
                                True

                             else
                                False
                            )
                        , onClick (FilterSize Small)
                        ]
                        []
                    , text "Small"
                    , span [ Attr.class "filter-checkbox__right-text" ] [ text "Under 50 sq ft" ]
                    ]
                ]
            , div [ Attr.class "filter-checkbox" ]
                [ label []
                    [ input
                        [ Attr.type_ "checkbox"
                        , Attr.checked
                            (if model.sizeFilter == Medium then
                                True

                             else
                                False
                            )
                        , onClick (FilterSize Medium)
                        ]
                        []
                    , text "Medium"
                    , span [ Attr.class "filter-checkbox__right-text" ] [ text "50 to 150 sq ft" ]
                    ]
                ]
            , div [ Attr.class "filter-checkbox" ]
                [ label []
                    [ input
                        [ Attr.type_ "checkbox"
                        , Attr.checked
                            (if model.sizeFilter == Large then
                                True

                             else
                                False
                            )
                        , onClick (FilterSize Large)
                        ]
                        []
                    , text "Large"
                    , span [ Attr.class "filter-checkbox__right-text" ] [ text "Over 150 sq ft" ]
                    ]
                ]
            ]
        , div [ Attr.class "unit-filter__checkboxes" ]
            [ div [ Attr.class "filter-checkbox__title" ] [ text "By Feature" ]
            , div [ Attr.class "filter-checkbox" ]
                [ label []
                    [ input
                        [ Attr.type_ "checkbox"
                        , Attr.checked model.climateOnly
                        , onCheck ToggleClimateFilter
                        ]
                        []
                    , text "Climate Controlled"
                    ]
                ]
            ]
        ]


viewUnitSort : Html Msg
viewUnitSort =
    div [ Attr.class "unit-sort" ]
        [ label []
            [ text "SORT BY"
            , select [ onInput handleUnitSortString ]
                [ option [ Attr.value "name" ] [ text "Name" ]
                , option [ Attr.value "price-low-to-high" ] [ text "Price: low to high" ]
                , option [ Attr.value "price-high-to-low" ] [ text "Price: high to low" ]
                ]
            ]
        ]


handleUnitSortString : String -> Msg
handleUnitSortString string =
    case string of
        "name" ->
            SortChanged Name

        "price-low-to-high" ->
            SortChanged PriceLowToHigh

        "price-high-to-low" ->
            SortChanged PriceHighToLow

        _ ->
            SortChanged Name


unitFilter : SizeFilter -> Bool -> List Unit -> List Unit
unitFilter sizeFilter climateOnly units =
    units
        |> List.filter
            (\unit ->
                if climateOnly then
                    List.member ClimateControlled (Unit.features unit)

                else
                    True
            )
        |> List.filter
            (\unit ->
                case sizeFilter of
                    AnySize ->
                        True

                    Small ->
                        if Unit.squareFeet unit < 50 then
                            True

                        else
                            False

                    Medium ->
                        if Unit.squareFeet unit >= 50 && Unit.squareFeet unit <= 150 then
                            True

                        else
                            False

                    Large ->
                        if Unit.squareFeet unit > 150 then
                            True

                        else
                            False
            )


unitSort : UnitSort -> List Unit -> List Unit
unitSort sortType units =
    case sortType of
        Name ->
            List.sortBy (\unit -> Unit.name unit) units

        PriceLowToHigh ->
            List.sortBy (\unit -> Unit.monthlyRateCents unit) units

        PriceHighToLow ->
            units
                |> List.sortBy (\unit -> Unit.monthlyRateCents unit)
                |> List.reverse


viewAmountOfUnits : List Unit -> List Unit -> Html Msg
viewAmountOfUnits totalUnits filteredUnits =
    div [ Attr.class "unit-shown" ]
        [ span [] [ text ("Showing " ++ String.fromInt (List.length filteredUnits) ++ " of " ++ String.fromInt (List.length totalUnits) ++ " units.") ]
        ]


{-| TASK 3: Make this card useful. See the README.
-}



-- Unit Components


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
    div [ Attr.class "unit-size" ]
        [ div [ Attr.class "unit-dimensions" ]
            [ span [ Attr.class "unit-dimensions__number" ] [ text (String.fromInt widthFeet ++ "'") ]
            , small [] [ text "w" ]
            , span [ Attr.class "unit-dimensions__spacer" ] [ text "X" ]
            , span [ Attr.class "unit-dimensions__number" ] [ text (String.fromInt lengthFeet ++ "'") ]
            , small [] [ text "d" ]
            ]
        , div [ Attr.class "unit-size__squarefeet" ]
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
