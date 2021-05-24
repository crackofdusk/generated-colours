module Circle exposing (Circle, draw, generator)

import Color exposing (Color)
import Random exposing (Generator)
import Svg exposing (Svg)
import Svg.Attributes


type alias Circle =
    { center : Point, radius : Float, color : Color }


type alias Point =
    { x : Float, y : Float }


draw : Circle -> Svg msg
draw circle =
    Svg.circle
        [ Svg.Attributes.r (String.fromFloat circle.radius)
        , Svg.Attributes.cx (String.fromFloat circle.center.x)
        , Svg.Attributes.cy (String.fromFloat circle.center.y)
        , Svg.Attributes.fill (rgba circle.color)
        ]
        []


rgba : Color -> String
rgba color =
    Color.toCssString color


generator :
    { canvasWidth : Float
    , minRadius : Float
    , maxRadius : Float
    , baseColor : Color
    , colorGenerator : Color -> Generator Color
    }
    -> Generator Circle
generator { canvasWidth, minRadius, maxRadius, baseColor, colorGenerator } =
    Random.map3 Circle
        (pointGenerator canvasWidth)
        (radiusGenerator minRadius maxRadius)
        (colorGenerator baseColor)


pointGenerator : Float -> Generator Point
pointGenerator max =
    Random.map2 Point (Random.float 0 max) (Random.float 0 max)


radiusGenerator : Float -> Float -> Generator Float
radiusGenerator min max =
    Random.float min max
