module Types exposing (..)

import Monocle.Lens exposing (Lens)
import Form.Types as Form
import Generators.Types as Generators
import Common.Updates exposing (Component, component)


-- TODO elm-monocle lenses for glue models?


type alias Model =
    { form : Form.Model
    , generators : Generators.Model
    }


formComponent : Component Model Msg Form.Model Form.Msg
formComponent =
    component .form (\f m -> { m | form = f }) FormMsg


generatorsComponent : Component Model Msg Generators.Model Generators.Msg
generatorsComponent =
    component .generators (\g m -> { m | generators = g }) GeneratorsMsg


type Msg
    = FormMsg Form.Msg
    | GeneratorsMsg Generators.Msg
