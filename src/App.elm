module App exposing (main)

import Html

import State
import View

main = Html.program
    { init = State.init
    , update = State.update
    , subscriptions = \_ -> Sub.none
    , view = View.root
    }