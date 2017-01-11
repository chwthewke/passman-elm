module Generators.Rest exposing (queryEngineConfig)

import Http
import Json.Decode as Decode
import Json.Encode as Encode

import Generators.Types exposing (..)

url : String
url = "http://localhost:7277/3.0/config" -- TODO Ugh

queryEngineConfig : Bool -> Cmd Msg
queryEngineConfig includeLegacy =
    request includeLegacy
        |> Http.send responseMessage

-- Request building

request : Bool -> Http.Request (List Generator)
request includeLegacy = 
    Http.post 
        url
        (requestPayload includeLegacy)
        decodeResponse


-- Encoding parameters

requestPayload : Bool -> Http.Body
requestPayload includeLegacy = 
    Http.jsonBody <| Encode.object [ ("includeLegacyGenerators", Encode.bool includeLegacy) ]

-- Response transform

responseMessage : Result Http.Error (List Generator) -> Msg
responseMessage res = case res of
    Ok generators -> UpdateGenerators generators
    Err err -> ApiError err

-- Decoding the result

type alias PasswordGeneratorConfig =
    { id: String
    , family: String
    , charSpace: String
    , strength: String
    }

decodePasswordGeneratorConfig : Decode.Decoder PasswordGeneratorConfig
decodePasswordGeneratorConfig = 
    Decode.map4 PasswordGeneratorConfig
        (Decode.field "id" Decode.string)
        (Decode.field "family" Decode.string)
        (Decode.field "symbols" Decode.string)
        (Decode.field "strength" Decode.string)

toGenerator : PasswordGeneratorConfig -> Generator
toGenerator {id, family, charSpace, strength} =
        { id = id 
        , name = charSpace ++ " (" ++ family ++ ", " ++ strength ++ ")"
        , legacy = strength /= "2017" }

decodeResponse : Decode.Decoder (List Generator)
decodeResponse = Decode.list (decodePasswordGeneratorConfig |> Decode.map toGenerator)
