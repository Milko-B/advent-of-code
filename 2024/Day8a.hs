module Day8a where

import System.IO ( hGetContents, openFile, IOMode(ReadMode) )
import Data.List ( genericLength, nub )
import qualified Data.Map as Map

maina :: IO ()
maina = do
    locations_antennas <- collectAntennasFromInput "Input/InputDay8.txt"
    let antinodes_per_antenna = Map.map calculateAntinode locations_antennas :: Map.Map Antenna [Position]
    let antinodes = nub $ concat $ Map.elems antinodes_per_antenna :: [Position]
    print $ show $ length $ filter (\p -> x p > 0 && x p <= 50 && y p > 0 && y p <= 50) antinodes

data Position = Position {x :: Integer, y :: Integer}
    deriving (Show, Eq, Ord)
type Antenna = Char

collectAntennasFromInput :: String -> IO (Map.Map Antenna [Position])
collectAntennasFromInput path = do
    handle <- openFile path ReadMode
    input <- hGetContents handle
    let size_grid = genericLength (lines input) :: Integer
    let rows = zip [1..size_grid] (lines input) :: [(Integer, String)]
    let antennas = concatMap (uncurry collectAntennas) rows
    return $ convertToMap antennas

collectAntennas :: Integer -> String -> [(Position, Antenna)]
collectAntennas row string = [
    (Position {x = column, y = row}, s) |
    (column, s) <- zip [1..(genericLength string)] string,
    s /= '.']

convertToMap :: [(Position, Antenna)] -> Map.Map Antenna [Position]
convertToMap = foldr addToAntenna Map.empty
    where
        addToAntenna :: (Position, Antenna) -> Map.Map Antenna [Position] -> Map.Map Antenna [Position]
        addToAntenna (p, x) current_map = if Map.member x current_map 
            then Map.adjust (p:) x current_map
            else Map.insert x [p] current_map

calculateAntinode :: [Position] -> [Position]
calculateAntinode locations = concat [
            [
                Position {x = x p1 - (x p2 - x p1), y = y p1 - (y p2 - y p1)}, 
                Position {x = x p2 + (x p2 - x p1), y = y p2 + (y p2 - y p1)} 
            ]| 
            p1 <- locations,
            p2 <- locations,
            p1 < p2]