import Html exposing (..)

type alias Node = { name : String }

type alias Config =
  { sort_order : (Node -> String)
  -- , filter : (Node -> Bool)
  }

c = Config name

name : Node -> String
name =
  .name

data = [Node "a", Node "e", Node "c", Node "f", Node "b", Node "d"]


main =
  List.sortBy c.sort_order data
  |> toString
  |> text
