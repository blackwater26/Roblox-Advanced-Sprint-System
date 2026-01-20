# Sprint System – Modular & Event-Driven

This sprint system is built with scalability, clarity, and production use in mind.
Rather than being a simple input-to-speed toggle, the system is designed as a decoupled architecture
where input, state, and behavior are isolated and communicate through signals.

The goal is to allow sprinting to act as a core gameplay mechanic that can safely evolve over time
without requiring rewrites to existing logic.

---

## Architecture Overview

The system is split into clear responsibilities:

- Input Layer  
  Handles raw player input and converts it into intent (e.g. sprint start / sprint end).
  This layer does not modify movement or player state directly.

- Sprint State Controller  
  Owns the authoritative sprint state.
  It decides when sprinting is active and exposes state changes through signals.

- Behavior / Consumers  
  Movement, stamina, UI, camera effects, animations, or modifiers subscribe to sprint state
  changes without tight coupling.

All communication is handled through signals, making the system predictable, testable,
and easy to extend.

---

## Configuration

The system includes a dedicated configuration layer (Configure) to avoid hardcoded values.

Through configuration you can:
- Adjust sprint behavior without touching core logic
- Enable or disable modifiers
- Tune values for different characters or game modes
- Reuse the same system across multiple projects with different parameters

This keeps iteration fast and reduces the risk of regressions.

---

## Design Goals

- Fully modular and reusable
- Event-driven with no hidden dependencies
- Easy to extend with stamina, buffs, debuffs, or abilities
- Safe for large-scale or narrative-driven projects
- Clean separation of concerns
- Production-ready structure suitable for long-term maintenance

---

## Intended Use

This system is designed to be:
- Integrated into larger gameplay frameworks
- Used as a foundation for complex movement systems
- Studied as a reference for modular Luau architecture

It is not a one-off script, but a reusable system meant to scale with project complexity.

---

## License

This project is licensed under the Mozilla Public License 2.0 (MPL 2.0).

You are free to use and integrate this system into your projects, provided that attribution
is preserved and modifications to the original source files remain open under the same license.
