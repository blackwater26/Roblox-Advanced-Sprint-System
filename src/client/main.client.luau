--[[
    Sprint Client
    Handles input, sends to server, and updates GUI
    Optimized with closure pattern for proper respawn handling
]]

--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

--// Modules
local UpdateGUI = require(ReplicatedStorage.Shared.Modules.UpdateGUI)
local Config = require(ReplicatedStorage.Shared.ConfigModule)

--// RemoteEvents
local sprintInputEvent = ReplicatedStorage:WaitForChild("SprintInputEvent")
local durabilityUpdateEvent = ReplicatedStorage:WaitForChild("DurabilityUpdateEvent")

--// Player
local player = Players.LocalPlayer

--// ReactUI Setup (with error handling)
if Config.ReactUI.ENABLED then
	local success, UIComponent = pcall(function()
		return require(ReplicatedStorage.Shared.Modules.GUI.UIComponent)
	end)

	if success and UIComponent and UIComponent.CreateScreenUI then
		pcall(function()
			UIComponent.CreateScreenUI()
		end)
	else
		warn("UIComponent not available - using fallback GUI")
	end
end

--// Mock system for GUI (receives server data)
local mockSprintSystem = {
	currentDurability = Config.Sprint.DURABILITY_MAX,
	DURABILITY_MAX = Config.Sprint.DURABILITY_MAX,
	isSprinting = false,
	SprintChanged = {
		Event = {
			Connect = function()
				return { Disconnect = function() end }
			end,
		},
		Fire = function() end,
	},
}

--// Init GUI (once)
task.spawn(function()
	UpdateGUI.Initialize(mockSprintSystem)
end)

--// Receive durability from server (global, character-independent)
durabilityUpdateEvent.OnClientEvent:Connect(function(durability, maxDurability)
	mockSprintSystem.currentDurability = durability
	mockSprintSystem.DURABILITY_MAX = maxDurability
end)

--// Character setup function (runs for each new character)
local function setupCharacter(character)
	local humanoid = character:WaitForChild("Humanoid")
	local connections = {}
	local isSprinting = false

	-- Auto-stop sprint when player stops moving (optimized: only runs when sprinting)
	table.insert(
		connections,
		RunService.Heartbeat:Connect(function()
			if isSprinting and humanoid.MoveDirection.Magnitude == 0 then
				isSprinting = false
				mockSprintSystem.isSprinting = false
				sprintInputEvent:FireServer(false)
			end
		end)
	)

	-- Sprint input (LeftShift) - Start
	table.insert(
		connections,
		UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if gameProcessed then
				return
			end
			if input.KeyCode == Enum.KeyCode.LeftShift and humanoid.MoveDirection.Magnitude > 0 then
				isSprinting = true
				mockSprintSystem.isSprinting = true
				sprintInputEvent:FireServer(true)
			end
		end)
	)

	-- Sprint input (LeftShift) - End
	table.insert(
		connections,
		UserInputService.InputEnded:Connect(function(input, gameProcessed)
			if gameProcessed then
				return
			end
			if input.KeyCode == Enum.KeyCode.LeftShift and isSprinting then
				isSprinting = false
				mockSprintSystem.isSprinting = false
				sprintInputEvent:FireServer(false)
			end
		end)
	)

	-- Cleanup when character dies/respawns
	character.AncestryChanged:Connect(function(_, parent)
		if not parent then
			for _, conn in ipairs(connections) do
				conn:Disconnect()
			end
			isSprinting = false
			mockSprintSystem.isSprinting = false
		end
	end)

	print("Sprint Client initialized for character:", character.Name)
end

--// Setup initial character
if player.Character then
	setupCharacter(player.Character)
end

--// Setup on respawn
player.CharacterAdded:Connect(setupCharacter)

print("Sprint Client initialized for", player.Name)
