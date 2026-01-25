# Configuration Guide

The central configuration file for the Sprint System is located in `ConfigModule.luau`.

## 📍 File Location
```
src/shared/ConfigModule.luau
```

## ⚙️ Configuration Sections

### Sprint Mechanics (`Config.Sprint`)
Core settings that control sprint mechanics.

| Parameter | Default | Description |
|-----------|---------|-------------|
| `DURABILITY_MAX` | 100 | Maximum stamina value |
| `DURABILITY_OF_EXHAUSTION` | 45 | Exhaustion threshold (speed reduces below this value) |
| `DURABILITY_DRAIN_RATE` | 20 | Stamina drain rate while sprinting (per second) |
| `DURABILITY_RECOVER_RATE` | 12 | Stamina recovery rate (per second) |
| `MAX_RUNNING_SPEED` | 24 | Sprint speed |
| `NORMAL_WALKING_SPEED` | 16 | Normal walking speed |
| `LAST_SPEED_SMOOTH_RATE` | 8 | Speed transition smoothness (higher = faster transition) |
| `MAX_DT` | 0.05 | Maximum delta time (lag protection) |

### GUI Animation (`Config.GUI`)
GUI animation settings.

| Parameter | Default | Description |
|-----------|---------|-------------|
| `TWEEN_DURATION` | 0.3 | Animation duration (seconds) |
| `TWEEN_EASING_STYLE` | Quad | Animation style |
| `TWEEN_EASING_DIRECTION` | Out | Animation direction |
| `GUI_WAIT_TIMEOUT` | 5 | GUI loading timeout (seconds) |

### GUI Bar Appearance (`Config.Bar`)
Stamina bar appearance settings.

| Parameter | Default | Description |
|-----------|---------|-------------|
| `SIDE_PADDING` | 10 | Horizontal padding (pixels) |
| `TOP_BOTTOM_PADDING` | 3 | Vertical padding (pixels) |
| `ANCHOR_POINT` | (0, 0.5) | Bar anchor point |
| `POSITION_Y` | 0.5 | Bar Y position (0-1 range) |
| `TRANSPARENCY_HIDDEN` | 1 | Transparency when hidden |
| `TRANSPARENCY_VISIBLE` | 0 | Transparency when visible |

### React UI Support (`Config.ReactUI`)
React-based UI support.

| Parameter | Default | Description |
|-----------|---------|-------------|
| `ENABLED` | false | Enable React UI |
| `COMPONENT_NAME` | "SprintBar" | React component name |

### Server Settings (`Config.Server`)
Server-side settings.

| Parameter | Default | Description |
|-----------|---------|-------------|
| `CHARACTER_LOAD_DELAY` | 0.1 | Delay after character spawn (seconds) |
| `INPUT_RATE_LIMIT` | 0.1 | Minimum time between inputs (anti-exploit) |
| `DURABILITY_UPDATE_THRESHOLD` | 1 | Minimum stamina change to send to client |

## 🎯 Usage Example

```lua
local Config = require(ReplicatedStorage.Shared.ConfigModule)

-- Change sprint speed
Config.Sprint.MAX_RUNNING_SPEED = 30

-- Customize stamina settings
Config.Sprint.DURABILITY_MAX = 150
Config.Sprint.DURABILITY_DRAIN_RATE = 15

-- Enable React UI
Config.ReactUI.ENABLED = true
```

## 💡 Tips

- **Balance Settings**: Adjust game balance by changing the ratio between `DURABILITY_DRAIN_RATE` and `DURABILITY_RECOVER_RATE`.
- **Performance**: If `MAX_DT` is set too high, abnormal speed increases may occur during lag.
- **Anti-Exploit**: Keep `INPUT_RATE_LIMIT` low to provide spam protection.
- **React UI**: If using React, set `ENABLED = true` and remove traditional GUI elements.

## 🔗 Related Files

- `src/shared/ConfigModule.luau` - Main configuration file
- `src/shared/Modules/CalculatingWS.luau` - Sprint calculation module
- `src/shared/Modules/UpdateGUI.luau` - GUI update controller
