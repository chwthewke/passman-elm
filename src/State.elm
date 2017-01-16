module State exposing (init, update)

import Debug exposing (crash)
import Monocle.Lens exposing (Lens)
import Types exposing (..)
import Form.State as Form
import Form.Types as Form
import Generators.State as Generators
import Generators.Types as Generators
import Common.Tuple as Tuple
import Common.Updates as Updates


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
update msg =
    case msg of
        FormMsg fm ->
            Updates.fold
                [ liftForm Form.update fm
                , liftGenerators (Updates.foreignUpdate Generators.updateForm Generators.update) ( fm, crash "TODO" )
                ]

        GeneratorsMsg gm ->
            liftGenerators Generators.update gm


liftForm :
    (i -> Form.Model -> ( Form.Model, Cmd Form.Msg ))
    -> i
    -> Model
    -> ( Model, Cmd Msg )
liftForm =
    Updates.updatePart formModel FormMsg


liftGenerators :
    (i -> Generators.Model -> ( Generators.Model, Cmd Generators.Msg ))
    -> i
    -> Model
    -> ( Model, Cmd Msg )
liftGenerators =
    Updates.updatePart generatorsModel GeneratorsMsg



--updateGeneratorsFromForm : Updates.IxUpdate ( Form.Msg, Form.Model ) Generators.Model Generators.Msg
--updateGeneratorsFromForm =
--    Updates.foreignUpdate Generators.updateForm Generators.update
--updateForm : Form.Msg -> Model -> ( Model, Cmd Msg )
--updateForm =
--    liftForm Form.update
--updateGenerators : Generators.Msg -> Model -> ( Model, Cmd Msg )
--updateGenerators =
--    liftGenerators Generators.update
--( Form.Msg, Form.Model ) -> Model -> ( Model, Cmd Msg )
--updateGenerators_ : Updates.IxUpdate ( Form.Msg, Form.Model ) Model Msg
--updateGenerators_ =
--    Updates.updatePart generatorsModel GeneratorsMsg <|
--        Updates.foreignUpdate Generators.updateForm Generators.update
