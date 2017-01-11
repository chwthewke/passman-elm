module Generators.Types exposing (..)

import Http

type alias Model =
    { generators: List Generator
    , includeLegacy: Bool
    }

type alias Generator =
    { name: String
    , id: String
    , legacy: Bool
    }

type Msg = UpdateGenerators (List Generator)
         | ApiError Http.Error -- TODO show? also, top-level and/or common type
         | SetIncludeLegacy Bool

