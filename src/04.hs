import Data.Char
import Data.Ord
import Data.Function
import Data.Set (Set)
import qualified Data.Set as Set
import Data.List
import Text.ParserCombinators.ReadP


partOne xs = guardId * minute
  where grouped = foldl step [] xs
        sleepPeriodsById = map (\(id, xs) -> (id, sleepPeriods xs)) grouped
        sleepMinutesById = map (\(id, xs) -> (id, foldl markSleepMinutes Set.empty xs)) sleepPeriodsById
        sleepSizesById = map (\(id, xs) -> (id, Set.size xs)) sleepMinutesById
        totalSleepMinutesById = map (foldl1 (\(id, s) (_, x) -> (id, s+x))) $ groupBy ((==) `on` fst) $ sort sleepSizesById
        (guardId, _) = foldl1 (\(idm, xm) (id, x) -> if x > xm then (id, x) else (idm, xm)) totalSleepMinutesById
        occurences = uniqC $ concatMap (Set.toList . snd) $ filter (\(id, _) -> id == guardId) sleepMinutesById
        [_,minute] = maximumBy (comparing head) occurences

partTwo xs = map (\(id, xs) -> (id, foldl1 (\[mx, mm] [n, m]-> if n > mx then [n, m] else [mx, mm]) xs)) $ filter (\(_, xs) -> xs /= []) uniqued
  where grouped = foldl step [] xs
        sleepPeriodsById = map (\(id, xs) -> (id, sleepPeriods xs)) grouped
        sleepMinutesById = map (\(id, s) -> (id, Set.toList s)) $ map (\(id, xs) -> (id, foldl markSleepMinutes Set.empty xs)) sleepPeriodsById
        groupedMinutesById = map (foldl1 (\(id, xs) (_, ys) -> (id, concat [xs, ys]))) $ groupBy ((==) `on` fst) $ sort sleepMinutesById
        uniqued = map (\(id, xs) -> (id, uniqC xs)) groupedMinutesById

uniqC xs = map f $ group $ sort xs
  where f xs = [length xs, head xs]

step xs (Shift id) = (id, []):xs
step ((id, evs):xs) x = (id, evs++[x]):xs

data Event = Shift Id
           | Asleep Timestamp
           | Awake Timestamp
           deriving (Show, Eq)

type Timestamp = Int
type Id = Int

markSleepMinutes s (start, end) = foldl (\s x -> Set.insert x s) s [start..end]

sleepPeriod (Asleep x) (Awake y) = (x, pred y)

sleepPeriods [] = []
sleepPeriods (x:y:xs) = (sleepPeriods xs) ++ [sleepPeriod x y]

---
-- Parsing and main

parse = map parseLine . sort . lines

parseLine = fst . last . readP_to_S (choice [shift, awake, asleep])

timestamp :: ReadP Timestamp
timestamp =
  (munch1 $ not . isSpace) *> string " " *>
  (munch1 isDigit *> string ":") *> (read <$> munch1 isDigit)
  <* string "] "

shift = timestamp *> string "Guard #" *> (Shift . read <$> munch1 isDigit)
awake = Awake <$> timestamp <* string "wakes up"
asleep = Asleep <$> timestamp <* string "falls asleep"

main = do
  input <- getContents
  print $ partOne $ parse input
  mapM_ print $ partTwo $ parse input
