-- AIM JAILBREAK | AIMLOCK ONLY + GUI FINAL (Eclipse - Allusive Style Fixed)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local TweenService = game:GetService("TweenService")

local LP = Players.LocalPlayer

-- ================= SETTINGS =================
local AIM_ON = false
local AIM_KEY = Enum.KeyCode.X
local PREDICTION = 0.08
local lockedPlayer = nil

-- ================= NOTIFICATION =================
local function createNotification(titleText, msgText, duration, callback)
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "EclipseNotification"
	screenGui.Parent = game.CoreGui
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 260, 0, 70)
	frame.Position = UDim2.new(1, -280, 1, -90)
	frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
	frame.BorderSizePixel = 0
	frame.ClipsDescendants = true
	frame.BackgroundTransparency = 1
	frame.Parent = screenGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0,12)
	corner.Parent = frame

	local uiStroke = Instance.new("UIStroke")
	uiStroke.Color = Color3.fromRGB(90,180,255)
	uiStroke.Thickness = 1
	uiStroke.Parent = frame

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1,0,0,25)
	title.Position = UDim2.new(0,0,0,0)
	title.BackgroundTransparency = 1
	title.Text = titleText
	title.Font = Enum.Font.GothamBold
	title.TextSize = 16
	title.TextColor3 = Color3.fromRGB(90,180,255)
	title.TextTransparency = 1
	title.Parent = frame

	local msg = Instance.new("TextLabel")
	msg.Size = UDim2.new(1,0,0,45)
	msg.Position = UDim2.new(0,0,0,25)
	msg.BackgroundTransparency = 1
	msg.Text = msgText
	msg.Font = Enum.Font.Gotham
	msg.TextSize = 14
	msg.TextColor3 = Color3.fromRGB(255,255,255)
	msg.TextWrapped = true
	msg.TextTransparency = 1
	msg.Parent = frame

	local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad)
	TweenService:Create(frame, tweenInfo, {BackgroundTransparency = 0.1}):Play()
	TweenService:Create(title, tweenInfo, {TextTransparency = 0}):Play()
	TweenService:Create(msg, tweenInfo, {TextTransparency = 0}):Play()

	task.delay(duration, function()
		local fadeOut = TweenInfo.new(0.5, Enum.EasingStyle.Quad)
		TweenService:Create(frame, fadeOut, {BackgroundTransparency = 1}):Play()
		TweenService:Create(title, fadeOut, {TextTransparency = 1}):Play()
		TweenService:Create(msg, fadeOut, {TextTransparency = 1}):Play()
		task.delay(0.5, function()
			frame:Destroy()
			screenGui:Destroy()
			if callback then
				callback()
			end
		end)
	end)
end

-- ================= GET PLAYER UNDER CROSSHAIR =================
local function isEnemy(p)
	return p.Team and LP.Team and p.Team ~= LP.Team
end

local function getPlayerUnderCrosshair()
	local mousePos = UserInputService:GetMouseLocation()
	local nearest, shortestDist
	for _,p in ipairs(Players:GetPlayers()) do
		if p ~= LP
			and isEnemy(p)
			and p.Character
			and p.Character:FindFirstChild("HumanoidRootPart")
			and p.Character:FindFirstChild("Head")
			and p.Character:FindFirstChild("Humanoid")
			and p.Character.Humanoid.Health > 0
		then
			local headPos, onScreen = Camera:WorldToViewportPoint(p.Character.Head.Position)
			if onScreen then
				local dist = (Vector2.new(headPos.X, headPos.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
				if not shortestDist or dist < shortestDist then
					shortestDist = dist
					nearest = p
				end
			end
		end
	end
	return nearest
end

-- ================= HOTKEY =================
UserInputService.InputBegan:Connect(function(input, gp)
	if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
	if input.KeyCode == AIM_KEY then
		if not AIM_ON then
			lockedPlayer = getPlayerUnderCrosshair()
		end
		AIM_ON = not AIM_ON
	end
end)

-- ================= AIMLOCK LOOP =================
RunService.RenderStepped:Connect(function()
	if AIM_ON and lockedPlayer and lockedPlayer.Character then
		local char = lockedPlayer.Character
		local head = char:FindFirstChild("Head")
		local hrp = char:FindFirstChild("HumanoidRootPart")
		local hum = char:FindFirstChild("Humanoid")

		if head and hrp and hum and hum.Health > 0 and isEnemy(lockedPlayer) then
			local aimPos = head.Position + (hrp.Velocity * PREDICTION)
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, aimPos)
		end
	end
end)

-- ================= MAIN GUI =================
local function createMainGUI()
	local gui = Instance.new("ScreenGui")
	gui.Name = "AimJailbreakGUI"
	gui.Parent = game.CoreGui
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true

	local board = Instance.new("Frame")
	board.Parent = gui
	board.Size = UDim2.new(0, 340, 0, 120)
	board.Position = UDim2.new(0.5, -170, 0.5, -60)
	board.BackgroundColor3 = Color3.fromRGB(30,30,30)
	board.BorderSizePixel = 0
	board.BackgroundTransparency = 1
	board.ZIndex = 10

	local grad = Instance.new("UIGradient")
	grad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(45,45,45)), ColorSequenceKeypoint.new(1, Color3.fromRGB(25,25,25))}
	grad.Rotation = 45
	grad.Parent = board

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0,14)
	corner.Parent = board

	local uiStroke = Instance.new("UIStroke")
	uiStroke.Color = Color3.fromRGB(90,180,255)
	uiStroke.Thickness = 1
	uiStroke.Parent = board

	-- Title
	local title = Instance.new("TextLabel")
	title.Parent = board
	title.Size = UDim2.new(1,0,0,30)
	title.Position = UDim2.new(0,0,0,5)
	title.BackgroundTransparency = 1
	title.Text = "Eclipse HUB"
	title.Font = Enum.Font.GothamBold
	title.TextSize = 18
	title.TextColor3 = Color3.fromRGB(90,180,255)
	title.TextTransparency = 1
	title.ZIndex = 11

	-- Status
	local statusLabel = Instance.new("TextLabel")
	statusLabel.Parent = board
	statusLabel.Size = UDim2.new(1,0,0,30)
	statusLabel.Position = UDim2.new(0,0,0,45)
	statusLabel.BackgroundTransparency = 1
	statusLabel.Text = "AIMLOCK: OFF [X]"
	statusLabel.Font = Enum.Font.Gotham
	statusLabel.TextSize = 16
	statusLabel.TextColor3 = Color3.fromRGB(255,80,80)
	statusLabel.TextTransparency = 1
	statusLabel.ZIndex = 11

	-- Credit
	local credit = Instance.new("TextLabel")
	credit.Parent = board
	credit.Size = UDim2.new(1,0,0,20)
	credit.Position = UDim2.new(0,0,0,80)
	credit.BackgroundTransparency = 1
	credit.Text = "Credit: Eclipse"
	credit.Font = Enum.Font.Gotham
	credit.TextSize = 14
	credit.TextColor3 = Color3.fromRGB(180,180,180)
	credit.TextTransparency = 1
	credit.ZIndex = 11

	-- Divider
	local divider = Instance.new("Frame")
	divider.Parent = board
	divider.Size = UDim2.new(1, -20, 0, 1)
	divider.Position = UDim2.new(0, 10, 0, 78)
	divider.BackgroundColor3 = Color3.fromRGB(90,180,255)
	divider.BorderSizePixel = 0
	divider.BackgroundTransparency = 0.3
	divider.ZIndex = 11

	local tweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Quad)
	TweenService:Create(board, tweenInfo, {BackgroundTransparency = 0.15}):Play()
	TweenService:Create(title, tweenInfo, {TextTransparency = 0}):Play()
	TweenService:Create(statusLabel, tweenInfo, {TextTransparency = 0}):Play()
	TweenService:Create(credit, tweenInfo, {TextTransparency = 0}):Play()
	TweenService:Create(divider, tweenInfo, {BackgroundTransparency = 0}):Play()

	-- Drag
	local dragging, dragStart, startPos
	board.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = i.Position
			startPos = board.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = i.Position - dragStart
			board.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	-- Update status label
	RunService.RenderStepped:Connect(function()
		statusLabel.Text = AIM_ON and "AIMLOCK: ON [X]" or "AIMLOCK: OFF [X]"
		statusLabel.TextColor3 = AIM_ON and Color3.fromRGB(80,255,120) or Color3.fromRGB(255,80,80)
	end)
end

-- ================= START =================
createNotification("Eclipse HUB", "Please wait 5 seconds...", 5, function()
	createMainGUI()
end)

print("Aim Jailbreak Season 30 | Aimlock loaded ✅")
