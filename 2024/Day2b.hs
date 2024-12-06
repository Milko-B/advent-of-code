module Day2b where

import Day2a (createListFromInput, isSafe)

import System.IO
import Control.Monad
import Data.List

main :: IO ()
main = do
    reports <- createListFromInput "Input/InputDay2.txt"
    let safe_with_dampner_reports = filter isSafeWithDampner reports
    print $ show $ length safe_with_dampner_reports


problemDampner :: [Integer] -> [[Integer]]
problemDampner xs = [take n xs ++ drop (n+1) xs | n <- [0..(length xs - 1)]]

isSafeWithDampner :: [Integer] -> Bool
isSafeWithDampner xs = isSafe xs || any isSafe (problemDampner xs)

