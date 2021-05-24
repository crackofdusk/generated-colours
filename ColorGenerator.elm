module ColorGenerator exposing (..)

import Color exposing (Color)
import Random exposing (Generator)


saturationAndLightness : Color -> Generator Color
saturationAndLightness baseColor =
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


hueAndSaturation : Color -> Generator Color
hueAndSaturation baseColor =
    let
        { hue, saturation, lightness, alpha } =
            Color.toHsla baseColor
    in
    Random.map2
        (\hueDeviation saturationDeviation ->
            Color.fromHsla
                { hue = hue + hueDeviation
                , saturation = saturation + saturationDeviation
                , lightness = lightness
                , alpha = alpha
                }
        )
        (Random.float -0.1 0.1)
        (Random.float -0.4 0.4)


hueAndLightness : Color -> Generator Color
hueAndLightness baseColor =
    let
        { hue, saturation, lightness, alpha } =
            Color.toHsla baseColor
    in
    Random.map2
        (\hueDeviation lightnessDeviation ->
            Color.fromHsla
                { hue = hue + hueDeviation
                , saturation = saturation
                , lightness = lightness + lightnessDeviation
                , alpha = alpha
                }
        )
        (Random.float -0.1 0.1)
        (Random.float -0.3 0.3)


randomRGB : Generator Color
randomRGB =
    Random.map3 Color.rgb255
        (Random.int 0 255)
        (Random.int 0 255)
        (Random.int 0 255)


saturationOnly : Color -> Generator Color
saturationOnly baseColor =
    let
        { hue, lightness, alpha } =
            Color.toHsla baseColor
    in
    Random.map
        (\saturation ->
            Color.fromHsla
                { hue = hue
                , saturation = saturation
                , lightness = lightness
                , alpha = alpha
                }
        )
        (Random.float 0 1)


lightnessOnly : Color -> Generator Color
lightnessOnly baseColor =
    let
        { hue, saturation, alpha } =
            Color.toHsla baseColor
    in
    Random.map
        (\lightness ->
            Color.fromHsla
                { hue = hue
                , saturation = saturation
                , lightness = lightness
                , alpha = alpha
                }
        )
        (Random.float 0 1)


hueOnly : Color -> Generator Color
hueOnly baseColor =
    let
        { hue, saturation, lightness, alpha } =
            Color.toHsla baseColor
    in
    Random.map
        (\hueDeviation ->
            Color.fromHsla
                { hue = hue + hueDeviation
                , saturation = saturation
                , lightness = lightness
                , alpha = alpha
                }
        )
        (Random.float -0.05 0.05)
