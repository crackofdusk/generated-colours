# Study of generated colours

I had a demo with randomly positioned circles with random colours. I didn't like the generated colours so I set it aside. Three years later I stumbled upon an [article about colour variations](https://sighack.com/post/procedural-color-algorithms-color-variations). It inspired me to try the presented techniques in this demo.

## Lessons learned

- Randomly generating the red, green an blue colour channels makes colours that don't go well together
- [Analogous colours](https://en.wikipedia.org/wiki/Analogous_colors) combine well
- Colour models like HSL that represent the hue component separately make it easier to generate variations than the RGB model

## Development

Install [elm](https://elm-lang.org/).

Start the elm reactor:

```
elm reactor
```

Open <http://localhost:8000/Main.elm>.
