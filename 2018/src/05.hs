import Data.Char
import Data.List

import Common (getDayLines)

main = do
  input <- head <$> getDayLines 5
  print $ partOne input
  print $ partTwo input

partOne = length . fullReact

partTwo xs = minimum lengths
  where letters = sort $ nub $ map toLower $ xs
        lengths = map (\c -> partOne $ exclude c xs) letters

fullReact :: String -> String
fullReact = foldr step ""
  where step x (y:ys) | doesReact x y = ys
        step x ys = x:ys

doesReact x y = x /= y && toUpper x == toUpper y

exclude c = filter ((/= c) . toLower)
