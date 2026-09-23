# Notes

Init Project
- Extracted base folder contents
  - Issue with running Main.elm, elm version in proj is 0.19.1, my version is 0.19.2. Updated value in elm.json
- Init github repo at: https://github.com/DrakeB1234/SMUnitFinder
  - Used AI tool to find what contents to add to .gitignore

Task 1
- Created custom type 'UnitState' for states
  - Used https://guide.elm-lang.org/types/custom_types and https://guide.elm-lang.org/error_handling/maybe for reference

- Updated init block with new initial state value of 'IsLoading'

- Updated the update block
  - Ran into error with custom type 'UnitState' while modifiying update block
    - Error was type mismatch, used type 'Model' for 'Success' instead of 'List Unit'
    - Fixed via following compilers errors in IDE
  - Used AI tool to fix another compiler issue with the Success state, which the issue was not using parenthesis around new type.

- Updated the view block
  - Ran into issue trying to access the models state with the conditionals. Can't access model.state.IsLoading within the if statements.
    - Referenced HTTP example from https://elm-lang.org/examples/book, which then I read more about type aliases from https://guide.elm-lang.org/types/type_aliases.
    - Decided to stick with using a record for Model, to allow for easier addition of fields in the future.
  - Used AI tool to find how to access state in viewBody, which I found to be a case statement.
  - Tested various states, Error was done by changing the URL to an invalid one.
    - Made a commit with current state of program after finding no intial issues.


## What I finished

## Decisions I made and why

(Please include how you handled the unrecognized feature in task 2.)

## What I'd do next with more time

## Where I got stuck, and how I got unstuck

## What I'd change about the starter code

## Tools and resources I used

(Docs, search, forums, AI tools. Say where each one helped.)

## Anything else you want us to know
