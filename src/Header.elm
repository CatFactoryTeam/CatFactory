module Header (..) where

import Html exposing (..)
import Html.Attributes exposing (..)


--
--
--


view : Html
view =
  header
    []
    [ span [ class "logo" ] []
    , h2
        [ class "ui header", style [ ( "display", "inline-block" ) ] ]
        [ text "A cat factory"
        , p [ class "sub header" ] [ text "Since nine-meow sixty-meow" ]
        ]
    , span [ class "paint" ] []
    ]
