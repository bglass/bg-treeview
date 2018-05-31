module Node exposing (..)
import Json.Decode as JD


-- MODEL

type alias Model = Node

type alias Node =
  { key      : String
  , name     : String
  , state    : State
  , style    : Style
  , data     : Payload
  , children : Children
}


type alias Payload = -- defined by User
  { date      : String
  , resource  : String
  }

type alias State =
  { opened      : Bool
  , enabled     : Bool
  , visible     : Bool
  , selected    : Bool
  , selectable  : Bool
  , checked     : Bool
  , checkable   : Bool
}

type Children = Children (List Node)

type alias Style = String -- TBD

type Msg = NoOp


-- INIT


empty : Node
empty = Node "-" "-" state0 "" data0 children0

children0 : Children
children0 = Children []

data0 : Payload
data0 = Payload "" ""

state0 : State
state0 =
  { opened      = False
  , enabled     = True
  , visible     = True
  , selected    = False
  , selectable  = True
  , checked     = False
  , checkable   = True
  }

children nodes = Children nodes


-- UPDATE

decoder : JD.Decoder Node
decoder =
  JD.map6 Node
    (JD.field "key"      JD.string)
    (JD.field "name"     JD.string)
    (JD.field "state"    stateDecoder)
    (JD.field "style"    JD.string)    -- placeholder
    (JD.field "data"     payloadDecoder)
    (JD.field "children" childrenDecoder)

childrenDecoder : JD.Decoder Children
childrenDecoder =
  JD.map Children
    ( JD.list <| JD.lazy <| \_ -> decoder )


stateDecoder : JD.Decoder State
stateDecoder =
  JD.map7 State
  (JD.field "opened"     JD.bool)
  (JD.field "enabled"    JD.bool)
  (JD.field "visible"    JD.bool)
  (JD.field "selected"   JD.bool)
  (JD.field "selectable" JD.bool)
  (JD.field "checked"    JD.bool)
  (JD.field "checkable"  JD.bool)


payloadDecoder : JD.Decoder Payload    -- TBD: user defined
payloadDecoder =
  JD.map2 Payload
    (JD.field "date"      JD.string)
    (JD.field "resource"  JD.string)
