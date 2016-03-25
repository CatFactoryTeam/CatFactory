module Cat where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import RouteHash exposing (HashUpdate)
import Json.Decode as Json exposing ((:=))

--
--
--

type alias Model =
  { id: String
  , link: String
  }

--
--
--

view : Model -> Html
view  model =
  img [ src model.link, id "cat" , class "circular ui image" ] []

--
--
--

decode : Json.Decoder (List Model)
decode =
  ("data" := Json.list decodeSingle)

decodeSingle : Json.Decoder Model
decodeSingle =
  Json.object2 Model
    ("id" := Json.string)
    ("link" := Json.string)

--
-- ROUTING
--

delta2update : Maybe Model -> Maybe HashUpdate
delta2update newModel =
  case newModel of
    Just cat -> Just <|
      RouteHash.set [cat.id]
    Nothing -> Nothing
