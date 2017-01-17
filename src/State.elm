module State exposing (init, update)

import Debug exposing (crash)
import Monocle.Lens exposing (Lens)
import Types exposing (..)
import Form.State as Form
import Form.Types as Form
import Generators.State as Generators
import Generators.Types as Generators
import Common.Tuple as Tuple
import Common.Updates as Updates exposing (updateComponent, updateCrossComponent, CrossComponent)


init : ( Model, Cmd Msg )
init =
    let
        ( formModel, formCmd ) =
            Form.init

        ( generatorsModel, generatorsCmd ) =
            Generators.init
    in
        ( Model formModel generatorsModel
        , Cmd.batch [ Cmd.map FormMsg formCmd, Cmd.map GeneratorsMsg generatorsCmd ]
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg =
    case msg of
        FormMsg fm ->
            Updates.fold
                [ updateComponent formComponent Form.update fm
                , updateCrossComponent formToGenerators Generators.update fm
                ]

        GeneratorsMsg gm ->
            updateComponent generatorsComponent Generators.update gm


formToGenerators =
    CrossComponent formComponent generatorsComponent Generators.formHook
