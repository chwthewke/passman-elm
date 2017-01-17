module Generators.View exposing (root)

import Dict exposing (Dict)
import Html exposing (Html)
import Html.Attributes as Attr
import Html.Events as Evt
import Common.Views exposing (..)
import Generators.Types exposing (..)


root : Model -> Html Msg
root model =
    Html.div []
        [ includeLegacyControl model.includeLegacy
        , generatorsView model.passwords model.generators
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
        , Html.span [] [ Html.text <| Maybe.withDefault "" password ]
        ]



-- TODO include derived passwords


generatorsView passwordsById generators =
    Html.div [] <| List.map (uncurry generatorView << generatorWithPassword passwordsById) generators


generatorWithPassword : Dict String String -> Generator -> ( Generator, Maybe String )
generatorWithPassword passwordsById generator =
    ( generator, Dict.get generator.id passwordsById )
