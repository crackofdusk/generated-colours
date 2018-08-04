module Main exposing (..)

import Html exposing (Html, text)
import Html.Attributes
import Svg exposing (Svg)
import Svg.Attributes
import Random exposing (Generator)
import Circle exposing (Circle)


-- MODEL


type alias Model =
    { circles : List Circle }


init : ( Model, Cmd Msg )
init =
    ( { circles = [] }
    , Random.generate CirclesGenerated circlesGenerator
    )


circlesGenerator : Generator (List Circle)
circlesGenerator =
    Random.list numberOfCircles (Circle.generator canvasWidth)



-- UPDATE


type Msg
    = CirclesGenerated (List Circle)


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        CirclesGenerated circles ->
            ( { model | circles = circles }, Cmd.none )



-- VIEW


view : Model -> Html msg
view model =
    model.circles
        |> List.map (Circle.draw radius)
        |> canvas canvasWidth
        |> container


radius : Float
radius =
    100


canvasWidth : Float
canvasWidth =
    1000


numberOfCircles : Int
numberOfCircles =
    100


container : Html msg -> Html msg
container element =
    Html.div
        [ Html.Attributes.style
            [ ( "display", "flex" )
            , ( "justify-content", "center" )
            , ( "align-items", "center" )
            , ( "height", "100%" )
            ]
        ]
        [ element ]


canvas : Float -> List (Svg msg) -> Svg msg
canvas size elements =
    Svg.svg
        [ Svg.Attributes.viewBox ("0 0 " ++ toString size ++ " " ++ toString size)
        , Svg.Attributes.width (toString size)
        , Svg.Attributes.height (toString size)
        ]
        elements



-- MAIN


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
