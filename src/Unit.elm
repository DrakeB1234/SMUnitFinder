module Unit exposing
    ( Unit
    , decoder
    , id
    , lengthFeet
    , name
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


type alias Internals =
    { id : String
    , name : String
    , widthFeet : Int
    , lengthFeet : Int
    }



-- DECODING


decoder : Decoder Unit
decoder =
    Decode.map Unit
        (Decode.map4 Internals
            (Decode.field "id" Decode.string)
            (Decode.field "name" Decode.string)
            (Decode.at [ "size", "width" ] Decode.int)
            (Decode.at [ "size", "length" ] Decode.int)
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
