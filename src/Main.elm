module Main where

import Task
import Http
import StartApp
import RouteHash exposing (HashUpdate)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Effects exposing (Effects, Never)

import Cat
import Header

--
--
--

type Action =
    Meow -- Click on "Meow" button to display next cat
  | CatsRetrievedFromAPI (Maybe (List Cat.Model))
  | NoOp -- Nothing

--
--
--

type alias Model =
  { cats: List Cat.Model
  , remainingCats: List Cat.Model
  }

initModel : (Model, Effects Action)
initModel =
  ( { cats = [], remainingCats = [] }
  , retrieveCats
  )

--
--
--

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    Meow -> (updateWithMeowAction model, Effects.none)

    CatsRetrievedFromAPI result ->
      case result of
        Just cats -> ({ model | remainingCats = cats, cats = cats }, Effects.none)
        Nothing -> (model, Effects.none)

    NoOp -> (model, Effects.none)

updateWithMeowAction : Model -> Model
updateWithMeowAction model =
  let
    remainingCats = Maybe.withDefault [] (List.tail model.remainingCats)
  in
    { model | remainingCats =
      if List.isEmpty remainingCats then model.cats else remainingCats }

--
--
--

view : Signal.Address Action -> Model -> Html
view address ({ remainingCats } as model) =
  let
    catView = case List.head remainingCats of
      Just cat -> Cat.view cat
      Nothing -> span [] []
  in
    div []
      [ Header.view
      , section []
        [ div [ class "wrap" ]
          [ catView
          , button [ id "ncat", class "ui button", onClick address Meow ] [ text "Meow!" ]
          ]
        ]
      ]

--
--
--

retrieveCats : Effects Action
retrieveCats =
  Http.get Cat.decode ("http://catfactory-api.herokuapp.com/cats")
    |> Task.toMaybe
    |> Task.map CatsRetrievedFromAPI
    |> Effects.task

--
-- ROUTING
--

routing : Signal.Mailbox Action
routing =
    Signal.mailbox NoOp

delta2update : Model -> Model -> Maybe HashUpdate
delta2update previous current =
  RouteHash.map ((::) "cat") <|
    Cat.delta2update (List.head previous.remainingCats) (List.head current.remainingCats)

location2action : List String -> List Action
location2action list = []

port routeTasks : Signal (Task.Task () ())
port routeTasks =
  RouteHash.start
    { prefix = RouteHash.defaultPrefix
    , address = routing.address
    , models = app.model
    , delta2update = delta2update
    , location2action = location2action
    }

---
---
---

app : StartApp.App Model
app =
  StartApp.start { init = initModel, view = view, update = update, inputs = [ routing.signal ] }

main : Signal Html
main =
  app.html

port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks
