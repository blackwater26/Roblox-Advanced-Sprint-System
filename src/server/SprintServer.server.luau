-- SprintServer.server.luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

--// Modules
local ConfigModule = require(ReplicatedStorage.Shared.ConfigModule)
local CalculateWS = require(ReplicatedStorage.Shared.Modules.CalculatingWS)

--// RemoteEvents (create if not exists)
local sprintInputEvent = ReplicatedStorage:FindFirstChild("SprintInputEvent") or Instance.new("RemoteEvent")
sprintInputEvent.Name = "SprintInputEvent"
sprintInputEvent.Parent = ReplicatedStorage

local durabilityUpdateEvent = ReplicatedStorage:FindFirstChild("DurabilityUpdateEvent") or Instance.new("RemoteEvent")
durabilityUpdateEvent.Name = "DurabilityUpdateEvent"
durabilityUpdateEvent.Parent = ReplicatedStorage

--// Active player systems
local playerSystems = {}
local lastInputTime = {}
local lastSentDurability = {}

--// Setup sprint system for player
local function setupPlayer(player)
	local character = player.Character
	if not character then
		return
	end

	local humanoid = character:FindFirstChild("Humanoid")
	if not humanoid then
		return
	end

	-- Create sprint system for this player (using centralized config)
	local sprintSystem = CalculateWS.new(ConfigModule.Sprint)

	sprintSystem:Start()

	-- Store system
	playerSystems[player] = {
		system = sprintSystem,
		humanoid = humanoid,
		character = character,
	}

	-- Update walkspeed every frame
	local heartbeatConn = RunService.Heartbeat:Connect(function()
		if playerSystems[player] then
			local currentSpeed = sprintSystem:GetCurrentSpeed()
			humanoid.WalkSpeed = currentSpeed

			-- Send durability to client for GUI (only when changed - Network optimization)
			local dur = sprintSystem.currentDurability
			local threshold = ConfigModule.Server.DURABILITY_UPDATE_THRESHOLD
			if not lastSentDurability[player] or math.abs(dur - lastSentDurability[player]) >= threshold then
				lastSentDurability[player] = dur
				durabilityUpdateEvent:FireClient(player, dur, sprintSystem.DURABILITY_MAX)
			end
		end
	end)

	playerSystems[player].heartbeatConn = heartbeatConn

	print("Sprint system initialized for", player.Name)
end

--// Cleanup player system
local function cleanupPlayer(player)
	local data = playerSystems[player]
	if data then
		if data.system then
			data.system:Stop()
		end
		if data.heartbeatConn then
			data.heartbeatConn:Disconnect()
		end
		playerSystems[player] = nil
	end
end

--// Handle sprint input from client
sprintInputEvent.OnServerEvent:Connect(function(player, isSprinting)
	-- Rate limit: prevent spam (configurable anti-exploit)
	local now = tick()
	if lastInputTime[player] and now - lastInputTime[player] < ConfigModule.Server.INPUT_RATE_LIMIT then
		return
	end
	lastInputTime[player] = now

	local data = playerSystems[player]
	if not data then
		return
	end

	-- Validate input type
	if typeof(isSprinting) ~= "boolean" then
		warn("Invalid sprint input from", player.Name, "- Type:", typeof(isSprinting))
		return
	end

	-- Set sprinting state
	data.system:SetSprinting(isSprinting)
end)

--// Setup existing players
for _, player in pairs(Players:GetPlayers()) do
	if player.Character then
		setupPlayer(player)
	end

	player.CharacterAdded:Connect(function()
		task.wait(ConfigModule.Server.CHARACTER_LOAD_DELAY) -- Wait for character to fully load
		cleanupPlayer(player)
		setupPlayer(player)
	end)
end

--// Setup new players
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		task.wait(ConfigModule.Server.CHARACTER_LOAD_DELAY)
		setupPlayer(player)
	end)
end)

--// Cleanup on player leave
Players.PlayerRemoving:Connect(function(player)
	cleanupPlayer(player)
	lastInputTime[player] = nil
	lastSentDurability[player] = nil
end)

print("Sprint Server initialized")
