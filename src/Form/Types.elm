module Form.Types exposing (..)

type alias Model = 
    { key: String
    , masterPassword: String
    , variant: Int
    }

type Msg = SetKey            String
         | SetMasterPassword String
         | SetVariant        String
