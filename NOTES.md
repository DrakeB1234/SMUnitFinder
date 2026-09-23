# Notes

### Init Project
- Extracted base folder contents
  - Issue with running Main.elm, elm version in proj is 0.19.1, my version is 0.19.2. Updated value in elm.json
- Init github repo at: https://github.com/DrakeB1234/SMUnitFinder
  - Used AI tool to find what contents to add to .gitignore

### Task 1

**Created custom type 'UnitState' for states**
- Used https://guide.elm-lang.org/types/custom_types and https://guide.elm-lang.org/error_handling/maybe for reference

**Updated init block with new initial state value of 'IsLoading'**
- Inital error was found and fixed via compiler warnings.

**Updated the update block**
- Ran into error with custom type 'UnitState' while modifiying update block
  - Error was type mismatch, used type 'Model' for 'Success' instead of 'List Unit'
  - Fixed via following compilers errors in IDE
- Used AI tool to fix another compiler issue with the Success state, which the issue was not using parenthesis around new type.

**Updated the view block**
- Ran into issue trying to access the models state with the conditionals. Can't access model.state.IsLoading within the if statements.
  - Referenced HTTP example from https://elm-lang.org/examples/book, which then I read more about type aliases from https://guide.elm-lang.org/types/type_aliases.
  - Decided to stick with using a record for Model, to allow for easier addition of fields in the future.
- Used AI tool to find how to access state in viewBody, which I found to be a case statement.
- Tested various states, Error was done by changing the URL to an invalid one.
  - Made a commit with current state of program after finding no intial issues.
- *SUMMARY OF CHANGES*:
  - Created a way to display the states from the model using the new custom type.

**More helpful error messages**
- Looked into docs for http package https://package.elm-lang.org/packages/elm/http/latest/Http, found the types that can result from `Http.Error`.
- Created a case for arg returned from `Http.Error` in viewBody.
  - Ran into issue with trying to use a 'Int' type as string for the p text. Used method String.fromInt to return a usable string.
- Decided on which error types should be more descriptive to the end user, for example a BadUrl in this case would be at fault of the program, so I kept that error message vague.
- Used AI tool to decide on how to better layout the HTML. Decided on using a "component" for displaying the error message, and always showing a retry button in any error case.
  - Refactored the case statement into this new component, as the retry button will always display no matter the error.
- Ran into issue with viewErrorMessage component stating a type mismatch for my case of `Http.BadStatus status`
  - Used AI tool to diagnose issue, which was a syntax issue of using additional colon; fixed addtional syntax issue with missing parenthesis around viewErrorMessage call.
- Looked into why `Html.p` etc. was being used. Found a more explicit way of exposing specific elements through top-level html imports. 
  - Solution found through previous AI reponse; looking at the top level imports section.
- Used IDE to import missing import for onClick event.
- Using example book example through elm site, I was able to add another type to the union for Msg, add the Retry case, update the model, and call fetchUnits again.
  - Tested for proper functionality by temporarily using Cmd.None to see the function call work through the view.
- *SUMMARY OF CHANGES*:
  - Using Http.Error types, I was able to create a "component" to display an error message to the end-user for more descriptive error messages. Created a way for the user to retry fetching, which required adding in type to Msg and addtional case for Retry in update block.

### Task 2 


## What I finished

## Decisions I made and why

(Please include how you handled the unrecognized feature in task 2.)

## What I'd do next with more time

## Where I got stuck, and how I got unstuck

## What I'd change about the starter code

## Tools and resources I used

(Docs, search, forums, AI tools. Say where each one helped.)

## Anything else you want us to know
