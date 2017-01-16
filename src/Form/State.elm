module Form.State exposing (init, update)

import Char
import Common.Updates as Updates
import Form.Types exposing (..)


init : ( Model, Cmd msg )
init =
    ( initRaw, Cmd.none ) |> updateValidation


initRaw : Model
initRaw =
    { key = ""
    , masterPassword = ""
    , variant = 1
    , validationError = Nothing
    }


update : Msg -> Model -> ( Model, Cmd msg )
update msg =
    updateSelf msg >> updateValidation


updateSelf msg =
    case msg of
        SetKey key ->
            setKey key

        SetMasterPassword masterPassword ->
            setMasterPassword masterPassword

        SetVariant variant ->
            setVariant variant

        Submit ->
            Updates.none


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


validateForm : Model -> Maybe String
validateForm { key, masterPassword, variant } =
    let
        notBlank msg s =
            if String.isEmpty s then
                Just msg
            else
                Nothing

        posInt msg n =
            if n <= 0 then
                Just msg
            else
                Nothing

        capitalize s =
            (String.map Char.toUpper <| String.left 1 s) ++ String.dropLeft 1 s

        errs =
            List.filterMap identity
                [ notBlank "name must not be blank" key
                , notBlank "master password must not be blank" masterPassword
                , posInt "variant must be positive" variant
                ]
    in
        case errs of
            [] ->
                Maybe.Nothing

            h :: t ->
                Just << capitalize <| List.foldl (\r s -> s ++ ", " ++ r) h t


updateValidation : ( Model, Cmd msg ) -> ( Model, Cmd msg )
updateValidation ( model, cmd ) =
    let
        validationError =
            validateForm model
    in
        ( { model | validationError = validationError }, cmd )
