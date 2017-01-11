module Form.View exposing (root)

import Html exposing (Html)
import Html.Attributes as Attr
import Html.Events as Evt
import Form.Types exposing (..)


root : Model -> Html Msg
root model =
    Html.div [] [ header, form model ]


header : Html Msg
header =
    Html.h1 [] [ Html.text "Password manager" ]


form : Model -> Html Msg
form model =
    Html.div [] <|
        List.intersperse (Html.br [] [])
            [ field "Name" <| keyInput model.key
            , field "Master password" <| masterPasswordInput model.masterPassword
            , field "Variant" <| variantInput model.variant
            ]


field : String -> Html msg -> Html msg
field label input =
    Html.label [] [ Html.text label, input ]


keyInput : String -> Html Msg
keyInput key =
    let
        attrs =
            [ Attr.type_ "text"
            , Attr.value key
            , Evt.onInput SetKey
            ]
    in
        Html.input attrs []


masterPasswordInput : String -> Html Msg
masterPasswordInput masterPassword =
    let
        attrs =
            [ Attr.type_ "password"
            , Attr.value masterPassword
            , Evt.onInput SetMasterPassword
            ]
    in
        Html.input attrs []


variantInput : Int -> Html Msg
variantInput variant =
    let
        attrs =
            [ Attr.type_ "number"
            , Attr.defaultValue "1"
            , Attr.min "1"
            , Attr.value (toString variant)
            , Evt.onInput SetVariant
            ]
    in
        Html.input attrs []
