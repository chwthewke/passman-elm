module View exposing (root)

import Html exposing (Html)

import Form.View as Form
import Generators.View as Generators
import Types exposing (..)

root : Model -> Html Msg
root {form, generators} =
    Html.div [] 
        [ Html.map FormMsg <| Form.root form
        , Html.map GeneratorsMsg <| Generators.root generators 
        ]
