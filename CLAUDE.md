# Project Euler Setup Instructions

## Adding New Problems

When the user requests to add a new Project Euler problem (e.g., "add problem 3" or "add problem0003"):

1. **Fetch the problem description** from `https://projecteuler.net/problem=N` (where N is the problem number)

2. **Create the .lhs file** at `app/Problem{NNNN}.lhs` with this format:
   ```lhs
   Problem N: [Problem Title]
   ================================

   URL: https://projecteuler.net/problem=N

   Description
   -----------

   [Exact problem description from Project Euler with LaTeX math formatting]

   Solution
   --------

   \begin{code}
   module Problem{NNNN} where

   solve :: Integer
   solve = undefined
   \end{code}
   ```

3. **Update Main.lhs** to import the new problem and add it to the main function

4. **Update project-euler.cabal** to add the new module to the `other-modules` section in sorted order

5. **DO NOT implement the solution** - leave it as `undefined`

## Important Notes

- Use LaTeX math notation (e.g., `$n$` for inline, `$$...$$` for display math)
- Problem numbers should be zero-padded to 4 digits in module names (e.g., Problem0003)
- Keep modules in numerical order in the .cabal file
- The solve function should always have type `Integer` unless the problem specifically requires something else