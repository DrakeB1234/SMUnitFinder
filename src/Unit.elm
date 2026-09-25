module Unit exposing
    ( Features(..)
    , Unit
    , available
    , decoder
    , features
    , id
    , lengthFeet
    , monthlyRateCents
    , name
    , promo
    , squareFeet
    , widthFeet
    )

{-| A single storage unit.

`Unit` is an opaque type. Code outside this module can't see or build the
record inside it. It can only use `decoder` to create one and the functions
below to read from one. That means if the JSON changes shape later, this is
the only file that has to change.

TASK 2 lives here. See the README.

-}

import Json.Decode as Decode exposing (Decoder)


type Unit
    = Unit Internals


type Features
    = ClimateControlled
    | Elevator
    | DriveUp
    | GroundFloor
    | WineStorage
    | Unknown String


type alias Internals =
    { id : String
    , name : String
    , widthFeet : Int
    , lengthFeet : Int
    , monthlyRateCents : Int
    , available : Bool
    , promo : Maybe String
    , features : List Features
    }



-- DECODING


decoder : Decoder Unit
decoder =
    Decode.map Unit
        (Decode.map8 Internals
            (Decode.field "id" Decode.string)
            (Decode.field "name" Decode.string)
            (Decode.at [ "size", "width" ] Decode.int)
            (Decode.at [ "size", "length" ] Decode.int)
            (Decode.field "monthlyRateCents" Decode.int)
            (Decode.field "available" Decode.bool)
            (Decode.field "promo" (Decode.nullable Decode.string))
            (Decode.field "features" (Decode.list featureDecoder))
        )


featureDecoder : Decoder Features
featureDecoder =
    Decode.string
        |> Decode.andThen
            (\str ->
                case str of
                    "climate-controlled" ->
                        Decode.succeed ClimateControlled

                    "elevator" ->
                        Decode.succeed Elevator

                    "drive-up" ->
                        Decode.succeed DriveUp

                    "ground-floor" ->
                        Decode.succeed GroundFloor

                    "wine-storage" ->
                        Decode.succeed WineStorage

                    unrecognizedString ->
                        Decode.succeed (Unknown unrecognizedString)
            )



-- READING


id : Unit -> String
id (Unit unit) =
    unit.id


name : Unit -> String
name (Unit unit) =
    unit.name


widthFeet : Unit -> Int
widthFeet (Unit unit) =
    unit.widthFeet


lengthFeet : Unit -> Int
lengthFeet (Unit unit) =
    unit.lengthFeet


squareFeet : Unit -> Int
squareFeet (Unit unit) =
    unit.widthFeet * unit.lengthFeet


monthlyRateCents : Unit -> Int
monthlyRateCents (Unit unit) =
    unit.monthlyRateCents


available : Unit -> Bool
available (Unit unit) =
    unit.available


promo : Unit -> Maybe String
promo (Unit unit) =
    unit.promo


features : Unit -> List Features
features (Unit unit) =
    unit.features
