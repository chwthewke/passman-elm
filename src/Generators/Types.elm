module Generators.Types exposing (..)

import Dict exposing (Dict)
import Http
import Form.Types as Form


type alias Model =
    { generators : List Generator
    , includeLegacy : Bool
    , passwords : Dict String String
    }


type alias Generator =
    { name : String
    , id : String
    , legacy : Bool
    }


type alias PasswordResponse =
    List DerivedPassword


type alias DerivedPassword =
    { generatorId : String
    , value : String
    }


type Msg
    = UpdateGenerators (List Generator)
    | ApiError Http.Error
      -- TODO show? also, top-level and/or common type
    | SetIncludeLegacy Bool
    | FormSubmit Form.Model
    | UpdatePasswords PasswordResponse
