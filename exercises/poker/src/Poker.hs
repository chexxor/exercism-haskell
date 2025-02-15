module Poker (bestHands) where

import Data.List.Split (splitOn)

data Suit = Hearts | Spades | Diamonds | Clubs deriving (Eq)

instance Show Suit where
  show Hearts = "H"
  show Spades = "S"
  show Diamonds = "D"
  show Clubs = "C"

data FaceValue
  = Two
  | Three
  | Four
  | Five
  | Six
  | Seven
  | Eight
  | Nine
  | Ten
  | Jack
  | Queen
  | King
  | Ace
  deriving (Eq, Ord, Enum)

instance Show FaceValue where
  show Two = "2"
  show Three = "3"
  show Four = "4"
  show Five = "5"
  show Six = "6"
  show Seven = "7"
  show Eight = "8"
  show Nine = "9"
  show Ten = "10"
  show Jack = "J"
  show Queen = "Q"
  show King = "K"
  show Ace = "A"

data Card = Card {
  face :: FaceValue,
  suit :: Suit
}

instance Show Card where
  show (Card f s) = (show f) ++ (show s)

data Hand = Hand Card Card Card Card Card

instance Show Hand where
  show (Hand a b c d e) = (show a) ++ " " ++ (show b) ++ " " ++ (show c) ++ " " ++ (show d) ++ " " ++ (show e)

bestHands :: [String] -> Maybe [String]
bestHands hands = Just hands

parseSuit :: Char -> Maybe Suit
parseSuit 'H' = Just Hearts
parseSuit 'D' = Just Diamonds
parseSuit 'C' = Just Clubs
parseSuit 'S' = Just Spades
parseSuit _ = Nothing

parseFace :: String -> Maybe FaceValue
parseFace "2" = Just Two
parseFace "3" = Just Three
parseFace "4" = Just Four
parseFace "5" = Just Five
parseFace "6" = Just Six
parseFace "7" = Just Seven
parseFace "8" = Just Eight
parseFace "9" = Just Nine
parseFace "10" = Just Ten
parseFace "J" = Just Jack
parseFace "Q" = Just Queen
parseFace "K" = Just King
parseFace "A" = Just Ace
parseFace _ = Nothing

parseCard :: String -> Maybe Card
parseCard ('1' : '0' : s : []) = Card <$> (parseFace "10") <*> (parseSuit s)
parseCard (f : s : []) = Card <$> (parseFace [f]) <*> (parseSuit s)
parseCard _ = Nothing

parseHand :: String -> Maybe Hand
parseHand s = do
  x <- sequence $ parseCard <$> splitOn " " s
  toHand x
  where
    toHand (a : b : c : d : e : []) = Just $ Hand a b c d e
    toHand _ = Nothing

data HandRank
  = StraightFlush FaceValue
  | FourOfAKind FaceValue
  | FullHouse FaceValue
  | Flush Hand
  | Straight FaceValue
  | ThreeOfAKind FaceValue
  | TwoPair FaceValue FaceValue FaceValue
  | Pair FaceValue FaceValue FaceValue FaceValue
  | HighCard Hand
  deriving (Show)

handToList :: Hand -> [Card]
handToList (Hand a b c d e) = [a, b, c, d, e]

filterFlush :: Hand -> Maybe HandRank
filterFlush h@(Hand (Card _ a) (Card _ b) (Card _ c) (Card _ d) (Card _ e)) = if (all (== a) [b,c,d,e])
  then Just (Flush h)
  else Nothing

-- filterStraight :: Hand -> Maybe HandRank
-- filterStraight hand = do
--  let faceValues = sort $ map face hand
--  let (a b c d e) = faceValues


-- getHandRank :: Hand -> HandRank
-- getHandRank (Hand a b c d e) =
