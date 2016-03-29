module Main (..) where

import Time
import Http
import StartApp
import Keyboard
import Array
import List.Extra
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Task exposing (Task, andThen)
import Effects exposing (Effects, Never)
import Random.Array
import Random exposing (Seed, initialSeed, generate)
import RouteHash exposing (HashUpdate)
import Cat
import Header


--
-- ACTION
--


type Action
  = Meow
  | SetCurrent (Maybe Cat.Id)
  | CatsRetrievedFromAPI (Maybe (List Cat.Model))
  | SetSeed Seed
  | NoOp



--
-- MODEL
--


type alias Model =
  { cats : List Cat.Model
  , remainingCats : List Cat.Model
  , current : Maybe Cat.Model
  , isLoading : Bool
  , seed : Seed
  }


initModel : ( Model, Effects Action )
initModel =
  ( { cats = [], remainingCats = [], current = Nothing, isLoading = True, seed = initialSeed 0 }
  , retrieveCats
  )



--
-- UPDATE
--


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    Meow ->
      ( updateForMeowAction model, Effects.none )

    SetCurrent maybeCatId ->
      updateForSetCurrentAction maybeCatId model

    SetSeed seed ->
      ( { model | seed = seed }, Effects.none )

    CatsRetrievedFromAPI result ->
      case result of
        Just cats ->
          ( { model
              | remainingCats = shuffleList cats model.seed
              , cats = cats
              , isLoading = False
            }
          , Effects.none
          )

        Nothing ->
          ( model, Effects.none )

    NoOp ->
      ( model, Effects.none )


updateForMeowAction : Model -> Model
updateForMeowAction model =
  let
    remainingCats =
      Maybe.withDefault [] (List.tail model.remainingCats)

    remainingCats' =
      if List.isEmpty remainingCats then
        shuffleList model.cats model.seed
      else
        remainingCats

    current =
      List.head remainingCats'
  in
    { model
      | remainingCats = remainingCats'
      , current = current
    }


updateForSetCurrentAction : Maybe String -> Model -> ( Model, Effects Action )
updateForSetCurrentAction maybeCatId model =
  -- If it's loading, we don't have cats yet
  -- So we need to send SetCurrent actions until we got them
  if model.isLoading then
    ( model, Effects.task (Task.succeed (SetCurrent maybeCatId)) )
  else
    case maybeCatId of
      Just catId ->
        ( { model | current = List.Extra.find (\c -> c.id == catId) model.cats }, Effects.none )

      Nothing ->
        ( { model | current = List.head model.remainingCats }, Effects.none )


shuffleList : List a -> Seed -> List a
shuffleList list seed =
  let
    generator =
      Random.Array.shuffle (Array.fromList list)

    ( shuffledArray, seed ) =
      generate generator seed
  in
    Array.toList shuffledArray



--
-- VIEW
--


view : Signal.Address Action -> Model -> Html
view address ({ current } as model) =
  let
    loader =
      viewLoader

    sectionBody =
      if model.isLoading then
        [ loader ]
      else
        [ viewCat model
        , viewPreloadedCats model
        , button [ id "meow-button", class "ui button", onClick address Meow ] [ text "Meow!" ]
        ]
  in
    div
      []
      [ Header.view
      , section
          []
          [ div
              [ class "container" ]
              sectionBody
          ]
      ]


viewCat : Model -> Html
viewCat { current } =
  case current of
    Just cat ->
      Cat.view cat

    Nothing ->
      span [] []


{-| By preloading some of the next cats
We make the experience even better!
Displaying the next cat became instantaneous
(except if the user is faster than its internet)
-}
viewPreloadedCats : Model -> Html
viewPreloadedCats model =
  div
    [ class "preloaded-cats" ]
    (List.map Cat.viewPreloaded (List.take 5 model.remainingCats))


viewLoader : Html
viewLoader =
  div
    [ class "spinner" ]
    [ div [ class "double-bounce1" ] []
    , div [ class "double-bounce2" ] []
    ]



--
--
--


retrieveCats : Effects Action
retrieveCats =
  Task.sleep (2 * Time.second)
    `andThen` (\x -> Http.get Cat.decode ("http://catfactory-api.herokuapp.com/cats"))
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
  RouteHash.map ((::) "cat")
    <| Cat.delta2update (newModel.current)


location2action : List String -> List Action
location2action list =
  case list of
    first :: rest ->
      case first of
        "cat" ->
          [ SetCurrent (List.head rest) ]

        _ ->
          [ SetCurrent Nothing ]

    _ ->
      []


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
  StartApp.start { init = initModel, view = view, update = update, inputs = [ routing.signal, seed, pressN ] }


main : Signal Html
main =
  app.html


port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks


{-| Seed updated every second to get random order of cats
-}
seed : Signal Action
seed =
  Signal.map (\time -> SetSeed (initialSeed (truncate time))) (Time.every Time.second)


keyCodeNextCat : Int
keyCodeNextCat =
  78


pressN : Signal Action
pressN =
  Signal.map
    (\k ->
      if k then
        Meow
      else
        NoOp
    )
    (Keyboard.isDown keyCodeNextCat)
