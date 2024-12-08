module Day6a where

import System.IO
import Control.Monad
import Data.List
import qualified Data.Map as Map

data Orientation = OUp | ODown | OLeft | ORight
    deriving Show

turnRight :: Orientation -> Orientation
turnRight OUp    = ORight
turnRight ORight = ODown
turnRight ODown  = OLeft
turnRight OLeft  = OUp

data BoardPosition = BoardPosition {row :: Integer, column :: Integer, size :: Integer}
    deriving (Show,Eq,Ord)

moveUp :: BoardPosition -> BoardPosition
moveUp (BoardPosition x y n) = BoardPosition (x-1) y n

moveDown :: BoardPosition -> BoardPosition
moveDown (BoardPosition x y n) = BoardPosition (x+1) y n

moveLeft :: BoardPosition -> BoardPosition
moveLeft (BoardPosition x y n) = BoardPosition x (y - 1) n

moveRight :: BoardPosition -> BoardPosition
moveRight (BoardPosition x y n) = BoardPosition x (y + 1) n

move :: Orientation -> BoardPosition -> BoardPosition
move OUp    = moveUp
move ORight = moveRight
move OLeft  = moveLeft
move ODown  = moveDown

outOfBoard :: BoardPosition -> Orientation -> Bool
outOfBoard position OUp    = row position <= 1
outOfBoard position ODown  = row position >= size position
outOfBoard position ORight = column position >= size position
outOfBoard position OLeft  = column position <= 1

data Tile = Obstacle | Hidden | Seen | Start
    deriving (Show,Eq)

charToTile :: Char -> Tile
charToTile '^' = Start
charToTile '#' = Obstacle
charToTile 'S' = Seen
charToTile  _  = Hidden

type Board = Map.Map BoardPosition Tile

emptyBoard :: Integer -> Board
emptyBoard n = Map.fromList [ (BoardPosition x y n, Hidden) | x <- [1..n], y <- [1..n]]

editTile :: (BoardPosition,Tile) -> Board -> Board
editTile (position,tile) = Map.adjust (const tile) position

checkForObstacle :: BoardPosition -> Orientation -> Board -> Bool
checkForObstacle position orientation board = case board Map.! move orientation position of Obstacle -> True
                                                                                            _        -> False

data Guard = Guard {position :: BoardPosition, orientation :: Orientation}
    deriving Show

moveGuard :: Board -> Guard -> Guard
moveGuard board (Guard position orientation) = if checkForObstacle position orientation board 
    then moveGuard board (Guard position (turnRight orientation)) 
    else Guard (move orientation position) orientation

createBoardFromInput :: String -> IO (BoardPosition, Board)
createBoardFromInput path = do
    handle <- openFile path ReadMode
    input  <- hGetContents handle
    let size_board = genericLength (lines input) :: Integer
    let rows = zip [1..size_board] (lines input) :: [(Integer, String)]
    let special_characters = concatMap (uncurry (keepSpecialCharacters size_board)) rows :: [(BoardPosition, Tile)]
    let start_point = fst $ head $ filter (\x -> snd x == Start) special_characters  :: BoardPosition
    return (start_point, createBoard size_board special_characters)

keepSpecialCharacters :: Integer -> Integer -> String -> [(BoardPosition, Tile)]
keepSpecialCharacters n row string = [
    (BoardPosition row column n, charToTile s) |
    (column, s) <- zip [1..(genericLength string)] string,
     s /= '.']

createBoard :: Integer -> [(BoardPosition, Tile)] -> Board
createBoard size = foldr editTile (emptyBoard size)

walkAroundBoard :: Guard -> Board -> Board
walkAroundBoard guard board = if outOfBoard (position guard) (orientation guard) 
    then editTile (position guard, Seen) board
    else walkAroundBoard (moveGuard board guard) (editTile (position guard, Seen) board)

main :: IO ()
main = do 
    (start, board) <- createBoardFromInput "Input/InputDay6.txt"
    let final_board = walkAroundBoard (Guard start OUp) board :: Board
    print $ length [x | x <- Map.elems final_board, x == Seen]