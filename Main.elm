module Main exposing (..)

import Html exposing (..)

import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String

-- MODEL

type alias Model =
    { players : List Player
    , name : String
    , playerId : Maybe Int
    , plays : List Play
    }

type alias Player =
    { id : Int
    , name : String
    , points : Int
    }

type alias Play =
    { id : Int
    , playerId : Int
    , name : String
    , points : Int
    }

initModel : Model
initModel =
    { players = []
    , name = ""
    , playerId = Nothing
    , plays = []
    }


-- UPDATE

type Msg
    = Edit Player
    | Score Player Int
    | Input String
    | Save
    | Cancel
    | DeletePlay Play

update : Msg -> Model -> Model
update msg model =
    case msg of
        Input name ->
            { model | name = name }
        
        Cancel ->
            { model | name = "", playerId = Nothing }
        
        Save ->
            if (String.isEmpty model.name) then
                model
            else
                save model
                
        Score player points -> 
            score model player points
        
        Edit player ->
            { model | name = player.name, playerId = Just player.id }
        
        DeletePlay play ->
            deletePlay model play


deletePlay : Model -> Play -> Model
deletePlay model play =
    let
        newPlays = 
            List.filter (\p -> p.id /= play.id) model.plays
        
        newPlayers = 
            List.map 
                (\player ->
                    if player.id == play.playerId then
                        { player | points = player.points - 1 * play.points}
                    else
                        player
                )
                model.players
    in
        { model | plays = newPlays, players = newPlayers }
    

score : Model -> Player -> Int -> Model
score model scorer points =
    let
        newPlayers =
            List.map
                (\player ->
                    if player.id == scorer.id then
                        { player | points = player.points + points }
                    else
                        player
                )
                model.players
        play = 
            Play (List.length model.plays) scorer.id scorer.name points
    in  
        { model | players = newPlayers, plays = play :: model.plays }

-- the save function either adds a new player of changes one
-- if model.playerId is nothing we are in add mode, else we are in edit mode
save : Model -> Model
save model = 
    case model.playerId of
        Just id ->
            edit model id
        
        Nothing ->
            add model


edit : Model -> Int -> Model
edit model id =
    let newPlayers = 
            List.map 
                (\player ->
                    if player.id == id then
                        { player | name = model.name }
                    else
                        player
                )
                model.players
        
        newPlays =
            List.map
                (\play ->
                    if play.playerId == id then
                        { play | name = model.name }
                    else
                        play
                )
                model.plays
    in
        { model
            | players = newPlayers
            , plays = newPlays
            , name = ""
            , playerId = Nothing
        }


add : Model -> Model
add model =
    let
        player =
            Player (List.length model.players) model.name 0
        
        newPlayers = 
            player :: model.players
    in
        { model | players = newPlayers, name = "" }

    
    

-- VIEW

view : Model -> Html Msg
view model =
    div [ class "scoreboard"]
        [ h1 [] [text "Score Keeper"]
        , playerSection model
        , playerForm model
        , playSection model
        , p [] [ text (toString model) ]
        ]

playerSection : Model -> Html Msg
playerSection model =
    div []
        [ playerListHeader
        , playerList model
        , pointsTotal model
        ]
        
playerListHeader : Html Msg
playerListHeader = 
    header []
        [ div [] [text "Name"]
        , div [] [text "Points"]
        ]

playerList : Model -> Html Msg
playerList model =
    -- ul []
    --     (List.map player model.players)
    model.players
        |> List.sortBy .name
        |> List.map (player model.playerId)
        |> ul [] 

player : Maybe Int -> Player -> Html Msg
player editPlayerId player =
    li []
        [ i 
            [ class "edit", onClick (Edit player) ] []
        , div [ class (editPlayerClass editPlayerId player) ]
            [ text player.name ]
        , button
            [ type_ "button", onClick (Score player 2) ]
            [ text "2 pts" ]
        , button
            [ type_ "button", onClick (Score player 3) ]
            [ text "3 pts" ]
        , div []
            [ text (toString player.points) ]
        ]

pointsTotal : Model -> Html Msg
pointsTotal model =
    let
        total =
            List.map .points model.plays
                |> List.sum
    
    in
        footer []
            [ div [] [ text "Total:"]
            , div [] [text (toString total) ]
            ]

playerForm : Model -> Html Msg
playerForm model =
    Html.form [ onSubmit Save ]
        [ input
            [ type_ "text"
            , placeholder "Add/Edit Player..."
            , onInput Input
            , value model.name
            , class (editInputClass model.playerId)
            ]
            []
        , button [ type_ "submit" ] [ text "Save"]
        , button [type_ "button", onClick Cancel ] [ text "Cancel"]
        ]

editInputClass : Maybe Int -> String
editInputClass editPlayerId =
    case editPlayerId of
        Just id ->
            "edit"

        Nothing ->
            ""


editPlayerClass : Maybe Int -> Player -> String
editPlayerClass editPlayerId player =
    case editPlayerId of
        Just id ->
            if player.id == id then
                "edit"
            else
                ""

        Nothing ->
            ""

playSection : Model -> Html Msg
playSection model =
    div []
        [ playListHeader
        , playList model
        ]

playList : Model -> Html Msg
playList model =
    model.plays
        |> List.map play
        |> ul []

play : Play -> Html Msg
play play =
    li []
        [ i
            [ class "remove", onClick (DeletePlay play) ]
            []
            , div [] [ text play.name ]
            , div [] [ text (toString play.points) ]
        ]

playListHeader : Html Msg
playListHeader = 
    header []
        [ div [] [ text "Plays"] 
        , div [] [ text "Points"]
        ]


main : Program Never Model Msg
main = 
    Html.beginnerProgram
        { model = initModel
        , view = view
        , update = update
        }