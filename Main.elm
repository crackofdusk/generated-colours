module Main exposing (..)

import Browser
import Circle exposing (Circle)
import Color exposing (Color)
import Html exposing (Html, text)
import Html.Attributes
import Random exposing (Generator)
import Svg exposing (Svg)
import Svg.Attributes



-- MODEL


type alias Model =
    { circles : List Circle }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { circles = [] }
    , Random.generate CirclesGenerated circlesGenerator
    )


circlesGenerator : Generator (List Circle)
circlesGenerator =
    Random.list numberOfCircles
        (Circle.generator
            { canvasWidth = canvasWidth
            , minRadius = minRadius
            , maxRadius = maxRadius
            , baseColor = baseColor
            }
        )



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
        |> List.map Circle.draw
        |> canvas canvasWidth
        |> container


minRadius : Float
minRadius =
    30


maxRadius : Float
maxRadius =
    50


canvasWidth : Float
canvasWidth =
    800


numberOfCircles : Int
numberOfCircles =
    400


baseColor : Color
baseColor =
    Color.fromHsla
        { hue = 0.1
        , saturation = 0.85
        , lightness = 0.5
        , alpha = 1
        }


container : Html msg -> Html msg
container element =
    Html.div
        [ Html.Attributes.style "display" "flex"
        , Html.Attributes.style "justify-content" "center"
        , Html.Attributes.style "align-items" "center"
        , Html.Attributes.style "height" "100vh"
        ]
        [ element ]


canvas : Float -> List (Svg msg) -> Svg msg
canvas size elements =
    Svg.svg
        [ Svg.Attributes.viewBox ("0 0 " ++ String.fromFloat size ++ " " ++ String.fromFloat size)
        , Svg.Attributes.width (String.fromFloat size)
        , Svg.Attributes.height (String.fromFloat size)
        ]
        elements



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
