# Unit Finder

Hi Drake,

Thanks for making time for this. This is a small Elm app that shows a list of storage units. It already runs. Your job is to take it from "technically works" to something a customer could actually use.

We know Elm is new to you. That's on purpose. We aren't looking for polished Elm. We want to see how you pick up something unfamiliar, how you make decisions, and how you explain them.

## Time

Please turn in by the timeline designated in the email.
If you run out of time, stop and tell us in `NOTES.md` what you'd do next. Unfinished work with clear notes is a good outcome.

## Getting started

1. Install Elm: https://guide.elm-lang.org/install/elm.html
2. From this folder, run:

   ```
   elm reactor
   ```

3. Open http://localhost:8000/src/Main.elm

You should see a list of units with a name and a size. If you get stuck on setup, email me. Setup problems are my problem, not yours.

## What's here

```
data/units.json   the unit data the app loads
src/Main.elm      the app: model, update, view
src/Unit.elm      the Unit type and its JSON decoder
src/Style.elm     a small starter stylesheet
NOTES.md          your notes for us (please fill this in)
```

## The tasks

Do them in order. Tasks 1 through 4 are the core. Task 5 is optional.

### 1. Make impossible states impossible

Look at `Model` in `Main.elm`. It uses `isLoading`, `error`, and `units` as separate fields. That means the model can say "loading" and "failed" at the same time, which makes no sense.

Replace those fields with a custom type that can only be in one real state at a time. Then update `init`, `update`, and `view` to match.

While you're there, make the error state helpful. "Something went wrong" doesn't tell a customer anything. Show a clear message and give them a way to try again.

Tip: to see your error state, temporarily rename `data/units.json` and reload.

### 2. Decode the rest of the data

`Unit.elm` only decodes four fields. The JSON has more. Add these:

- `monthlyRateCents`: the price, in cents
- `available`: whether the unit can be rented right now
- `promo`: a promotion, or `null` when there isn't one
- `features`: a list of feature names

Add a getter function for each one, like the ones already in the file.

For `features`, decode them into a custom type instead of leaving them as strings. One unit has a feature you won't expect. Decide how the app should handle a feature it doesn't recognize, and explain your choice in `NOTES.md`. There's no single right answer here.

### 3. Build a real unit card

Update `viewUnit` so each card shows what a customer needs to decide:

- Size, written the way a person would read it, plus square feet
- Monthly price, formatted like `$129/mo`
- Features
- The promo, when there is one
- Units that aren't available should look clearly different and shouldn't read like something you can rent

How it looks is up to you.

### 4. Filter and sort

Add controls above the list so a customer can narrow things down:

- Filter by size: Small (under 50 sq ft), Medium (50 to 150 sq ft), Large (over 150 sq ft), or any size
- Show only climate-controlled units
- Sort by price, low to high or high to low

Show how many units match, like "Showing 4 of 12 units." If nothing matches, show a friendly empty state instead of a blank page.

Everything here should work with a keyboard and a screen reader.

### 5. Optional, only if you have time

Pick one. Don't try to do them all.

- Let a customer select a unit and see a detail view with a "Reserve" button
- Add a short reserve form (name, email, move-in date) with validation and clear error messages
- Write a few tests for your filter and sort logic with `elm-test`

## What we're looking at

- Does it work, and does it make sense to a customer?
- Did you use Elm's types to prevent bugs, especially in tasks 1 and 2?
- Is the code easy for a teammate to read?
- Do your notes explain your thinking, including what you'd change?

We are **not** grading how much you finished, or whether your Elm looks like an expert wrote it.
We are not overly concerned with style or design layout, as that is not the main focus of this exercise.

## Resources

You can use anything you'd use on the job: docs, search, forums, and AI tools.
Please avoid using AI to write the entire solution for you.
Just tell us in `NOTES.md` what you used and where. We'll walk through the code together afterward, so make sure you understand everything you turn in.

- The official guide: https://guide.elm-lang.org
- Package docs: https://package.elm-lang.org
- Elm Slack, #beginners channel: https://elm-lang.org/community/slack

## Turning it in

Put the project in a Git repo (preferred) and send us a link.
Commit as you go if you can. We like seeing how the work came together.
Optionally, email us a compressed zip of the folder (without `elm-stuff`).

After that, we'll set up about 45 minutes to walk through it with you. Come ready to show us what you built and talk about the choices you made.

Have fun with it.
