module Common.Updates exposing (StateCmd, IxUpdate, Update, none, fold, updatePart, foreignUpdate)

import Monocle.Lens exposing (Lens)
import Tuple exposing (mapSecond)
import Common.Maybe exposing (..)
import Common.Tuple as Tuple


type alias StateCmd m o =
    m -> ( m, Cmd o )


type alias IxUpdate i m o =
    i -> StateCmd m o


type alias Update i m =
    IxUpdate i m i


none : StateCmd m o
none model =
    ( model, Cmd.none )


fold : List (StateCmd m o) -> StateCmd m o
fold ups m =
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


updatePart :
    Lens wholeModel partModel
    -> (partMsg -> wholeMsg)
    -> IxUpdate inputMsg partModel partMsg
    -> IxUpdate inputMsg wholeModel wholeMsg
updatePart lens liftMsg partUpdate msg model =
    model
        |> lens.get
        >> partUpdate msg
        >> Tuple.bimap (flip lens.set model) (Cmd.map liftMsg)


foreignUpdate : (i -> Maybe o) -> Update o m -> IxUpdate i m o
foreignUpdate select update input =
    foldMaybe (always none) update (select input)
