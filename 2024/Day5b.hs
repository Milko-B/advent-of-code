import Day5a(
    PrintRules, 
    Pages,
    createRulesFromInput,
    createPagesFromInput,
    checkRules,
    createPairings,
    discardIrrelevantPages,
    retrieveRelevantRules,
    middle)

import System.IO  
import Control.Monad
import Data.List

main :: IO ()
main = do
    rules <- createRulesFromInput "Input/InputDay5Rules.txt"
    pages <- createPagesFromInput "Input/InputDay5Pages.txt"
    let wrong_updates = filter ( not.checkRules rules) pages
    let fixed_updates = map (fixBrokenRules rules) wrong_updates
    print $ show $ sum $ map (head.middle) fixed_updates

findBrokenRules :: Pages -> PrintRules -> [(Integer, Integer)]
findBrokenRules pages rules = relevant_rules \\ createPairings pages
    where
    relevant_rules :: PrintRules 
    relevant_rules = sort $ retrieveRelevantRules pages rules


fixBrokenRules :: PrintRules -> Pages -> Pages
fixBrokenRules rules pages = 
    if null broken_rules 
        then pages 
        else fixBrokenRules rules $ swap pages (head broken_rules)

    where         
    broken_rules :: PrintRules
    broken_rules = findBrokenRules pages rules

swap :: Pages -> (Integer, Integer) -> Pages
swap [] (x,y)       = []
swap (z:rest) (x,y) 
    | z == x    = y : swap rest (x,y)
    | z == y    = x : swap rest (x,y)
    | otherwise = z : swap rest (x,y)