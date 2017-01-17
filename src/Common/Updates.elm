module Common.Updates
    exposing
        ( Component
        , CrossComponent
        , StateCmd
        , IxUpdate
        , Update
        , none
        , fold
        , component
        , updateComponent
        , updateCrossComponent
        , updateCross
        )

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


type alias Component s sm a am =
    { lens : Lens s a
    , lift : am -> sm
    }


component : (s -> a) -> (a -> s -> s) -> (am -> sm) -> Component s sm a am
component get set lift =
    Component (Lens get set) lift


updateComponent :
    Component s sm a am
    -> IxUpdate i a am
    -> IxUpdate i s sm
updateComponent { lens, lift } up i m =
    m
        |> lens.get
        >> up i
        >> Tuple.bimap (flip lens.set m) (Cmd.map lift)


type alias CrossComponent s sm a am b bm =
    { source : Component s sm a am
    , target : Component s sm b bm
    , hook : a -> am -> Maybe bm
    }



-- This is lurking underneath
--type alias ComponentHook s sm a am i =
--    { component : Component s sm a am
--    , hook : i -> s -> Maybe am
--    }


updateCrossComponent :
    CrossComponent s sm a am b bm
    -> Update bm b
    -> IxUpdate am s sm
updateCrossComponent { source, target, hook } =
    updateCross source target hook


updateCross :
    Component s sm a am
    -> Component s sm b bm
    -> (a -> am -> Maybe i)
    -> IxUpdate i b bm
    -> IxUpdate am s sm
updateCross ca cb select up am s =
    let
        im =
            select (ca.lens.get s) am
    in
        foldMaybe (always none) (updateComponent cb up) im s
