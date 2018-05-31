module Example1 exposing (main)

import Element exposing (..)
import Element.Attributes exposing (..)

import Html exposing (Html)
import Http

import Json.Decode as JD

import Treeview as Tree

import MyStyle as Style exposing (stylesheet, Styles(..))


-- MODEL

type alias Model =
  { title : String
  , tree1 : Tree.Model
  , errmsg : String
  }

-- MSG

type Msg = NoOp
           | Download (Result Http.Error String)
           | Tree1Msg Tree.Msg

-- INIT

init  = ( empty
        , request_data "file:data.json"
        )

empty = Model
          "no title"
          Tree.empty
          ""



-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp -> ( model, Cmd.none )

    Tree1Msg submsg ->
      ( { model | tree1 = Tree.update submsg model.tree1 },
        Cmd.none
      )

    Download submsg ->
      case submsg of
        Err error ->
          ({model | errmsg = (format_err error)}, Cmd.none)
        Ok data ->
          (decode data model, Cmd.none)

decode : String -> Model -> Model
decode data model =
  let result = JD.decodeString decoder data
  in
    case result of
      Ok decoded ->
        decoded
      Err error ->
        {model | errmsg = format_err error}

format_err : a -> String
format_err error =
  "(EE) " ++ (toString error)

decoder : JD.Decoder Model
decoder =
  JD.map3 Model
    ( JD.field "title" JD.string )
    ( JD.field "tree1" Tree.decoder )
    ( JD.field "errmsg" JD.string )

request_data : String -> Cmd Msg
request_data url =
  Http.send Download (Http.getString url)




main : Program Never Model Msg
main = Html.program
  { init          = init
  , update        = update
  , view          = view
  , subscriptions = subscriptions
  }


subscriptions : a -> Sub msg
subscriptions model =
  Sub.none




-- VIEW




view : Model -> Html Msg
view model =
  Element.viewport stylesheet <|
    column None
      []
      [ text model.title

      ]
