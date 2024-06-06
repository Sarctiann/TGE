# TGE

> \[ Text | Terminal \] Game Engine

An attempt to create a simple text-based game engine,
with the ability to run trough ssh. The general idea is to serve the engine
and respond to the client with a menu to choose the game to play.
TGE should handle a shared state between game/rooms.

Right now we are using
[luabox](https://github.com/Sylviettee/luabox)
which is really simple and easy to use. But more than once we needed to
use
[luv](https://github.com/luvit/luv)
directly to handle the async io. So we possible reimplement the only the parts
we need from luabox.

---

We are currently implementing the engine to work with regular font families
(that are half as wide as they are tall) so a symmetrical unit is represented
by pairs of characters (visually a square).

We cannot rule out the option of using orthogonal fonts (where each character
is equal in width and height). But it's a feature we haven't addressed yet.

## Resources

- [Unicode Characters](https://www.w3.org/TR/xml-entity-names/025.html)
- [Nerd Fonts](https://www.nerdfonts.com/)
- [Square Nerd Font](https://github.com/codeman38/PressStart2P/releases)

## Run it

1. `luarocks init`
1. `luarocks install --only-deps tge-dev-1.rockspec`
1. `./lua examples/main.lua` or `./lua examples/tanky.lua`

> If the file tree has changed, you will need to run
> `luarocks install --only-deps tge-dev-1.rockspec`
> again to update the path.

## [Roadmap](https://trello.com/b/MyqfqI4D/tge-roadmap#)
