module KataDb exposing (kataList)

import Set


kataList =
    [ { url = "https://github.com/emilybache/GildedRose-Refactoring-Kata"
      , tags = Set.fromList [ "MultiLang", "Approvals", "Refactoring" ]
      , title = "Gilded Rose"
      }
    , { url = "https://github.com/emilybache/RPG-Combat-Approval-Kata"
      , tags = Set.fromList [ "Java", "Approvals" ]
      , title = "RPG Combat"
      }
    , { url = "https://github.com/ProAgileAB/channels-tests-refactoring-kata"
      , tags = Set.fromList [ "C", "W.I.P" ]
      , title = "Channels - refactor to Test Data Builder pattern"
      }
    , { url = "https://github.com/objarni/AlarmClockKata"
      , tags = Set.fromList [ "C", "Refactoring" ]
      , title = "Alarm Clock (aka Timer Expiry)"
      }
    , { url = "https://github.com/ProAgileAB/tennis-refactoring-kata"
      , tags =
            Set.fromList
                [ "C"
                , "C++"
                , "C#"
                , "Golang"
                , "Java"
                , "Groovy"
                , "Refactoring"
                ]
      , title = "Tennis Score"
      }
    , { url = "https://github.com/objarni/MostRecentlyUsedKata"
      , tags =
            Set.fromList
                [ "DoubleLoopTDD"
                , "TDD"
                , "MultiLang"
                ]
      , title = "Most recently used"
      }
    , { url = "https://github.com/objarni/starter"
      , tags =
            Set.fromList
                [ "MultiLang"
                , "TDD"
                ]
      , title = "Empty starting point"
      }
    , { url = "https://github.com/objarni/VendingMachine-Approval-Kata"
      , tags =
            Set.fromList
                [ "C"
                , "C++"
                , "Python"
                , "Approvals"
                ]
      , title = "Vending machine receipt printer"
      }
    ]
