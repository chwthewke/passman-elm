module Common.Tuple exposing (bimap)


bimap : (a -> c) -> (b -> d) -> ( a, b ) -> ( c, d )
bimap f g ( a, b ) =
    ( f a, g b )
