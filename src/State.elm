module State exposing (init, update)

import Types exposing (..)
import Form.State as Form
import Generators.State as Generators


init : ( Model, Cmd Msg )
init =
    let
        ( formModel, formCmd ) =
            Form.init

        ( generatorsModel, generatorsCmd ) =
            Generators.init
    in
        ( { form = formModel, generators = generatorsModel }
        , Cmd.batch [ Cmd.map FormMsg formCmd, Cmd.map GeneratorsMsg generatorsCmd ]
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FormMsg fm ->
            let
                ( form, cmd ) =
                    Form.update fm model.form
            in
                ( { model | form = form }, Cmd.map FormMsg cmd )

        GeneratorsMsg gm ->
            let
                ( generators, cmd ) =
                    Generators.update gm model.generators
            in
                ( { model | generators = generators }, Cmd.map GeneratorsMsg cmd )



-- updateEx : Msg -> Model -> ( Model, Cmd Msg )
