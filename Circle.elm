module Circle exposing (Circle, draw, generator)

import Svg exposing (Svg)
import Svg.Attributes
import Color exposing (Color)
import Random exposing (Generator)


type alias Circle =
    { center : Point, color : Color }


type alias Point =
    { x : Float, y : Float }


draw : Float -> Circle -> Svg msg
draw radius circle =
    Svg.circle
        [ Svg.Attributes.r (toString radius)
        , Svg.Attributes.cx (toString circle.center.x)
        , Svg.Attributes.cy (toString circle.center.y)
        , Svg.Attributes.fill (rgba circle.color)
        ]
        []


rgba : Color -> String
rgba color =
    let
        { red, green, blue, alpha } =
            Color.toRgb color
    in
        "rgba(" ++ toString red ++ "," ++ toString green ++ "," ++ toString blue ++ "," ++ toString alpha ++ ")"


generator : Float -> Generator Circle
generator max =
    Random.map2 Circle (pointGenerator max) colorGenerator


pointGenerator : Float -> Generator Point
pointGenerator max =
    Random.map2 Point (Random.float 0 max) (Random.float 0 max)


colorGenerator : Generator Color
colorGenerator =
    Random.map3 Color.rgb (Random.int 0 255) (Random.int 0 255) (Random.int 0 255)
