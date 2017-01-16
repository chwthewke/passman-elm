module Generators.State exposing (init, update)

import Debug
import Common.Updates as Updates
import Form.Types as Form
import Generators.Types exposing (..)
import Generators.Rest exposing (..)


init : ( Model, Cmd Msg )
init =
    initWithLegacy False


initWithLegacy legacy =
    ( { generators = [], includeLegacy = legacy }, queryEngineConfig legacy )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg =
    case msg of
        UpdateGenerators generators ->
            setGenerators generators

        ApiError err ->
            onApiError err

        SetIncludeLegacy includeLegacy ->
            setIncludeLegacy includeLegacy


setGenerators generators model =
    ( { model | generators = generators }, Cmd.none )


onApiError err model =
    Debug.log ("Api error: " ++ toString err) |> always ( model, Cmd.none )


setIncludeLegacy includeLegacy model =
    ( { model | includeLegacy = includeLegacy }, queryEngineConfig includeLegacy )


updateEx : ( Form.Msg, Form.Model ) -> Model -> ( Model, Cmd Msg )
updateEx ( fmsg, _ ) =
    case fmsg of
        Form.Submit ->
            Updates.none

        _ ->
            Updates.none
