module Day11Spec where

import Day11 hiding (main)

import Test.Hspec

import Data.Vector (Vector, fromList, toList, (!))

main = hspec spec

room1 = asRoom ["LLL","LLL","LLL"]

room2 = asRoom [ "0.."
               , "..L"
               , "123" ]

room3 = asRoom [ "123"
               , "4.6"
               , "789" ]

exampleRoom = asRoom [
  "L.LL.LL.LL",
  "LLLLLLL.LL",
  "L.L.L..L..",
  "LLLL.LL.LL",
  "L.LL.LL.LL",
  "L.LLLLL.LL",
  "..L.L.....",
  "LLLLLLLLLL",
  "L.LLLLLL.L",
  "L.LLLLL.LL" ]

step1 = asRoom [
  "#.##.##.##",
  "#######.##",
  "#.#.#..#..",
  "####.##.##",
  "#.##.##.##",
  "#.#####.##",
  "..#.#.....",
  "##########",
  "#.######.#",
  "#.#####.##"]

step2 = asRoom [
  "#.LL.L#.##",
  "#LLLLLL.L#",
  "L.L.L..L..",
  "#LLL.LL.L#",
  "#.LL.LL.LL",
  "#.LLLL#.##",
  "..L.L.....",
  "#LLLLLLLL#",
  "#.LLLLLL.L",
  "#.#LLLL.##"]

step3 = asRoom [
  "#.##.L#.##",
  "#L###LL.L#",
  "L.#.#..#..",
  "#L##.##.L#",
  "#.##.LL.LL",
  "#.###L#.##",
  "..#.#.....",
  "#L######L#",
  "#.LL###L.L",
  "#.#L###.##"]

step5 = asRoom [
  "#.#L.L#.##",
  "#LLL#LL.L#",
  "L.#.L..#..",
  "#L##.##.L#",
  "#.#L.LL.LL",
  "#.#L#L#.##",
  "..L.L.....",
  "#L#L##L#L#",
  "#.LLLLLL.L",
  "#.#L#L#.##"]

lastStep = asRoom [
  "#.#L.L#.##",
  "#LLL#LL.L#",
  "L.#.L..#..",
  "#L##.##.L#",
  "#.#L.LL.LL",
  "#.#L#L#.##",
  "..L.L.....",
  "#L#L##L#L#",
  "#.LLLLLL.L",
  "#.#L#L#.##"]

step1' = asRoom [ "#.##.##.##"
                , "#######.##"
                , "#.#.#..#.."
                , "####.##.##"
                , "#.##.##.##"
                , "#.#####.##"
                , "..#.#....."
                , "##########"
                , "#.######.#"
                , "#.#####.##" ]
step2' = asRoom ["#.LL.LL.L#"
                , "#LLLLLL.LL"
                , "L.L.L..L.."
                , "LLLL.LL.LL"
                , "L.LL.LL.LL"
                , "L.LLLLL.LL"
                , "..L.L....."
                , "LLLLLLLLL#"
                , "#.LLLLLL.L"
                , "#.LLLLL.L#" ]

spec =
  describe "Day 11" $ do
    it "finds a seat" $ do
      seat (asRoom ["123","456","789"]) (1,1) `shouldBe` Just '5'

    it "finds adjacent seat" $ do
      adjacentSeats (asRoom["123","456","789"]) (1,1) `shouldBe` "14728369"
      adjacentSeats (asRoom["123","456","789"]) (0,0) `shouldBe` "425"
      adjacentSeats (asRoom["123","456","789"]) (2,2) `shouldBe` "586"

    it "steps a seat" $ do
      stepSeat room1 (0,0) `shouldBe` '#'

    it "generates next step" $ do
      step stepSeat room1 `shouldBe` asRoom ["###","###","###"]
      (step stepSeat step1) ! 0  `shouldBe` fromList "#.LL.L#.##"

    it "check step 2 computation" $ do
      adjacentSeats step1 (0,0) `shouldBe` "#.#"
      occupiedSeats (adjacentSeats step1 (0,0)) `shouldBe` 2
      4 <= (occupiedSeats (adjacentSeats step1 (0,0))) `shouldBe` False

    it "generates steps for example room" $ do
      step stepSeat exampleRoom `shouldBe` step1
      step stepSeat step1 `shouldBe` step2
      step stepSeat step2 `shouldBe` step3
      step stepSeat step5 `shouldBe` lastStep
      step stepSeat lastStep `shouldBe` lastStep

    it "steps until stale" $ do
      stepUntilStable stepSeat exampleRoom `shouldBe` lastStep

    it "counts occupied seats in a room" $ do
      countEmptySeats lastStep `shouldBe` 37

    it "sees a seat following a slope" $ do
      seeSeat room1 (0,0) (1,0) `shouldBe` Just 'L'

      seeSeat room2 (0,0) (1,0) `shouldBe` Nothing
      seeSeat room2 (0,0) (0,1) `shouldBe` Just '1'
      seeSeat room2 (0,0) (1,1) `shouldBe` Just '3'

    it "finds visible seats" $ do
      visibleSeats room3 (0,0) `shouldBe` "429"
      visibleSeats room3 (1,1) `shouldBe` "14728369"

    it "steps with visible seats" $ do
      step stepSeat' step1' `shouldBe` step2'
