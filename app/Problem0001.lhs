\begin{code}
module Problem0001 where

solve :: Integer
solve = sum [x | x <- [1..999], x `mod` 3 == 0 || x `mod` 5 == 0]
\end{code}