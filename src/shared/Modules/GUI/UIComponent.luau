local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)
local ConfigModule = require(ReplicatedStorage.Shared.ConfigModule)
local RootUI = require(ReplicatedStorage.Shared.Modules.GUI.app.RootUI)

function CreateScreenUI()
	local player = game:GetService("Players").LocalPlayer
	local gui = player:WaitForChild("PlayerGui")
	local container = Instance.new("ScreenGui")
	container.Name = ConfigModule.Config.ReactUI.COMPONENT_NAME
	container.IgnoreGuiInset = true
	container.ResetOnSpawn = true
	container.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	container.ClipToDeviceSafeArea = false
	container.Parent = gui
	local root = ReactRoblox.createRoot(container)
	local app = React.createElement(RootUI)
	root:render(app)
end
