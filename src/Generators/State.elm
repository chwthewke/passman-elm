module Generators.State exposing (init, update)

import Debug
import Generators.Types exposing (..)
import Generators.Rest exposing (..)


init : ( Model, Cmd Msg )
init =
    let
        legacy =
            False
    in
        ( { generators = [], includeLegacy = legacy }, queryEngineConfig legacy )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateGenerators generators ->
            ( { model | generators = generators }, Cmd.none )

        ApiError err ->
            Debug.log ("Api error: " ++ toString err) ( model, Cmd.none )

        SetIncludeLegacy includeLegacy ->
            ( { model | includeLegacy = includeLegacy }, Cmd.none )



-- TODO update generators as needed
