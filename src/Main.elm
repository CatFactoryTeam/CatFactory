module Main where

import Task
import Http
import StartApp
import RouteHash exposing (HashUpdate)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Effects exposing (Effects, Never)
import List.Extra
import Array
import Random.Array
import Random.Int
import Random
import Time

import Cat
import Header

--
-- ACTION
--

type Action =
    Meow -- Click on "Meow" button to display next cat
  | SetCurrent String
  | CatsRetrievedFromAPI (Maybe (List Cat.Model))
  | NoOp -- Nothing

--
-- MODEL
--

type alias Model =
  { cats: List Cat.Model
  , remainingCats: List Cat.Model
  , current: Maybe Cat.Model
  , isLoading: Bool
  , seed: Random.Seed
  }

initModel : (Model, Effects Action)
initModel =
  ( { cats = [], remainingCats = [], current = Nothing, isLoading = True, seed = Random.initialSeed 0 }
  , retrieveCats
  )

--
-- UPDATE
--

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    Meow -> (updateForMeowAction model, Effects.none)

    SetCurrent catId -> updateForSetCurrentAction catId model

    CatsRetrievedFromAPI result ->
      case result of
        Just cats ->
          let
            generator = Random.Array.shuffle(Array.fromList cats)
            (shuffledList, seed) = Random.generate generator model.seed
          in
            ({ model | remainingCats = Array.toList shuffledList
                     , cats = cats
                     , current = List.head cats
                     , isLoading = False
             }, Effects.none)
        Nothing -> (model, Effects.none)

    NoOp -> (model, Effects.none)

updateForMeowAction : Model -> Model
updateForMeowAction model =
  let
    remainingCats = Maybe.withDefault [] (List.tail model.remainingCats)
    remainingCats' = if List.isEmpty remainingCats then model.cats else remainingCats

    current = List.head remainingCats'
  in
    { model | remainingCats = remainingCats'
            , current = current }

updateForSetCurrentAction : String -> Model -> (Model, Effects Action)
updateForSetCurrentAction catId model =
  -- If it's loading, we don't have cats yet
  -- So we need to send SetCurrent actions until we got them
  if model.isLoading then
    (model, Effects.task (Task.succeed (SetCurrent catId)))
  else
    ({ model | current = List.Extra.find (\c -> c.id == catId) model.cats }, Effects.none)

--
-- VIEW
--

view : Signal.Address Action -> Model -> Html
view address ({ current } as model) =
  let
    loader = viewLoader
    catView = case current of
      Just cat -> Cat.view cat
      Nothing -> span [] []

    sectionBody =
      -- Display a loader
      if model.isLoading then [ loader ]
      else
        [ catView
        , button [ id "ncat", class "ui button", onClick address Meow ] [ text "Meow!" ]
        ]
  in
    div []
      [ Header.view
      , section []
        [ div [ class "wrap" ]
          sectionBody
        ]
      ]

viewLoader : Html
viewLoader =
  div [ class "spinner" ]
    [ div [ class "double-bounce1" ] []
    , div [ class "double-bounce2" ] []
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
delta2update oldModel newModel =
  RouteHash.map ((::) "cat") <|
    Cat.delta2update (newModel.current)

location2action : List String -> List Action
location2action list =
  case list of
    first :: rest ->
      case first of
        "cat" -> [SetCurrent (Maybe.withDefault "" (List.head rest))]
        _ -> []

    _ -> []

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
--- MAIN
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
