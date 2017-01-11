module Types exposing (..)

import Form.Types as Form
import Generators.Types as Generators

-- TODO elm-monocle lenses for glue models?

type alias Model = 
    { form : Form.Model
    , generators: Generators.Model
    }

type Msg = FormMsg        Form.Msg
         | GeneratorsMsg  Generators.Msg
