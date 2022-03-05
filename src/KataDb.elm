module KataDb exposing (kataList)

import Set


kataList =
    [ { url = "https://github.com/emilybache/GildedRose-Refactoring-Kata"
      , tags = Set.fromList [ "MultiLang", "Approvals", "Refactoring", "TestDesign" ]
      , title = "Gilded Rose"
      }
    , { url = "https://github.com/emilybache/RPG-Combat-Approval-Kata"
      , tags = Set.fromList [ "Java", "Approvals", "TestDesign" ]
      , title = "RPG Combat"
      }
    , { url = "https://github.com/ProAgileAB/channels-tests-refactoring-kata"
      , tags = Set.fromList [ "C", "Refactoring", "TestDesign" ]
      , title = "Channels - Test Data Builder pattern"
      }
    , { url = "https://github.com/objarni/AlarmClockKata"
      , tags = Set.fromList [ "C", "Refactoring" ]
      , title = "Alarm Clock (aka Timer Expiry)"
      }
    , { url = "https://sammancoaching.org/kata_descriptions/calc_stats.html"
      , tags = Set.fromList [ "MultiLang"
                            , "TDD"
                            , "ProblemDescriptionOnly"
                            ]
      , title = "CalcStats"
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
                [ "ATDD"
                , "TDD"
                , "MultiLang"
                , "ProblemDescriptionOnly"
                ]
      , title = "Most recently used"
      }
    , { url = "https://sammancoaching.org/kata_descriptions/string_calculator.html"
      , tags =
            Set.fromList
                [ "TDD"
                , "MultiLang"
                , "ProblemDescriptionOnly"
                ]
      , title = "String Calculator"
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
                , "TestDesign"
                ]
      , title = "Vending machine receipt printer"
      }
    ]
