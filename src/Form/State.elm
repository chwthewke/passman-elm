module Form.State exposing (init, update)

import Char
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

        SubmitForm ->
            \model -> ( model, Maybe.withDefault Cmd.none (Maybe.map (\_ -> Cmd.none) (validateForm model)) )


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


submitForm : Model -> ( Model, Cmd Msg )
submitForm model =
    ( model
      -- replace the first Cmd.none with message to generators
    , Maybe.withDefault Cmd.none << Maybe.map (always Cmd.none) <| (validateForm model)
    )


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
            List.filterMap (identity)
                [ notBlank "name must not be blank" key
                , notBlank "master password must not be blank" masterPassword
                , posInt "variant must be positive" variant
                ]
    in
        case errs of
            [] ->
                Maybe.Nothing

            h :: t ->
                Just << capitalize <| List.foldl (\s r -> s ++ ", " ++ r) h t
