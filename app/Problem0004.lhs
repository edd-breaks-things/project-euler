Problem 4: Largest Palindrome Product
======================================

URL: https://projecteuler.net/problem=4

Description
-----------

A palindromic number reads the same both ways. The largest palindrome made from the product of two $2$-digit numbers is $9009 = 91 \times 99$.

Find the largest palindrome made from the product of two $3$-digit numbers.

Solution
--------

\begin{code}
module Problem0004 where

isPalindromic :: Integer -> Bool
isPalindromic x = s == reverse s
  where s = show x

products :: [Integer] -> [Integer] -> [Integer]
products xs ys = [x * y | x <- xs, y <- ys]

getPalindromicProducts :: [Integer] -> [Integer]
palindromicProducts = filter isPalindromic

solve :: Integer
solve = maximum (getPalindromicProducts (products [100..999] [100..999]))
\end{code}
