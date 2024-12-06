module Day5a where
import System.IO  
import Control.Monad
import Data.List
import Data.List.Split

type PrintRules = [(Integer, Integer)]
type Pages = [Integer]

main :: IO()
main = do
    rules <- createRulesFromInput "Input/InputDay5Rules.txt"
    pages <- createPagesFromInput "Input/InputDay5Pages.txt"
    let correct_updates = filter (checkRules rules) pages
    print $ show $ sum $ map (head.middle) correct_updates

middle :: [a] -> [a]
middle l@(_:_:_:_) = middle $ tail $ init l
middle l           = l 

createRulesFromInput :: String -> IO PrintRules
createRulesFromInput path = do
    handle <- openFile path ReadMode
    input <- hGetContents handle
    let 
        createRule :: String -> (Integer, Integer)
        createRule string = ( (read.head) $ splitOn "|" string, (read.last) $ splitOn "|" string)
   
    return $ map createRule $ lines input

createPagesFromInput :: String -> IO [Pages]
createPagesFromInput path = do
    handle <- openFile path ReadMode
    input <- hGetContents handle
    let
        createPages :: String -> Pages
        createPages string = read <$> splitOn "," string :: [Integer]
    return $ map createPages $ lines input

retrieveRelevantRules :: Pages -> PrintRules -> PrintRules
retrieveRelevantRules pages rules = [(x,y) | (x,y) <- rules, x `elem` pages && y `elem` pages] 

discardIrrelevantPages ::  Pages -> PrintRules -> Pages
discardIrrelevantPages pages rules = [p | p <- pages, p `elem` map fst rules ||  p `elem` map snd rules ]

createPairings :: Pages -> [(Integer, Integer)]
createPairings []       = []
createPairings (x:rest) = [(x,y) | y <- rest] ++ createPairings rest

checkRules :: PrintRules -> Pages -> Bool
checkRules rules pages  = intersect relevant_rules (createPairings (discardIrrelevantPages pages relevant_rules)) == relevant_rules
    where
        relevant_rules :: PrintRules 
        relevant_rules = retrieveRelevantRules pages rules