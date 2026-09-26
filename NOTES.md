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

### Task 3

- Decided on just displaying each piece of data on the unit card to start with.
  - Was able to get fields `monthlyRateCents and available` to display without issue.

**Displaying the promo field**
- Got stuck on trying to parse the promos Maybe type in the view.
  - Found a snippet at https://discourse.elm-lang.org/t/can-i-compose-a-view-with-a-number-of-maybe-components-in-a-more-efficient-way/4145
  - With this, created a component `viewUnitPromo` with Maybe String parameter
  - At first didn't know what to return for `Nothing` case, but found snippet used `text ""`, which seemed to work (didn't create a empty p element like I initially thought).

**Displaying the features list**
- Got stuck on trying to list features in view.
  - Found a snippet on stackoverflow https://stackoverflow.com/questions/24004569/elm-how-do-i-display-a-list-of-strings-in-an-html-list
  - Created a new view 'component' `viewUnitFeatures` and tried applying solutions from resource
  - Changed parameter type to `Features`, which I was able to expose in `Unit.elm` (found out after looking how the Unit type was exposed in `Main.elm`)
- Had type mismatch error `Expected 'List String' found 'List Features'` in new view component. 
  - Used AI tool to diagnose issue
    - First issue was only exposing the type name `Features` in the export / import statements in `Main/Unit.elm`. Fix was `Features(..)`.
    - With newly exposed feature variants, able to create a helper to convert feature variants into string values.
    - Updated `viewUnitFeatures` to use new helper and added it into the main `viewUnit` component.
- Decided to return an empty string for the Unknown variant case to ensure a bad value is shown to the user of the site.
  - Explained reasoning in section titled *How I plan to handle unrecognized features*

- Created a commit once I had successfully displayed all new fields onto the card.

**Formatting data**

- Found https://github.com/Chadtech/elm-money package to find a potential solution to formatting `monthlyRateCents`, but couldn't find an example in there source for me to use.
  - Created a helper, but got stuck on how to parse the data.
  - Used AI tool to find out how to format the data
    - Used `let` to create multiple variables.
    - `dollars` used integer division `//`, which the reasoning from the AI was that Elm does not have a built-in `toFixed` method for floats.
    - `centsRemainder` used `remainderBy` and `String.padLeft` to format the decimals place.
  - Realized that the requested format was '$129/mo', without the decimals place.
    - This simplified the helper to just using simple integer division.

- For the readable storage unit sizes, I was unsure of the typical format used.
  - I viewed units on storage-mart.com and saw some examples of the cards used there.
    - Also took screenshot of card overall design / layout.
  - Format being used was '5'w x 5'd x 8'h' and in span '25 sq ft (200 cu ft)'
  - Heights are not defined in data, so just width x length (diameter) will be displayed in this case.
- Got started on helper for showing unit size using two parameters 'widthFeet' and 'lengthFeet'.
  - Was going to use `let` and `in` for calculating squareFeet, but then remembered that that was already calculated on the `Unit` record. Added squareFeet as an additional param in helper.
  - Following the markup using on storage-mart.com, I created the html elements following how it is laid out on the actual website.

- Changed the CSS with the cards sizing, changing the minmax function to `minmax(400px, 1fr)" for more space in cards on desktop. Still responsive due to grid layout on mobile.

- Displaying if a unit is available
  - On storage mart, it seems to make it clear if a unit is available or not, they will either display the price / promor OR 'SOLD OUT'
  - Created component `viewUnitPriceAvailable` to handle these cases.
  - Changed parameter to `Unit` due to needing more than four fields from it.

### Task 4

**Starting with markup**
- I decided with writing markup first to have a way to test the filtering functions that I will later create.
  - Used similar markup to https://storage-mart.com for their filter.
  - Moved all markup into component `viewUnitFilter` and applied styling for filter.
  - Thought to move the checkbox markup into a smaller component to reduce repeated code, but wouldn't know how to handle passing functions as parameters, skipped for now.

**Writing the filter logic**
- Looking back through the Main.elm file, I see the entire unit list is feed through the `viewBody` component. Chances are I would either feed the filtered results through here, or in the `viewUnit` component itself.
- Reading through docs for *elm/core List*, I found that it does have a `List.filter` function, which could be needed for the filter logic.
- Tried to write a filter helper, but couldn't find / understand a solution through searching through elm discuss forms / web searching.
- Used AI tool for a potential solution.
  - First created a SizeFilter type, to ensure that only one filter can be applied at a time.
  - Added  `sizeFilter` and `climateOnly` to model and init blocks (`climateOnly` is a bool, but could later be switched to type for more filtering options.)
  - Added types `FilterSize` and `ToggleClimateFilter` to Msg and added new functions into update block.
  - Changed `viewUnitFilter` to accept the model, then set the climate checkbox attributes to accept the `climateOnly` variable and to call the `ToggleClimateFilter` function `onCheck`.
  - Implemented the `unitFilter` helper to filter by climate controlled units. Size filter is not written yet.
  - Finally, used the `unitFilter` helper into `viewBody` component to filter units before they are displayed in `viewUnit`. With testing, the checkbox would only show units that were climate controlled when toggled.
- Implementing unit size filter
  - Used attributes and `onClick` event in size filter checkboxes, then tried to implement the size filtering in helper `unitFilter`
  - Had trouble intially trying to write the logic for filtering sizes, but after looking down through the helper, I realized that I am testing *each* list item through `List.filter`, was able to use this to write simple checks of square feet for each size filter case.

**Writing the Sort Logic**
- Started by creating the markup and styling, creating a `viewUnitSort` component.
  - Used https://dribbble.com/shots/2484536-Sort-by as a resource for UI, decided to use a *select* element for a11y and single active selection.
- Thought that my code code be better organized, looked through file and decided to sort by *filter and sort helpers* and *unit components* using comments.
- Using a similar process as I did for the filtering, created sort type, then added it to model, init, and update blocks.
- Referring to docs for List, I found the `sortBy` list function, which I used in new `unitSort` helper.
  - Decided on using case statements, as this function didn't need the more complex ordering that the filter helper required; sorted by monthlyRateCents, which after testing, correctly sorted by price low to high.
- Got stuck on the *price high to low* sorting logic, intially tried to use `List.sortWith` and its example of a comparsion helper in docs.
  - Used AI tool to fix the issue.
    - There were two options, one with a simple sortBy then reverse, and a compare function (like I had previously tried) but using the proper typing signature as I was comparing the entire Unit record instead of its 'monthlyRateCents` field.
    - I stuck with the sort then reverse, as it was simple and was easy to read / understand.
- Testing the sorting
  - I had not yet wired up the select element, so I just changed the init value for `unitSort` to try all type variants. After testing, each option seemed to work as expected.
- Wiring up the select element
  - The previous AI prompt had a solution, but I wanted to check online for how others handled this. Found resource: https://stackoverflow.com/questions/37376509/work-with-elm-and-select.
  - I found the stackoverflow answer helpful, but liked how the previous AI response handled the raw string parsing in a separate helper RATHER than in the update block. I was also able to fix the compiler issue of missing cases by adding a wildcard case at the end in helper `handleUnitSortString`.
  - Tested the sorting through the select element, and everything seemed to be working and is wired up correctly.

**Displaying the amount of units shown**
- Sticking with the use of components, I created a `viewAmountOfUnits` component to display to the user the amount of *shown* units and *total* units.
- Found a way to test empty state by modifying the filter helper to return `False` in one case. This component would display "Showing 0 of 12 units." when no units are found.
- *Potential future issue* I question my current approach due to having to call the filter method for one of the params of the `viewAmountOfUnits` component AND also having to use it for the `viewUnit` component.
  - The problem with this is if the filtering logic were to change, now two places would require refactoring. If I have time to find a better alternative, I will apply and document it.

**More testing of different states between filtering and sorting**
- I realized that I forgot to account for filtering THEN sorting the resulting list. Before I had just tested the sorting on the default filtering options.

## What I finished

## Decisions I made and why

(Please include how you handled the unrecognized feature in task 2.)

## What I'd do next with more time

## Where I got stuck, and how I got unstuck

## What I'd change about the starter code

## Tools and resources I used

(Docs, search, forums, AI tools. Say where each one helped.)

## Anything else you want us to know
