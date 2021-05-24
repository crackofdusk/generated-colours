module Circle exposing (Circle, draw, generator)

import Color exposing (Color)
import Random exposing (Generator)
import Svg exposing (Svg)
import Svg.Attributes


type alias Circle =
    { center : Point, color : Color }


type alias Point =
    { x : Float, y : Float }


draw : Float -> Circle -> Svg msg
draw radius circle =
    Svg.circle
        [ Svg.Attributes.r (String.fromFloat radius)
        , Svg.Attributes.cx (String.fromFloat circle.center.x)
        , Svg.Attributes.cy (String.fromFloat circle.center.y)
        , Svg.Attributes.fill (rgba circle.color)
        ]
        []


rgba : Color -> String
rgba color =
    Color.toCssString color


generator : Float -> Color -> Generator Circle
generator max baseColor =
    Random.map2 Circle (pointGenerator max) (colorGenerator baseColor)


pointGenerator : Float -> Generator Point
pointGenerator max =
    Random.map2 Point (Random.float 0 max) (Random.float 0 max)


colorGenerator : Color -> Generator Color
colorGenerator baseColor =
    let
        { hue, saturation, lightness, alpha } =
            Color.toHsla baseColor
    in
    Random.map2
        (\saturationDeviation lightnessDeviation ->
            Color.fromHsla
                { hue = hue
                , saturation = saturation + saturationDeviation
                , lightness = lightness + lightnessDeviation
                , alpha = alpha
                }
        )
        (Random.float -0.15 0.15)
        (Random.float -0.4 0.4)
