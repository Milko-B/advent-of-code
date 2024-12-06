module Day1b where

import Day1a (createListsFromInput)
import qualified Data.Map as Map

main :: IO()
main = do
    (list1, list2) <- createListsFromInput "Input/InputDay1a.txt"
    let freq_list1 = tabulateElements list1
    print $ show $ calculateSimilarity list2 freq_list1

tabulateElements :: (Eq a,Ord a) => [a] -> Map.Map a Integer
tabulateElements xs = foldr (Map.adjust (+1)) (Map.fromList [(x, 0) | x <- xs]) xs

calculateSimilarity :: [Integer] -> Map.Map Integer Integer -> Integer
calculateSimilarity [] _               = 0
calculateSimilarity (x:rest) freq_list = case Map.lookup x freq_list of Nothing -> 0   + calculateSimilarity rest freq_list
                                                                        Just y  -> x*y + calculateSimilarity rest freq_list