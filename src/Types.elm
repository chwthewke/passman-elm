module Types exposing (..)

import Monocle.Lens exposing (Lens)
import Form.Types as Form
import Generators.Types as Generators


-- TODO elm-monocle lenses for glue models?


type alias Model =
    { form : Form.Model
    , generators : Generators.Model
    }


formModel : Lens Model Form.Model
formModel =
    Lens .form (\f m -> { m | form = f })


generatorsModel : Lens Model Generators.Model
generatorsModel =
    Lens .generators (\g m -> { m | generators = g })


type Msg
    = FormMsg Form.Msg
    | GeneratorsMsg Generators.Msg
