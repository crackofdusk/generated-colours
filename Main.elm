module Main exposing (..)

import Browser
import Circle exposing (Circle)
import Color exposing (Color)
import ColorGenerator
import Html exposing (Html, text)
import Html.Attributes
import Random exposing (Generator)
import Svg exposing (Svg)
import Svg.Attributes



-- MODEL


type alias Model =
    { variations : List Variation }


type alias Variation =
    { name : String
    , circles : List Circle
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { variations = [] }
    , Random.generate VariationsGenerated variationsGenerator
    )



--- GENERATORS


colorGenerators : Color -> List ( String, Generator Color )
colorGenerators color =
    [ ( "Lightness", ColorGenerator.lightnessOnly color )
    , ( "Saturation", ColorGenerator.saturationOnly color )
    , ( "Hue", ColorGenerator.hueOnly color )
    , ( "Alpha", ColorGenerator.alphaOnly color )
    , ( "Saturation and lightness", ColorGenerator.saturationAndLightness color )
    , ( "Hue and saturation", ColorGenerator.hueAndSaturation color )
    , ( "Hue and lightness", ColorGenerator.hueAndLightness color )
    , ( "Hue and alpha", ColorGenerator.hueAndAlpha color )
    , ( "Random RGB (no base colour)", ColorGenerator.randomRGB )
    ]


variationsGenerator : Generator (List Variation)
variationsGenerator =
    colorGenerators baseColor
        |> List.map
            (\tuple ->
                variationGenerator (Tuple.first tuple) (Tuple.second tuple)
            )
        |> combineGenerators


variationGenerator : String -> Generator Color -> Generator Variation
variationGenerator name colorGenerator =
    Random.map
        (\circles -> Variation name circles)
        (circlesGenerator colorGenerator)


circlesGenerator : Generator Color -> Generator (List Circle)
circlesGenerator colorGenerator =
    Random.list numberOfCircles
        (Circle.generator
            { canvasWidth = canvasWidth
            , minRadius = minRadius
            , maxRadius = maxRadius
            , colorGenerator = colorGenerator
            }
        )


combineGenerators : List (Generator a) -> Generator (List a)
combineGenerators generators =
    case generators of
        [] ->
            Random.constant []

        g :: gs ->
            Random.map2 (::) g (combineGenerators gs)



-- UPDATE


type Msg
    = VariationsGenerated (List Variation)


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        VariationsGenerated variations ->
            ( { model | variations = variations }, Cmd.none )



-- VIEW


view : Model -> Html msg
view model =
    Html.div
        [ Html.Attributes.style "padding" "2rem"
        , Html.Attributes.style "font-family" "monospace"
        , Html.Attributes.style "font-size" "1.25rem"
        , Html.Attributes.style "color" "#333"
        ]
        [ Html.h1
            [ Html.Attributes.style "margin" "0" ]
            [ Html.text "Study of generated colours" ]
        , Html.p []
            [ Html.a
                [ Html.Attributes.href "https://github.com/crackofdusk/generated-colours" ]
                [ Html.text "Source code" ]
            ]
        , Html.div [ Html.Attributes.style "margin-top" "3rem" ]
            [ Html.h2
                [ Html.Attributes.style "margin" "0 0 1rem 0" ]
                [ Html.text "Base colour" ]
            , viewColor baseColor
            ]
        , Html.div
            [ Html.Attributes.style "margin-top" "3rem" ]
            [ Html.h2
                [ Html.Attributes.style "margin" "0" ]
                [ Html.text "Variations" ]
            , Html.div
                [ Html.Attributes.style "display" "flex"
                , Html.Attributes.style "flex-wrap" "wrap"
                , Html.Attributes.style "gap" "2rem"
                , Html.Attributes.style "margin-top" "1rem"
                ]
                (List.map viewVariation model.variations)
            ]
        ]


viewColor : Color -> Html msg
viewColor color =
    let
        { hue, saturation, lightness, alpha } =
            Color.toHsla color
    in
    Html.div
        [ Html.Attributes.style "display" "flex"
        , Html.Attributes.style "flex-wrap" "wrap"
        , Html.Attributes.style "gap" "1rem"
        ]
        [ Html.div
            [ Html.Attributes.style "background-color" (Color.toCssString color)
            , Html.Attributes.style "width" "5rem"
            , Html.Attributes.style "height" "5rem"
            ]
            []
        , Html.div
            [ Html.Attributes.style "font-size" "1rem"
            , Html.Attributes.style "line-height" "1.25rem"
            ]
            [ Html.div [] [ Html.text ("Hue: " ++ percentString hue) ]
            , Html.div [] [ Html.text ("Saturation: " ++ percentString saturation) ]
            , Html.div [] [ Html.text ("Lightness: " ++ percentString lightness) ]
            , Html.div [] [ Html.text ("Alpha: " ++ percentString alpha) ]
            ]
        ]


percentString : Float -> String
percentString n =
    String.fromInt (round (n * 100)) ++ "%"


viewVariation : Variation -> Html msg
viewVariation variation =
    Html.figure
        [ Html.Attributes.style "margin" "0"
        ]
        [ variation.circles
            |> List.map Circle.draw
            |> canvas canvasWidth
        , Html.figcaption [] [ Html.text variation.name ]
        ]


minRadius : Float
minRadius =
    20


maxRadius : Float
maxRadius =
    50


canvasWidth : Float
canvasWidth =
    400


numberOfCircles : Int
numberOfCircles =
    150


baseColor : Color
baseColor =
    Color.fromHsla
        { hue = 0.1
        , saturation = 0.85
        , lightness = 0.5
        , alpha = 1
        }


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
