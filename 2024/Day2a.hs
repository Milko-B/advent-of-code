module Day2a where
    
import System.IO  
import Control.Monad
import Data.List


main :: IO ()
main = do
    reports <- createListFromInput "Input/InputDay2.txt"
    let safe_reports = filter isSafe reports 
    print $ show $ length safe_reports

createListFromInput :: FilePath -> IO [[Integer]]
createListFromInput path = do
    handle <- openFile path ReadMode
    input <- hGetContents handle
    return (map ((read <$>) . words) (lines input) :: [[Integer]])

checkDecreasingOrIncreasing :: [Integer] -> Bool
checkDecreasingOrIncreasing xs = sort xs == xs || sort xs == reverse xs

checkGradualChange :: [Integer] -> Bool
checkGradualChange []          = True
checkGradualChange [x]         = True
checkGradualChange (x:y:rest)  = (abs (x - y) >= 1 && abs (x - y) <= 3) && checkGradualChange (y:rest)

isSafe :: [Integer] -> Bool
isSafe xs = checkDecreasingOrIncreasing xs && checkGradualChange xs 