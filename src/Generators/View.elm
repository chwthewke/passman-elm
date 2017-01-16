module Generators.View exposing (root)

import Html exposing (Html)
import Html.Attributes as Attr
import Html.Events as Evt
import Common.Views exposing (..)
import Generators.Types exposing (..)


root : Model -> Html Msg
root model =
    Html.div []
        [ includeLegacyControl model.includeLegacy
        , generatorsView model.generators
        ]


includeLegacyControl includeLegacy =
    field "Include legacy generators" <|
        Html.input
            [ Attr.type_ "checkbox"
            , Attr.checked includeLegacy
            , Evt.onCheck SetIncludeLegacy
            ]
            []


generatorView generator password =
    Html.div []
        [ Html.span [] [ Html.text generator.name ]
        , Html.span [] [ Html.text "" ]
        ]



-- TODO include derived passwords


generatorsView generators =
    Html.div [] <| List.map (\g -> generatorView g "") generators
