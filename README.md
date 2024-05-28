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

## Run it

1. `luarocks init`
1. `luarocks install --only-deps tge-dev-1.rockspec`
1. `./lua examples/main.lua` or `./lua examples/tanky.lua`

> If the file tree has changed, you will need to run
> `luarocks install --only-deps tge-dev-1.rockspec`
> again to update the path.

## Roadmap

- [x] Create the game main loop to be able to handle inputs without blocking
      the screen
- [x] Implement the brief queue to schedule the display events
- [x] Implement UI Entities to encapsulate the screen elements

  - [x] _text.lua_ to handle text rendering
  - [x] _unit.lua_ to handle the minimal simetric unit of the screen
  - [x] _sprite.lua_ to handle sprite rendering
  - [x] _line.lua_ to handle lines rendering
  - [x] _box.lua_ to handle boxes rendering

- [x] Implement other kind of entities to the internal engine

  - [x] _seconds_frames.lua_ to handle the time between frames
  - [x] _brief.lua_ to handle the brief to be passed to the queue
  - [x] _boundaries.lua_ to handle the screen boundaries and internal delimited
        areas
  - [x] _point.lua_ to handle the screen positions

- [ ] Implement _secuences_ as a high level API to handle the screen events

  - [x] (WIP) _secuences/sprite_seqs.lua_

  - TODO\*

- [ ] Implement _state.lua_ to handle game state of the running game
- [ ] Implement _loader.lua_ to handle the different scenes, menus, etc. of games
- [ ] Implement _connection.lua_ to handle ssh connections
- [ ] Implement font modes to handle orthogonal fonts
