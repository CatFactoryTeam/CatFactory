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
  }

initModel : (Model, Effects Action)
initModel =
  ( { cats = [], remainingCats = [], current = Nothing, isLoading = True }
  , retrieveCats
  )

--
-- UPDATE
--

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    Meow -> (updateForMeowAction model, Effects.none)

    SetCurrent catId -> (updateForSetCurrentAction catId model, Effects.none)

    CatsRetrievedFromAPI result ->
      case result of
        Just cats -> ({ model | remainingCats = cats
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

updateForSetCurrentAction : String -> Model -> Model
updateForSetCurrentAction catId model =
  { model | current = List.Extra.find (\c -> c.id == catId) model.cats }

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
