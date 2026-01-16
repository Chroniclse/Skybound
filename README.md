# Skybound

A 2D action game built with Godot 4.5, featuring combat, exploration, and multiple levels to conquer.

## Overview

Skybound is a top-down action game where players navigate through various levels, defeat enemies, and progress through a cyberpunk-inspired world. The game features a lobby hub area, level selection system, and interactive elements throughout.

## Features

- **Player Combat System**: Attack enemies with melee combat
- **Health System**: Track player health with heart-based HUD
- **Multiple Levels**: Explore different environments with unique challenges
- **Enemy AI**: Face off against slime enemies with wandering behavior
- **Interactive Elements**: Interact with TVs and doors to progress
- **Win/Lose Conditions**: Complete levels by defeating all enemies or reaching objectives
- **Pause System**: Pause and resume gameplay at any time
- **Hint System**: Visual hints appear when near interactive objects

## Requirements

- **Godot Engine**: Version 4.5 or higher
- **OS**: Windows, macOS, or Linux

## Installation

1. Clone or download this repository
2. Open the project in Godot Engine 4.5
3. Click "Play" or press `F5` to run the game

## Controls

### Movement
- **W** or **Up Arrow** - Move Up
- **S** or **Down Arrow** - Move Down
- **A** or **Left Arrow** - Move Left
- **D** or **Right Arrow** - Move Right

### Actions
- **Z** or **Left Mouse Button** - Attack
- **X** - Interact (when near interactive objects like TVs/doors)
- **ESC** - Pause menu (during gameplay) / Return to Main Menu (in menus)

## Game Flow

1. **Main Menu** → Start the game
2. **Lobby** → Hub area where you can explore and interact with the TV
3. **Level Selection** → Choose which level to play
4. **Gameplay Level** → Fight enemies and complete objectives
5. **Win/Lose Screen** → Shows results and allows retry or return to lobby

## Project Structure

```
Skybound/
├── 00_Globals/              # Global managers (LevelManager, PlayerManager)
├── Enemies/                 # Enemy scripts and states
│   ├── Scripts/            # Enemy AI and state machine
│   └── Slime/              # Slime enemy assets
├── GeneralNodes/           # Reusable interaction nodes
│   ├── Hitbox/            # Player attack hitboxes
│   ├── Hurtbox/           # Damage detection areas
│   ├── TVInteraction/     # TV interaction system
│   └── WinInteraction/    # Win condition areas
├── GUI/                    # User interface screens
│   ├── ControlsScreen/    # Controls information
│   ├── LevelSelection/    # Level selection menu
│   ├── LoseScreen/        # Game over screen
│   ├── MainMenu/          # Main menu
│   ├── PauseScreen/       # Pause menu
│   ├── WinScreen/         # Victory screen
│   └── player_hud/        # In-game HUD (health, hints)
├── Levels/                 # Level scenes and scripts
│   ├── Level1/            # First gameplay level
│   ├── Level2/            # Second gameplay level
│   ├── Lobby/             # Lobby hub area
│   └── level_manager.gd   # Level-specific logic
├── Player/                 # Player character
│   ├── Scripts/           # Player scripts and state machine
│   ├── Sprites/           # Player sprite assets
│   └── Audio/             # Player audio files
├── Props/                  # Decorative objects
├── Tile Maps/             # Level tilemaps and tile sets
└── playground.tscn        # Testing/playground scene
```

## Core Systems

### Global Managers

- **LevelManager** (`00_Globals/GlobalLevelManager.gd`): Handles scene transitions, level state, and game flow
- **PlayerManager** (`00_Globals/global_player_manager.gd`): Manages player instance globally
- **PlayerHud** (`GUI/player_hud/player_hud.tscn`): Displays health and hints

### State Machines

- **Player State Machine**: Manages player states (Idle, Walk, Attack, Stun)
- **Enemy State Machine**: Manages enemy AI states (Idle, Wander, Stun, Destroyed)

### Interaction System

- **TVInteraction**: Area2D nodes that detect player proximity and trigger interactions
- **WinInteraction**: Similar to TVInteraction but for win conditions
- Visual hints appear when player enters interaction range

### Camera System

- **playerCamera.gd**: Camera follows player with bounds based on tilemap limits
- Supports different zoom levels per level
- Automatic bounds calculation from tilemaps

## Game Mechanics

### Health System
- Player starts with 6 HP (3 hearts)
- Hearts are displayed in the top-right HUD
- Health resets to max when returning to lobby or retrying a level
- Player dies when HP reaches 0, triggering the lose screen

### Win Conditions
- **Combat Levels**: Defeat all enemies on the map
- **Interaction Levels**: Reach the TV/door and press X to interact

### Pause System
- Press ESC during gameplay to pause
- Resume maintains exact game state (position, health, enemy positions)
- Options to Retry, Resume, or Return to Lobby

## Development Notes

- Game uses Y-sorting for proper depth rendering
- Collision layers:
  - Layer 1: Player
  - Layer 2: PlayerHurt (player's attack hitbox)
  - Layer 5: Walls
  - Layer 9: Enemy
- Tilemaps support multiple layers for visual depth
- Camera bounds are automatically calculated from tilemap data

## Future Enhancements

Potential areas for expansion:
- Additional enemy types
- More levels
- Player abilities/power-ups
- Inventory system
- Sound effects and music
- Save/load system

## License

[Add your license information here]

## Credits

[Add credits here]

---

**Note**: This is an alpha tech demo / playable prototype. The game is in active development.
