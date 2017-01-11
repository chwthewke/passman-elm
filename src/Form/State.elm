module Form.State exposing (init, update)

import Form.Types exposing (..)


init : ( Model, Cmd msg )
init =
    ( { key = "", masterPassword = "", variant = 1 }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd msg )
update msg =
    case msg of
        SetKey key ->
            setKey key

        SetMasterPassword masterPassword ->
            setMasterPassword masterPassword

        SetVariant variant ->
            setVariant variant


setKey : String -> Model -> ( Model, Cmd msg )
setKey key model =
    ( { model | key = key }, Cmd.none )


setMasterPassword : String -> Model -> ( Model, Cmd msg )
setMasterPassword masterPassword model =
    ( { model | masterPassword = masterPassword }, Cmd.none )


setVariant : String -> Model -> ( Model, Cmd msg )
setVariant variant model =
    let
        model1 =
            case String.toInt variant of
                Ok v ->
                    { model | variant = v }

                _ ->
                    model
    in
        ( model1, Cmd.none )
