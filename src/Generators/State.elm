module Generators.State exposing (init, update, formHook)

import Dict
import Common.Updates as Updates
import Form.Types as Form
import Generators.Types exposing (..)
import Generators.Rest exposing (..)


init : ( Model, Cmd Msg )
init =
    initWithLegacy False


initWithLegacy legacy =
    ( { generators = [], includeLegacy = legacy, passwords = Dict.empty }, queryEngineConfig legacy )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg =
    case msg of
        UpdateGenerators generators ->
            setGenerators generators

        ApiError err ->
            onApiError err

        SetIncludeLegacy includeLegacy ->
            setIncludeLegacy includeLegacy

        -- TODO
        FormSubmit form ->
            restRequestPasswords form.key form.masterPassword form.variant

        UpdatePasswords passwords ->
            updatePasswords passwords


formHook : Form.Model -> Form.Msg -> Maybe Msg
formHook fmod fmsg =
    case fmsg of
        Form.Submit ->
            Just <| FormSubmit fmod

        _ ->
            Nothing


setGenerators generators model =
    ( { model | generators = generators }, Cmd.none )


onApiError err model =
    Debug.log ("Api error: " ++ toString err) |> always ( model, Cmd.none )


setIncludeLegacy includeLegacy model =
    ( { model | includeLegacy = includeLegacy }, queryEngineConfig includeLegacy )


restRequestPasswords key masterPassword variant model =
    ( model, requestPasswords key masterPassword variant model.includeLegacy )


updatePasswords derivedPasswords model =
    let
        passwordsDict =
            Dict.fromList (List.map (\p -> ( p.generatorId, p.value )) derivedPasswords)
    in
        ( { model | passwords = passwordsDict }, Cmd.none )
