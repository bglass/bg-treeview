module Treeview exposing (..)

import Element exposing (..)

import Json.Decode as JD

import Node


-- MODEL

type alias Model = Tree

type alias Tree =
  { tree  :  Node.Model
  , styles : String      -- TBD
  , config : Config
  }

type Msg = NoOp




type alias Config =
  { sort_order :  (Node.Model -> String)
  -- , filter :      (Node -> Bool)
  }

-- INIT

empty : Model
empty = Tree Node.empty "" config0



config0 = Config .name  -- (.state.visible)

-- UPDATE

update : Msg -> Model -> Model
update msg model =
  model

decoder : JD.Decoder Tree
decoder =
  JD.map3 Tree
    (JD.field "tree" Node.decoder)
    (JD.field "styles" JD.string)
    (JD.succeed   config0)



-- VIEW

view : Element style variation msg
view =
  text "Treeview"
