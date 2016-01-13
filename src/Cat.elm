module Cat where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Json.Decode as Json exposing ((:=))

--
--
--

type alias Model = {
  id: String,
  link: String
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

decodeCats : Json.Decoder (List Model)
decodeCats =
  ("data" := Json.list decodeCat)

decodeCat : Json.Decoder Model
decodeCat =
  Json.object2 Model
    ("id" := Json.string)
    ("link" := Json.string)
