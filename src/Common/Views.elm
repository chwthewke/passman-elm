module Common.Views exposing (field)

import Html exposing (Html)


field : String -> Html msg -> Html msg
field label input =
    Html.label [] [ Html.text label, input ]
