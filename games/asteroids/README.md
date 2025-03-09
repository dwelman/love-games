# Vector Asteroids

A classic Asteroids game implementation using vector-based rendering in LÖVE.

## Features

- Vector-based rendering for all game elements
- Physics-based movement with momentum and screen wrapping
- Asteroid splitting mechanics
- Player lives and scoring system
- Level progression

## Controls

- **Arrow Keys**: Control the ship
  - **Left/Right**: Rotate the ship
  - **Up**: Thrust forward
- **Space**: Fire weapon
- **Escape**: Return to menu

## Vector Rendering

This game uses LÖVE's drawing primitives to render all game elements as vector shapes, similar to the original arcade game. Each entity is defined by a set of points that are connected to form lines or polygons.

Benefits of vector rendering:
- Clean, crisp lines at any resolution
- Authentic retro arcade feel
- Efficient rendering for simple shapes
- Easy to scale and rotate

## Implementation Details

The game is built using an Entity Component System (ECS) architecture with the following main components:

- **Vector Component**: Defines the shape and appearance of entities
- **Position/Rotation Components**: Handle entity positioning and orientation
- **Velocity Component**: Manages movement physics
- **Collision Component**: Handles collision detection

## Adding Custom Vector Shapes

You can add custom vector shapes by modifying the `VectorShapes` table in `systems/vector_render.lua`. Each shape is defined as a table of points relative to the entity's center.

Example:
```lua
ship = {
    {0, -10},   -- Nose
    {-7, 10},   -- Left corner
    {0, 5},     -- Bottom middle
    {7, 10}     -- Right corner
}
``` 