module Generators.Rest exposing (queryEngineConfig, requestPasswords)

import Http
import Json.Decode as Decode
import Json.Encode as Encode
import Generators.Types exposing (..)


-- TODO Ugh


baseUrl : String
baseUrl =
    "http://localhost:7277/3.0/"



-- Response transform


onResult : Result Http.Error Msg -> Msg
onResult res =
    case res of
        Ok msg ->
            msg

        Err err ->
            ApiError err



-- CONFIG


configUrl : String
configUrl =
    baseUrl ++ "config"


queryEngineConfig : Bool -> Cmd Msg
queryEngineConfig includeLegacy =
    configRequest includeLegacy
        |> Http.send onResult



-- Request building


configRequest : Bool -> Http.Request Msg
configRequest includeLegacy =
    Http.post
        configUrl
        (configBody includeLegacy)
        (Decode.map UpdateGenerators decodeGenerators)



-- Encoding parameters


configBody : Bool -> Http.Body
configBody includeLegacy =
    Http.jsonBody <| Encode.object [ ( "includeLegacyGenerators", Encode.bool includeLegacy ) ]



-- Decoding the result


type alias PasswordGeneratorConfig =
    { id : String
    , family : String
    , charSpace : String
    , strength : String
    }


decodePasswordGeneratorConfig : Decode.Decoder PasswordGeneratorConfig
decodePasswordGeneratorConfig =
    Decode.map4 PasswordGeneratorConfig
        (Decode.field "id" Decode.string)
        (Decode.field "family" Decode.string)
        (Decode.field "symbols" Decode.string)
        (Decode.field "strength" Decode.string)


toGenerator : PasswordGeneratorConfig -> Generator
toGenerator { id, family, charSpace, strength } =
    { id = id
    , name = charSpace ++ " (" ++ family ++ ", " ++ strength ++ ")"
    , legacy = strength /= "2017"
    }


decodeGenerators : Decode.Decoder (List Generator)
decodeGenerators =
    Decode.list (decodePasswordGeneratorConfig |> Decode.map toGenerator)



-- PASSWORDS


type alias PasswordRequest =
    { key : String
    , masterPassword : String
    , variant : Int
    , includeLegacyGenerators : Bool
    }


encodePasswordRequest : PasswordRequest -> Encode.Value
encodePasswordRequest pr =
    Encode.object
        [ ( "key", Encode.string pr.key )
        , ( "masterPassword", Encode.string pr.masterPassword )
        , ( "variant", Encode.int pr.variant )
        , ( "includeLegacyGenerators", Encode.bool pr.includeLegacyGenerators )
        ]


passwordRequestBody : PasswordRequest -> Http.Body
passwordRequestBody =
    Http.jsonBody << encodePasswordRequest


decodePasswordResponse : Decode.Decoder PasswordResponse
decodePasswordResponse =
    Decode.list <|
        Decode.map2
            DerivedPassword
            (Decode.field "generatorId" Decode.string)
            (Decode.field "derivedPassword" Decode.string)


passwordUrl : String
passwordUrl =
    baseUrl ++ "password"


passwordRequest : String -> String -> Int -> Bool -> Http.Request Msg
passwordRequest key masterPassword variant includeLegacyGenerators =
    Http.post
        passwordUrl
        (passwordRequestBody <| PasswordRequest key masterPassword variant includeLegacyGenerators)
        (Decode.map UpdatePasswords decodePasswordResponse)


requestPasswords : String -> String -> Int -> Bool -> Cmd Msg
requestPasswords key masterPassword variant includeLegacyGenerators =
    passwordRequest key masterPassword variant includeLegacyGenerators
        |> Http.send onResult
