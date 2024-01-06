module Day18RealParser where

import Data.Char
import Control.Applicative
import Text.ParserCombinators.ReadP
import Data.Maybe

main = interact $ show . partOne . (map parseLine) . lines

parseLine = calculate

partOne = sum . catMaybes

data Expr = Add Expr Expr
          | Sub Expr Expr
          | Mul Expr Expr
          | Div Expr Expr
          | Lit Integer deriving ( Eq, Show )

eval :: Expr -> Integer
eval (Lit a) = a
eval (Add l r) = eval l + eval r
eval (Sub l r) = eval l - eval r
eval (Mul l r) = eval l * eval r
eval (Div l r) = eval l `div` eval r

spaceChar :: Char -> ReadP Char
spaceChar c = between skipSpaces skipSpaces (char c)

literal :: ReadP Expr
literal = Lit . read <$> (skipSpaces *> munch1 isDigit <* skipSpaces)

add :: ReadP Expr
add = Add <$> term <*> (spaceChar '+' *> expr)

sub :: ReadP Expr
sub = Sub <$> term <*> (spaceChar '-' *> expr)

mul :: ReadP Expr
mul = Mul <$> factor <*> (spaceChar '*' *> term)

divide :: ReadP Expr
divide = Div <$> factor <*> (spaceChar '/' *> term)

parens :: ReadP Expr
parens = between (spaceChar '(') (spaceChar ')') expr

factor :: ReadP Expr
factor = literal <|> parens

term :: ReadP Expr
term = mul <|> divide <|> factor

expr :: ReadP Expr
expr = add <|> sub <|> term

parse :: String -> Maybe Expr
parse = parseMaybe (expr <* eof)

parseMaybe :: ReadP a -> String -> Maybe a
parseMaybe parser input =
    case reverse $ readP_to_S parser input of
        [] -> Nothing
        ((result, _):_) -> Just result

calculate :: String -> Maybe Integer
calculate = fmap eval . parse
