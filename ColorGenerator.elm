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
