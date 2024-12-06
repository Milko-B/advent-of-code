module Day1a where
    
import System.IO  
import Control.Monad
import Data.List


main :: IO ()
main = do
    (list1, list2) <- createListsFromInput "Input/InputDay1a.txt"
    print $ show $ calculateDistance (sort list1) (sort list2)


createListsFromInput :: FilePath -> IO ([Integer], [Integer])
createListsFromInput path = do
    handle <- openFile path ReadMode
    input <- hGetContents handle
    let (list1, list2) = createLists input
    return (list1, list2)

createLists :: String -> ([Integer], [Integer])
createLists input = unzip $ map (\pair -> (head pair, last pair)) (linesAsList input)

linesAsList :: String -> [[Integer]]
linesAsList input = map ((read <$>) . words) (lines input) :: [[Integer]]

calculateDistance :: [Integer] -> [Integer] -> Integer
calculateDistance [] _                = 0
calculateDistance _ []                = 0
calculateDistance (x:restx) (y:resty) = abs(x - y) + calculateDistance restx resty