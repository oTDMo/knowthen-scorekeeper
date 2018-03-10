# Planning Bascketball Scorekeeper App

## Model

TODO: Model's Shape

''''
Model = 
    { players : List Player
    , playerName : String
    , playerId : Maybe Int
    , plays : List Play
    }
''''

TODO: Player Shape

Player =
    { id : Int
    , name : String
    , points : Int
    }


TODO: Play Shape

Play =
    { id : Int
    , playerId : Int
    , name : String
    , points : Int
    }


TODO : Initial Model


## Update
What things can be done in the app?
    * Edit
    * Score
    * Input
    * Save
    * Cancel
    * Delete

TODO: Create Message Union Type

TODO: Create Update Function(s)


## View
What are the Logical Sections/Groupings of the UI?
    * main view (outermost function)
        * player section
            * player list header
            * player list
                * player
            * point total
        * player form
        * play section
            * play list header
            * play list
                * play

TODO: Create Functions for Each of the Above