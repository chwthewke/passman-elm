module Common.Updates exposing (none, foldM)

import Tuple exposing (mapSecond)


none : a -> ( a, Cmd msg )
none model =
    ( model, Cmd.none )


foldM : List (a -> ( a, Cmd msg )) -> a -> ( a, Cmd msg )
foldM ups m =
    mapSecond Cmd.batch <| sequence ups m


sequence : List (a -> ( a, Cmd msg )) -> a -> ( a, List (Cmd msg) )
sequence ups m =
    case ups of
        [] ->
            ( m, [] )

        u :: us ->
            let
                ( m1, cmd ) =
                    u m
            in
                mapSecond ((::) cmd) (sequence us m1)
