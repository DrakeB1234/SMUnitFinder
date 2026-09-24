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

- Read through Unit.elm and units.json, found the unexpected type that is in features list (empty array) and made note about adding it.
  - features: climate-controlled, elevator, drive-up, ground-floor, wine-storage
- Found out about the relation between the top level statement `module Unit exposing` referring to the getters declared at the end of the file.
- Added new properties to `Interals` record, including a `Features` type to cover values that each feature may contain.
- Adding new fields to decode in decoder
  - Ran into error stating that the decoder was expected 5 args, but got 9.
    - Was able to solve this by using compiler errors and attempting to change method name `map4` to `map8`. Note: research more about maps and how to handle the case of there being more than 8 fields, https://guide.elm-lang.org/effects/json.
      - Found something about checking out `NoRedInk/elm-decode-pipeline` for handling larger JSON objects.
- Ran into error in decoder with promo field, which I set to `Maybe string` to account for its null value.
  - Fixed this by trying similar syntax I have tried earlier, which was wrapping the statement `Decode.maybe` and `Decode.string` in parenthesis, which seemed to sastify the compiler for now.
- Couldn't find how to set the features field decoder up to handle a list, tried referring to json-decode docs, then used AI tool.
  - AI suggested added Unknown String to handle values in features array that may be not defined in the type.
  - Also Suggested to make a custom decoder for the features array, which used a combination of pipes and inline functions. AI used wrong string values for cases, corrected them to match values in units.json.
- Realized a couple of potential issues, first was after reading docs and finding something about `nullable` value in decoders. Second was not being sure if what I had would account for the empty array value in features.
  - Found that elm Decode.list function is already designed to handle empty JSON arrays.
  - Found the solution for the nullable value, which from the docs says returns a `Maybe a` type; used the proper chain of decoder to handle strings AND more explicitly `null` values.
- Creating the getters
  - Following the way the first few getters were made, I was able to create the rest from the new fields I created.
- After all compiler errors were gone in Unit.elm, created a commit.

**How I plan to handle unrecognized features**
- There is the potential for a feature to be added to the JSON array for features that is not accounted for in type, which is handled by its type Unknown string.
- What I plan to do on the frontend is to only display values that are defined in the type, and to ignore unrecognized strings.
  - My thought process behind this is if a feature is listed that isn't available for units, it is best to not show it to a potential customer and have them be surprised when it doesn't actually exist.
- However, on the backend it should be let known of the failed value, as to find out if the units really do have a new feature or if it was a typo in the data.


## What I finished

## Decisions I made and why

(Please include how you handled the unrecognized feature in task 2.)

## What I'd do next with more time

## Where I got stuck, and how I got unstuck

## What I'd change about the starter code

## Tools and resources I used

(Docs, search, forums, AI tools. Say where each one helped.)

## Anything else you want us to know
