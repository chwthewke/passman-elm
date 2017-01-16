module Common.Maybe exposing (foldMaybe, isDefined)


foldMaybe : (() -> b) -> (a -> b) -> Maybe a -> b
foldMaybe d f m =
    case m of
        Just a ->
            f a

        Nothing ->
            d ()


isDefined : Maybe a -> Bool
isDefined =
    foldMaybe (always False) (always True)
