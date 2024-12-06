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

movePossible :: BoardPosition -> Orientation -> Bool
movePossible position OUp    = row position > 1
movePossible position ODown  = row position < size position
movePossible position ORight = column position < size position
movePossible position OLeft  = column position > 1

data Tile = Obstacle | Hidden | Seen | Start BoardPosition
    deriving Show

type Board = Map.Map BoardPosition Tile

emptyBoard :: Integer -> Board
emptyBoard n = Map.fromList [ (BoardPosition x y n, Hidden) | x <- [1..n], y <- [1..n]]

editTileObstacle :: BoardPosition -> Tile -> Board -> Board
editTileObstacle position tile = Map.adjust (const tile) position

checkForObstacle :: BoardPosition -> Orientation -> Board -> Bool
checkForObstacle position orientation board = case board Map.! move orientation position of Obstacle -> True
                                                                                            _        -> False

data Guard = Guard {position :: BoardPosition, orientation :: Orientation}
    deriving Show

moveGuard :: Board -> Guard -> Guard
moveGuard board (Guard position orientation)
    | movePossible position orientation = if checkForObstacle position orientation board then moveGuard board (Guard position (turnRight orientation)) else Guard (move orientation position) orientation
    | otherwise                         = moveGuard board (Guard position (turnRight orientation))

createBoardFromInput :: String -> IO Board
createBoardFromInput path = do
    handle <- openFile path ReadMode
    input  <- hGetContents handle
    let size_board = length (lines input)
    let rows = zip [1..size_board] (lines input)
    return $ emptyBoard 0

keepSpecialCharacters :: Integer -> String -> [(Integer, Integer, String)]
keepSpecialCharacters row string = [(row, column, s) | (column, s) <- zip [1..length string] string]
