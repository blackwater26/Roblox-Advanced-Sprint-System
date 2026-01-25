--[[
    Input Module
    Handles sprint input signals (alternative to main.luau direct input)
    Uses closure pattern to prevent stale references on respawn
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Signal = require(ReplicatedStorage.Packages._Index["sleitnick_signal@2.0.3"].signal)

local InputModule = {}
InputModule.SprintSignal = Signal.new()

--// Initialize sprint input handling with proper respawn support
function InputModule:Initialize()
	local player = Players.LocalPlayer

	local function setupCharacter(character)
		local humanoid = character:WaitForChild("Humanoid")
		local connections = {}

		-- InputBegan handler
		table.insert(
			connections,
			UserInputService.InputBegan:Connect(function(input, gameProcessed)
				if not gameProcessed and input.KeyCode == Enum.KeyCode.LeftShift then
					if humanoid.MoveDirection.Magnitude > 0 then
						self.SprintSignal:Fire(true)
					end
				end
			end)
		)

		-- InputEnded handler
		table.insert(
			connections,
			UserInputService.InputEnded:Connect(function(input, gameProcessed)
				if not gameProcessed and input.KeyCode == Enum.KeyCode.LeftShift then
					self.SprintSignal:Fire(false)
				end
			end)
		)

		-- Cleanup on character removal
		character.AncestryChanged:Connect(function(_, parent)
			if not parent then
				for _, conn in ipairs(connections) do
					conn:Disconnect()
				end
			end
		end)
	end

	-- Setup initial character
	if player.Character then
		setupCharacter(player.Character)
	end

	-- Setup on respawn
	player.CharacterAdded:Connect(setupCharacter)
end

return InputModule
