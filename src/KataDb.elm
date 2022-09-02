module KataDb exposing (kataList)

import Set


kataList =
    [ { url = "https://github.com/emilybache/GildedRose-Refactoring-Kata"
      , tags = Set.fromList [ "Python" ]
      , title = "New Project"
      , commandLine = "python3 -m venv venv"
      }
    , { url = "https://github.com/emilybache/GildedRose-Refactoring-Kata"
      , tags = Set.fromList [ "Python" ]
      , title = "Setup Environment"
      , commandLine = "venv/bin/pip install -r requirements.txt"
      }
    , { url = "https://github.com/emilybache/GildedRose-Refactoring-Kata"
      , tags = Set.fromList [ "JavaScript" ]
      , title = "New Project"
      , commandLine = "npm init"
      }
    ]
