module Util (..) where

import Array
import Random.Array
import Random exposing (Seed, initialSeed, generate)


shuffleList : List a -> Seed -> List a
shuffleList list seed =
  let
    generator =
      Random.Array.shuffle (Array.fromList list)

    ( shuffledArray, seed ) =
      generate generator seed
  in
    Array.toList shuffledArray
