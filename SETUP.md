🏃 Sprint System – Setup & Architecture Guide

This sprint system is built with a layered architecture that separates
input handling (Client) and movement authority (Server) for security,
scalability, and clean code organization.

--------------------------------------------------

📁 1. ReplicatedStorage (Shared Modules)
--------------------------------------------------

Files inside ReplicatedStorage are accessible by both the Server and
Client. These modules do not run on their own and must be required
by other scripts.

Structure:

ReplicatedStorage
└── Modules
    ├── CalculatingOfWSModuleScript.luau
    │   - ModuleScript
    │   - Responsible for all movement speed calculations
    │     (walking speed, sprint speed, smoothing, stamina logic).
    │
    ├── FreshBodyModuleScript.luau
    │   - ModuleScript
    │   - Resets character-related properties when the player dies
    │     or respawns to ensure a clean state.
    │
    └── InputModuleScript.luau
        - ModuleScript
        - Handles input logic (Shift, Ctrl, etc.)
        - Fires sprint-related signals without directly changing speed.

ReplicatedStorage
└── ConfigModule.luau
    - ModuleScript
    - Centralized configuration file.
    - Controls values such as sprint speed, stamina limits,
      drain/recovery rates, and tuning variables.
    - Allows global behavior changes without touching core logic.

--------------------------------------------------

🛡️ 2. ServerScriptService (Server-Side Logic)
--------------------------------------------------

Scripts here run only on the server. This layer is responsible for
authoritative changes to player movement to prevent exploits
and desynchronization.

Structure:

ServerScriptService
└── Sprint System
    └── SprintServer.luau
        - Script (RunContext: Server)
        - Listens for sprint requests coming from the client.
        - Applies the actual WalkSpeed changes on the server.
        - Ensures all players see consistent movement behavior.

Why Server-Side?

- Prevents client-side speed hacking.
- Ensures replication consistency.
- Keeps movement logic authoritative and secure.

--------------------------------------------------

💻 3. StarterPlayerScripts (Client-Side Logic)
--------------------------------------------------

Scripts placed here are cloned to each player's client when they join
the game.

Structure:

StarterPlayer
└── StarterPlayerScripts
    └── main.luau
        - LocalScript
        - Acts as the client-side controller.
        - Listens to player input (e.g. Shift key).
        - Communicates sprint intent to the server.
        - Does NOT directly modify movement speed.

Why Client-Side?

- Instantly captures user input.
- Keeps input handling responsive.
- Avoids unnecessary server polling.

--------------------------------------------------

🛠️ Installation Summary
--------------------------------------------------

| File / Folder Name | Type         | Location             |
| ------------------ | ------------ | -------------------- |
| main.luau          | LocalScript  | StarterPlayerScripts |
| SprintServer.luau  | Script       | ServerScriptService  |
| Modules (Folder)   | Folder       | ReplicatedStorage    |
| ConfigModule.luau  | ModuleScript | ReplicatedStorage    |

--------------------------------------------------

✅ Design Goals
--------------------------------------------------

- Fully modular architecture
- Clear separation of responsibilities
- Server-authoritative movement
- Easy configuration via a single config module
- Scalable for large or narrative-driven projects
