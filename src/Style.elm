module Style exposing (stylesheet)

{-| A small starter stylesheet so the page isn't bare.

Change anything you like. You can also swap this out for your own
approach if you have one you prefer.

-}

import Html exposing (Html)


stylesheet : Html msg
stylesheet =
    Html.node "style" [] [ Html.text css ]


css : String
css =
    """
* { box-sizing: border-box; }

body {
  margin: 0;
  font-family: system-ui, -apple-system, "Segoe UI", Roboto, sans-serif;
  color: #1a1a1a;
  background: #f6f7f9;
}

.page {
  max-width: 960px;
  margin: 0 auto;
  padding: 2rem 1rem;
}

.unit-list {
  list-style: none;
  padding: 0;
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(400px, 1fr));
  gap: 1rem;
}

.unit-card {
  background: #fff;
  border: 1px solid #d9dde3;
  border-radius: 8px;
  padding: 1rem;
}

.unit-card h2 {
  margin: 0 0 0.5rem;
  font-size: 1.125rem;
}

:focus-visible {
  outline: 3px solid #1f5fbf;
  outline-offset: 2px;
}
"""
