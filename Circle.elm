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


generator : Float -> Generator Circle
generator max =
    Random.map2 Circle (pointGenerator max) colorGenerator


pointGenerator : Float -> Generator Point
pointGenerator max =
    Random.map2 Point (Random.float 0 max) (Random.float 0 max)


colorGenerator : Generator Color
colorGenerator =
    Random.map3 Color.rgb255 (Random.int 0 255) (Random.int 0 255) (Random.int 0 255)
