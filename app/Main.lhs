\begin{code}
module Main where

import System.Environment (getArgs)
import Text.Read (readMaybe)

import qualified Problem0000
import qualified Problem0001

main :: IO ()
main = do
    args <- getArgs
    case args of
        [] -> putStrLn "Usage: nix run . -- <problem-number>\nExample: nix run . -- 0001"
        (arg:_) -> case readMaybe arg :: Maybe Int of
            Nothing -> putStrLn $ "Invalid problem number: " ++ arg
            Just n -> runProblem n

runProblem :: Int -> IO ()
runProblem n = case n of
    0 -> print Problem0000.solve
    1 -> print Problem0001.solve
    _ -> putStrLn $ "Problem " ++ show n ++ " not found"
\end{code}